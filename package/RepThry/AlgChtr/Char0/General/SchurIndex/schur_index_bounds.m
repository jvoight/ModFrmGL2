freeze;

import "cyclo_gal.m": CycloGal_p, CycloGalStabilizer, CycloGalIndex,
CycloGalInField;
import "schur_subgroup.m": subgroup_search_cyclic_p;

forward put_multiplicities, scan_multiplicities;

Schur_index_bounds := function(chi:
	    Upper := 0, Lower:=1, Easy := false, Defect := false,
	    DegreeBound := -1)
    /* return upper, lower bounds for Schur index of chi over Q and Q_p */
    assert Type(chi) eq AlgChtrElt;
    // assert IsIrreducible(chi);
    R := Parent(chi);

    /* deal with p-groups */
    G_hash := GroupOrder(R);
    G_ord := Factorization(G_hash);
    if #G_ord le 1 then
        if #G_ord eq 0 or G_ord[1,1] ne 2 then
            return <1,1>, [], _, false;
        end if;
        i := Indicator(chi);
        if i ne -1 then
            return <1,1>, [], _, false;
        end if;
        if Easy then
            return <2,2>, [<0,2,2>,<2,1,2>], _, false;
        end if;
        if DegreeOfCharacterField(chi) eq 1 then
            return <2,2>, [<0,2,2>,<2,2,2>], _, false;
        else
            return <2,2>, [<0,2,2>], _, false;
        end if;
    end if;

    Z := Integers();
    deg := Z!Degree(chi);

    U := GCD(deg, Upper);
    L := Lower;

    /* Feit, from  Huppert 38.17 (a) */
    G_on_deg := (G_hash div KernelOrder(chi)) div deg;
    U := GCD(U, G_on_deg);

    /* Isaacs Chap 10 : Fein-Yamada bound */
    cl := ClassesData(R);
    E := LCM([t[1]: t in cl]);
    U := GCD(U, E);

    B := &* [ t[1]^(t[2] div 2) : t in G_ord ];
    U := GCD(U, B);

    /* L. Solomon: Isaacs (10.15) */
    B := EulerPhi( 2 * &*[ t[1] : t in G_ord ] );
    U := GCD(U, B);

    if U eq 1 then  return <1,1>,[],_, false; end if;

    /* Frobenius-Schur indicator + Brauer-Speiser bound,
	    Isaacs, Chap 5 + end of Chap 10, (b) */
    i := Indicator(chi);
    real_bound := [];
    if i eq -1 then assert IsEven(U); 
	U := 2; L := 2;
	real_bound := [<0,2,2>];
    elif i eq 1 then
	U := GCD(U, 2);
	if U eq 1 then return <1,1>,[],_, false; end if;
    end if;
    if Easy and U eq L then 
	return <L,U>, real_bound cat [<t[1],1,U>:t in G_ord],_, false;
    end if;

    do_mult := true;

    /* If q^a divides m(chi) and q^a > 2 then 
       exists prime p such that q^a | p-1 and G has an element of order pq^a
       Isaacs Exercise (10.11) is case when a = 1.  For general case: 
       P. Schmid, "Representation Groups for the Schur Index",
       J. Algebra 97 (1985), p101--115.  Application 3, p112.
     */
    if U gt 2 then
	Uf := Factorization(U);
	for ii := 1 to #Uf do
	    t := Uf[ii];
	    q := t[1];
	    qa := q^t[2];
	    while qa gt 2 do
		p_set := {p:s in G_ord | p mod qa eq 1 where p := s[1]};
		if exists{c:c in cl|c[1] mod qa eq 0 and c[1] div qa in p_set}
		then
		    break;
		else
		    U div:= q;
		    if U eq 1 then return <1,1>,[],_, do_mult; end if;
		    if U eq 2 then break ii; end if;
		    qa div:= q;
		end if;
	    end while;
	end for;
	if Easy and U eq L then 
	    return <L,U>, real_bound cat [<t[1],1,U>:t in G_ord],_, do_mult;
	end if;
    end if;

    C := CyclotomicField(chi);
    F := CharacterField(chi);
    assert F subset C;
    Corder := CyclotomicOrder(C);
    if IsOdd(Corder) then Corder *:= 2; end if;
    rational := Corder eq 2;
    has_i := Corder mod 4 eq 0 and RootOfUnity(4, C) in F;
    assert not rational or not has_i; // rational implies not has_i
    assert not has_i or i eq 0; // has_i implies i eq 0

    if DegreeBound eq -1 then DegreeBound := Ilog(100, G_hash) + 1; end if;
    do_mult := Degree(F) le DegreeBound;

    /* Benard & Schacher: Q(chi) contains a primitive m(chi)th root of 1 */
    U := GCD(U, Corder);
    if U gt 2 and F ne C then
	Uf := Factorization(U);
	changed := false;
	for i := 1 to #Uf do
	    p := Uf[i, 1]; e := Uf[i,2];
	    while e gt 0 and not RootOfUnity(p^e, C) in F
	    do
		changed := true;
		e -:= 1;
	    end while;
	    Uf[i,2] := e;
	end for;
	if changed then
	    U := &*[t[1]^t[2]:t in Uf];
	    if U eq 1 then return <1,1>,[],_, do_mult; end if;
	    if Easy and U eq L then 
		return <L,U>,real_bound cat [<t[1],1,U>:t in G_ord],_, do_mult;
	    end if;
	end if;
    end if;

    /* Fein's bound from Isaacs, end of Chap 10, (a) */
    chi_i := chi;
    principal := R!1;
    for i := 2 to 10 do
	chi_i := chi_i * chi;
	if GCD(U, i) ne U then
	    U := GCD(U, i*Z!InnerProduct(chi_i, principal));
	    if U eq 1 then return <1,1>,[],_, do_mult; end if;
	end if;
    end for;
    if Easy and U eq L then 
	return <L,U>, real_bound cat [<t[1],1,U>:t in G_ord],_, do_mult;
    end if;

    group := assigned R`Group;
    if group then G := R`Group; end if;
    if group or assigned R`PowerMap then
	/* try inner products with 1 chars of cyclic subgroups */
	pm := PowerMap(R);
	cpg := ClassPowerGroup(R);
	cyc_subs := [t[2]:t in OrbitRepresentatives(cpg)|t[2] ne 1];
	for i in cyc_subs do
	    cc := cl[i];
	    n := cc[1];
	    counts := {* pm(i,j) : j in [0..n-1] *};
	    supp := MultisetToSet(counts);
	    ip := 0;
	    for s in supp do ip +:= chi[s] * Multiplicity(counts, s); end for;
	    ip := Z!(ip / n);
	    U := GCD(U, ip);
	    if U eq 1 then return <1,1>,[],_, do_mult; end if;
	end for;
	if Easy and U eq L then 
	    return <L,U>,
		real_bound cat [<t[1],1,U>:t in G_ord],_, do_mult;
	end if;
    end if;

    /* Shift to local stuff. 
     * We've checked the indicator, so we know m_R(chi).
     * Try to use Feit's theorems to get bounds for m_p(chi)
     *
     * See:
     * Walter Feit, The computation of some Schur indices,
     * Israel J. Math. 42 (1983), 274-300.
     * The following uses Corollary 3.2 of this paper, which 
     * allows to test value of characters in the same p-block
     * as chi, rather than all irreducibles.
     */

    remove_ones := procedure(~list)
	local i;
	i := 1;
	while i le #list do
	    if list[i,3] eq 1 then
		Remove(~list, i);
	    else
		i +:= 1;
	    end if;
	end while;
    end procedure;

    /* set up list of Schur indices over completions of Q */
    /* Use bounds from Lorenz. Can ignore primes where chi has defect zero */

    /* Do our best for p = 2 */
    if IsEven(G_on_deg) then
	B2 := IsOdd(U) or has_i select 1 else 2;
	if B2 eq 2 then
	    /* abelian 2-Sylow implies m_2(chi) eq 1: Yamada 1978 */
	    /* height 0 implies m_2(chi) eq 1: Geline & Gluck 2010 */
	    X := CharacterTable(R);
	    _, d := Block(X, Index(X, chi), 2);
	    h := Valuation(deg, 2) - Valuation(G_hash, 2) + d;
	    B2 := h eq 0 or (group and IsAbelian(Sylow(Group(R),2)))
		select 1 else 2;
	end if;
    else
	B2 := 1;
    end if;
    list := [ <p,1,B> : p in PrimeDivisors(G_on_deg) | B ne 1 where 
	B := p eq 2 select B2 else GCD(U, p-1)] cat real_bound;
    delete real_bound;
    if rational and do_mult and #list le 1 then 
	return <1,1>,[],_, do_mult;
    end if;
    if #list eq 0 then U := 1; else U := LCM([t[3]:t in list]); end if;
    if U eq 1 or Easy and U eq L then 
	return <L,U>, [<t[1],t[2],t[3]>:t in list], _, do_mult;
    end if;

    /* Do easy case of Feit's bound: integral classes - just needs Theorem A */
    easy := IntegralClasses(R);
    for c in easy do
	chi_val := Abs(Z!chi[c]);
	if chi_val mod U eq 0 then // no good can come of this!
	    continue;
	end if; 
	cc := cl[c];
	for i := 1 to #list do
	    p := list[i,1];
	    if p ne 0 and cc[1] mod p ne 0 then
		list[i,3] := GCD(list[i,3], chi_val);
	    end if;
	end for;
    end for;
    remove_ones(~list);
    if #list eq 0 then return <1,1>,[],_, do_mult; end if;
    U := LCM([t[3]:t in list]);
    if U eq 1 or (rational and #list le 1 and do_mult) then
	return <1,1>,[],_,do_mult;
    end if;
    if Easy and U eq L then 
	return <L,U>, [<t[1],t[2],t[3]>:t in list], _, do_mult;
    end if;

    CPG := ClassPowerGroup(R);
    OR := OrbitRepresentatives(CPG);
    hard := [t[2]:t in OR|t[1] gt 1 ];
    X := CharacterTable(R);
    K := CyclotomicField(chi);
    pos := Position(X, chi);
    assert pos ge 1;
    Q := [t[1]:t in list|t[1] ne 0];
    if #Q eq 0 then blocks := []; else
	blocks := Block(X, pos, Q);
    end if;
    new_list := [];
    b := 1;
    for t in list do
	if t[1] eq 0 then 
	    Append(~new_list, Append(t, {Z|}));
	else
	    Append(~new_list, Append(t, blocks[b]));
	    b +:= 1;
	end if;
    end for;
    list := new_list;
    if do_mult then
	Kchi := CharacterField(chi);
	Rchi := IntegerRing(Kchi);
	for c in hard do
	    if chi[c] eq 0 then continue; end if; // no good can come of this!
	    cc := cl[c];
	    if assigned Rval then delete Rval; end if;
	    Utest := true;
	    for i := 1 to #list do
		p := list[i,1];
		if p eq 0 or list[i,3] eq 1 or cc[1] mod p eq 0 then
		/* Feit's bound either doesn't apply or will get us nowhere */
		    continue i;
		end if;
		if not assigned Rval then Rval := Rchi!Kchi!K!chi[c]; end if;
		if Utest then
		    if IsDivisibleBy(Rval, Rchi!U) then
			continue c;
		    else
			Utest := false;
		    end if;
		end if;
		if IsDivisibleBy(Rval, Rchi!list[i,3])
		then
		    /* Feit's bound will get us nowhere */
		    continue i;
		end if;
		/* this class is a p-regular class */
		/* Test: are the values on class c in Q_p(chi)? */
		gal := CycloGal_p(p, LCM(Corder, cl[c,1]));
		gal := CycloGalStabilizer(gal, chi);
		/* Do the test for membership */
		if not CycloGalInField(gal, [* X[j,c]: j in list[i,4] *]) then
		    continue i;
		end if;

		/* if we get to here then psi(cc[3]) is in Q_p(chi) for all psi in 
		 * the p-block containing chi, so Feit Corollary 3.2 applies,
		 * i.e. m_p(chi) divides chi(cc[3]) in Rchi.
		 */
		divisors := Divisors(list[i,3]); 
		divisors := [d: d in divisors | IsDivisibleBy(Rval, Rchi!d)];
		list[i,3] := LCM(divisors);
		assert list[i,3] eq Max(divisors);
		// "class", c, "p =", p, "new bound", list[i,3];
	    end for;
	    U := LCM([t[3]:t in list]);
	    remove_ones(~list);
	    if U eq 1 or (rational and #list le 1 and do_mult) then
		return <1,1>,[],_, do_mult;
	    end if;
	    if Easy and U eq L then 
		return <L,U>, [<t[1],t[2],t[3]>:t in list|t[3] ne 1],_, do_mult;
	    end if;
	end for;
    end if;

    remove_ones(~list);
    for i := 1 to #list do
	p := list[i,1];
	if p eq 0 or list[i,2] eq list[i,3] then continue i; end if;
	defect := [Z | G_hash / Degree(X[j]) : j in list[i,4]];
	defect := Max([Valuation(d, p):d in defect]);
	if not ( defect eq 1 or (group and (IsCyclic(Sylow(Group(R),p)) or
		    (Defect and IsCyclic(DefectGroup(X, list[i,4], p))))))
	then
	    continue i;
	end if;
	/*
	 * Now: p-block containing chi has cyclic defect groups.
	 *
	 * We can compute m_p(chi) exactly by a theorem of Benard
	 * (see Feit op. cit. Theorem 2.12)
	 *
	 * The Schur index is the degree of the field extension
	 * Q_p(chi, phi)/Q_p(chi), where phi is any irreducible Brauer 
	 * character in the block.
	 *
	 * Furthermore, F = Q_p(phi) does not depend on the choice of phi, so
	 * F = Q_p(phi, all phi in block) = Q_p(psi, all psi in block),
	 * where psi are the restrictions to p-regular classes of 
	 * ordinary irreducibles, since the sets {phi} and {psi} are
	 * integer linear combinations of each other. This means there
	 * is enough information in the character table to compute
	 * m_p(chi) = [Q_p(chi, phi):Q_p(chi)], even if we don't find
	 * any particular phi.
	 */

	// printf "cyclic defect group, computing m_%o\n", p;

	if #list[i,4] le 2 then
	    /*
	     * This block has a unique modular irreducible. Thus
	     * m_p(chi) = 1, as chi is an integer multiple of the unique
	     * phi in this block.
	     */
	    list[i,3] := 1;
	    U := LCM([t[3]:t in list]);
	    if Easy and U eq L then 
		return <L,U>, [<t[1],t[2],t[3]>:t in list|t[3] ne 1],_, do_mult;
	    end if;
	    continue i;
	end if;
	p_reg_h := [j: j in hard | cl[j,1] mod p ne 0];
	if #p_reg_h eq 0 then
	    /* all p-regular classes are integral */
	    list[i,3] := 1;
	    U := LCM([t[3]:t in list]);
	    if Easy and U eq L then 
		return <L,U>, [<t[1],t[2],t[3]>:t in list|t[3] ne 1],_, do_mult;
	    end if;
	    continue i;
	end if;
	phi := 0;
	if (group and Type(G) eq GrpPC) or
	    exists(phi){X[j]:j in list[i,4]|IsLinear(X[j])} or
	    (group and IsSoluble(G))
	then
	    /*
	     * If phi is linear then
	     * phi is a linear character in the same block as chi
	     * and is hence an irreducible Brauer character
	     *
	     * If phi has degree 2, then the block has no ordinary
	     * linear  characters, hence no modular linear characters,
	     * and must have a Brauer irred of degree 2 which is given by phi.
	     */
	    if not assigned phi or phi cmpeq 0 then
		/* G is soluble, so minimal degree chtr in block is a
		 *  Brauer irred
		 */
		blk := Setseq(list[i,4]);
		_,j := Min([Integers()|Degree(X[j]):j in blk]);
		phi := X[blk[j]];
	    end if;
	    phi := BrauerCharacter(phi, p);
	    n := LCM(Corder, CyclotomicOrder(CyclotomicField(phi)));
	    Gamma := CycloGal_p(p, n);
	    vals := [chi[j]:j in hard];
	    Gamchi := CycloGalStabilizer(Gamma, vals);
	    vals := [phi[j]:j in p_reg_h];
	    Delta := CycloGalStabilizer(Gamchi, vals);
	    m := CycloGalIndex(Gamchi, Delta);
	    // printf "m_%o(chi)=%m\n", p, m;
	    assert list[i,3] mod m eq 0;
	    list[i,2] := m;
	    list[i,3] := m;
	    L := LCM(L, LCM([t[2]:t in list]));
	    U := LCM([t[3]:t in list]);
	    if Easy and U eq L then 
		return <L,U>, [<t[1],t[2],t[3]>:t in list|t[3] ne 1],_, do_mult;
	    end if;
	    continue i;
	end if;

	/* Can't find an excuse not to run over all characters in the block */
	n := Corder;
	for j in list[i,4] do
	    phi := BrauerCharacter(X[j], p);
	    n := LCM(n, CyclotomicOrder(CyclotomicField(phi)));
	end for;
	Gamma := CycloGal_p(p, n);
	vals := [chi[j]:j in hard];
	Gamchi := CycloGalStabilizer(Gamma, vals);
	Delta := Gamchi;
	for j in list[i,4] do
	    phi := X[j];
	    if phi eq chi then continue j; end if;
	    vals := [phi[k]:k in p_reg_h];
	    Delta := CycloGalStabilizer(Delta, vals);
	end for;
	m := CycloGalIndex(Gamchi, Delta);
	assert list[i,3] mod m eq 0;
	assert m mod list[i,2] eq 0;
	list[i,2] := m;
	list[i,3] := m;
	L := LCM(L, LCM([t[2]:t in list]));
	U := LCM([t[3]:t in list]);
	if Easy and U eq L then 
	    return <L,U>, [<t[1],t[2],t[3]>:t in list|t[3] ne 1],_, do_mult;
	end if;
	continue i;
    end for;

    remove_ones(~list);
    if do_mult then
	if rational and #list le 1 then return <1,1>,[],_,do_mult; end if;
	list := put_multiplicities(list, chi, rational, Kchi);
	scan_multiplicities(~L, ~U, ~list, ~fin);
	if fin then return <L,U>, [t:t in list|t[3] ne 1],_, do_mult; end if;
    end if;
    if Easy and U eq L then 
	return <L,U>, [t:t in list|t[3] ne 1],_, do_mult;
    end if;

    if group then
    sub_list := [* *];
    for l := 1 to #list do
	t := list[l];
	p := t[1];
	if p eq 0 or t[2] eq t[3] then continue l; end if;
	q_list := PrimeDivisors(t[3] div t[2]);
	for q in q_list do
	    cyc := subgroup_search_cyclic_p(chi, p, q);
	    if #cyc eq 0 then continue q; end if;
	    /*
	     * Have "found" useful subgroup/irred pair.
	     * In some cases can deduce that q-part of m_p(chi) = 1.
	     * (a) subgroup is cyclic
	     * (b) p is odd and q doesn't divide p-1 (Lorenz 2.3.2)
	     * (c) p doesn't divide the subgroup order (as used above)
	     * [Note: q not dividing the subgroup order implies a cyclic
	     *  group, so no explicit test]
	     */
	    if exists{t:t in cyc| /* (a) */ #t[5] eq 0 or 
		    /* (b) */ (IsOdd(p) and (p-1) mod q ne 0) or
		    /* (c) */ (cl[t[3],1] mod p ne 0 and t[6] mod p ne 0)}
	    then
		/* q part is 1 */
		_, t[3] := Valuation(U, q);
		list[l] := t;
		U := LCM([u[3]:u in list]);
		if U eq 1 or (rational and #list le 1) then 
		    return <1,1>,[],_, do_mult;
		end if;
		if Easy and U eq L then 
		    return <L,U>, [t:t in list|t[3] ne 1],_, do_mult;
		end if;
	    else
		sub_list cat:= cyc;
	    end if;
	end for;
    end for;
    end if;

    if do_mult then
	scan_multiplicities(~L, ~U, ~list, ~fin);
	if fin then return <L,U>, [t:t in list|t[3] ne 1],_, do_mult; end if;
    end if;

    // [t:t in list|t[3] ne 1];
    /* unresolved as yet, returning upper, lower and local upper bounds */
    if assigned sub_list then
	return <L,U>, [t:t in list|t[3] ne 1],sub_list, do_mult;
    else
	return <L,U>, [t:t in list|t[3] ne 1],_, do_mult;
    end if;

end function;

put_multiplicities := function(list, chi, rational, Qchi)
    new_list := [];
    if rational then
	for i := 1 to #list do
	    t := list[i];
	    Append(~new_list, <t[1],t[2],t[3],1>);
	end for;
	return new_list;
    end if;
    assert Degree(Qchi) gt 1;
    R := IntegerRing(Qchi);
    for i := 1 to #list do
	t := list[i];
	if t[1] eq 0 then
	    u := <t[1],t[2],t[3], #InfinitePlaces(Qchi)>;
	else
	    u := <t[1],t[2],t[3], #Factorization(ideal<R|t[1]>)>;
	end if;
	Append(~new_list, u);
    end for;
    return new_list;
end function;

scan_multiplicities := procedure(~L, ~U, ~list, ~finished)
    base_m := 1; unknown := []; known := [];
    poss := [];
    for i := 1 to #list do
	t := list[i];
	assert t[3] mod t[2] eq 0;
	if t[2] eq t[3] then
	    base_m := LCM(base_m, t[2]);
	    Append(~known, t);
	else
	    Append(~unknown, t);
	    Append(~poss, [t[2]*d: d in Divisors(t[3] div t[2])]);
	    if #unknown gt 5 then return; end if;
	end if;
    end for;
    len := #unknown;
    if len eq 0 then finished := true; return; end if;
    if &*[#p: p in poss] gt 100 then return; end if;
    current := [1:i in [1..len]];
    could_be := [];
    keep_going := true;
    while keep_going do
	trial :=[poss[i, current[i]]: i in [1..len]];
	trial_m := LCM(trial); trial_m := LCM(trial_m, base_m);
	fact := Factorization(trial_m);
	keep := trial_m mod L eq 0 and U mod trial_m eq 0;
	for pr in fact do
	    if not keep then break; end if;
	    q := pr[1]^pr[2];
	    c := [t[4]: t in known | t[3] mod q eq 0 ];
	    if #c eq 0 then
		count := 0;
	    else
		count := &+ c;
	    end if;
	    c := [unknown[i,4]: i in [1..len] | trial[i] mod q eq 0];
	    if #c gt 0 then count +:= &+ c; end if;
	    keep := count gt 1 and (q ne 2 or count mod 2 eq 0);
	end for;
	if keep then
	    Append(~could_be, trial);
	    if #could_be gt 10 then return; end if;
	end if;
	u := 1;
	while u le len do
	    if current[u] lt #poss[u] then
		current[u] +:= 1;
		break;
	    end if;
	    current[u] := 1;
	    u +:= 1;
	end while;
	keep_going := u le len;
    end while;
    for i := 1 to len do
	t := unknown[i];
	v := [c[i]:c in could_be];
	t[2] := GCD(v);
	t[3] := LCM(v);
	Append(~known, t);
    end for;
    U := LCM([t[3]:t in known]);
    L := LCM([t[2]:t in known]);
    finished := forall{t:t in known|t[2] eq t[3]};
    list := known;
end procedure;

intrinsic SchurIndicesBounds(x::AlgChtrElt) -> SeqEnum
{}
    fl, si := HasAttribute(x, "SchurIndices");
    if fl then
	return [<t[1],t[2],t[2]> : t in si];
    end if;
    _, b := Schur_index_bounds(x);
    b := [<t[1],t[2],t[3]> : t in b];
    Sort(~b);
    if forall{t : t in b | t[2] eq t[3]} then
	x`SchurIndices := [ <t[1],t[2]> : t in b ];
    end if;
    return b;
end intrinsic;
