freeze;

declare verbose DFA, 1;

/* This file contains functions for manipulating deterministic finite state
 * automata.
 * Unfortunately there is more than one definition of this:
 * In the complete model, all state/alphabet transitions must be defined,
 * and in the partial model they are allowed to be undefined.
 * The partial model is more convenient for computation and agrees with
 * existing concepts such as coset tables, so we use that.
 * One slightly unfortunate consequence is that the minimal automaton with
 * empty language has no states, so we need to allow 0 or 1 initial states.
 *
 * Most of the information is in the "transitions" component of the record.
 * This is a list of lists, with each sublist of length the alphabet size,
 * and transitions[i][j] is the target of the transition from alphabet
 * number j on state number i. A value of 0 means that this is undefined.
 *
 * The "states" and "alphabet" components need not be used. They are there
 * to identify what the  states and alphabet correspond to - for example,
 * members of the alphabet might be generators of a group.
 *
 * There should probably be other components to record things like whether
 * the fsa is known to minimal.
 *
 * Many of the functions here, such as minimization, would ideally be
 * put into C.
 */

DFAREC := recformat<
      initial: SetEnum,  //must have size 0 or 1 - usually 1.
      final: SetEnum,
      alphabetsize : RngIntElt, //we need that only for case of no states
      transitions:  SeqEnum,
      alphabet: SeqEnum,
      states: SeqEnum >;

intrinsic IsAcceptedWordDFA(dfa::Rec, w::SeqEnum) -> BoolElt
{Is word w in language of dfa?}
  local tab, st;
  if #dfa`initial eq 0 then
    return false;
  end if; 
  tab := dfa`transitions;
  st := Representative(dfa`initial);
  for x in w do
    st := tab[st][x];
    if st eq 0 then return false; end if;
  end for;
  return st in dfa`final;
end intrinsic;

intrinsic MinimizeDFA(dfa::Rec) -> Rec
{Return DFA with minimal number of states with same language as dfa}
  //i.e. compute dfa with same language and minimal number of states
  local ans, ns, ng, tab, init, final, acc, queue, ct, st, iters,
        newfinal, newinit, ctab, oldncs, ncs, p, fs;
  assert Type(dfa) eq Rec; assert #dfa`initial le 1; 
  tab := dfa`transitions;
  ns := #tab;
  ans := rec<  DFAREC | alphabetsize := dfa`alphabetsize >;
  if assigned dfa`alphabet then ans`alphabet := dfa`alphabet; end if;
  if #dfa`initial eq 0 then
    ans`initial:={}; ans`final:={}; ans`transitions:=[];
    return ans;
  end if; 
  init := Representative(dfa`initial);
  //it is more convenient to make failure state a new state in this function.
  ns +:= 1;
  ng := dfa`alphabetsize;
  Append(~tab,[0 : i in [1..ng]]);
  for s in [1..ns] do for g in [1..ng] do
    if tab[s][g] eq 0 then tab[s][g]:=ns; end if;
  end for; end for;
  final := [ false: i in [1..ns]];
  for s in dfa`final do final[s] := true; end for; 
  //need to determine which states are accessible
  acc := [false: i in [1..ns]];
  queue := [init];
  ct := 0;
  while ct lt #queue do
    ct +:= 1;
    st := queue[ct];
    acc[st] := true;
    for i in [1..ng] do if not acc[ tab[st][i] ] then
      acc[ tab[st][i] ] := true;
      Append(~queue, tab[st][i]);
    end if; end for;
  end while;
  acc[ns] := true; //convenient

  if not exists{s : s in [1..ns] | acc[s] and final[s] } then //empty language
    ans`initial:={}; ans`final:={}; ans`transitions:=[];
    return ans;
  end if;
  stclno := [ acc[s] and final[s] select 1 else 2 : s in [1..ns] ];
  ncs := 2;
  iters := 0;
  repeat
    lookup := {@ @};
    iters +:= 1;
    oldncs := ncs; ncs := 0;
    clid := [];
    nstclno := [];
    for s in [1..ns] do if acc[s] then //not interested in inaccessible states
      clid := [stclno[row[g]]:g in [1..ng]] where row := tab[s];
      clid[ng+1] := stclno[s];
      p := Index(lookup, clid);
      if p eq 0 then
        Include(~lookup, clid);
        ncs +:= 1;
        p := ncs;
      end if;
      nstclno[s] := p;
    end if; end for;
    stclno := nstclno;
  until ncs eq oldncs;
  newtab := [x:x in lookup];
  delete lookup;
  fs := stclno[ns];
  for s in [1..ncs] do if acc[s] then
      row := Prune(newtab[s]);
      for g in [1..ng] do
        if row[g] eq fs then row[g] := 0;
        elif row[g] gt fs then row[g] -:= 1;
        end if;
      end for;
      newtab[s] := row;
  end if; end for;
  for s in [1..ns] do if acc[s] then
     if stclno[s] gt fs then stclno[s] -:= 1; end if;
  end if; end for;
  newtab := [newtab[i] : i in [1..fs-1]] cat [newtab[i] : i in [fs+1..ncs]];
  ans`transitions := newtab;
  ans`initial := {stclno[init]};
  ans`final := {stclno[s]: s in dfa`final | acc[s]};
  vprintf DFA, 1: "%o iterations", iters;
  return ans;
end intrinsic;

intrinsic StandardFormDFA(dfa::Rec) -> Rec
{Return DFA in standard form with same number of states and same language as
dfa. Standard form means that the initial state is number 1, and the states
appear in increasing order in the transition table}
  local tab, ns, ng, ans, perm, ct, st, im, newtab;
  assert Type(dfa) eq Rec; assert #dfa`initial le 1;
  tab := dfa`transitions;
  ns := #tab;
  ans := rec<  DFAREC | alphabetsize := dfa`alphabetsize >;
  if assigned dfa`alphabet then ans`alphabet := dfa`alphabet; end if;
  if #dfa`initial eq 0 then
    ans`initial:={}; ans`final:={}; ans`transitions:=[];
    return ans;
  end if; 
  ng := dfa`alphabetsize;
  perm := {@ Representative(dfa`initial) @};
  ct := 0;
  repeat
    ct +:= 1;
    st := perm[ct];
    for g in [1..ng] do
      im := tab[st][g];
      if im ne 0 and not im in perm then
        Include(~perm, im);
        if #perm eq ns then break; end if;
      end if;
    end for;
  until #perm eq ns;
  //now renumber everything - first invert state permutation
  perm := Eltseq( (Sym(ns)!perm)^-1 );
  ans`initial := { 1 };
  ans`final := { perm[t] : t in dfa`final };
  newtab := tab;
  for s in [1..ns] do
    st := perm[s];
    for g in [1..ng] do
      im := tab[s][g];
      newtab[st][g] := im eq 0 select 0 else perm[im];
    end for; 
  end for;
  ans`transitions := newtab;
  return ans;
end intrinsic;

intrinsic EqualDFA(dfa1::Rec, dfa2::Rec) -> BoolElt
{Are the languages of dfa1 and dfa2 equal?}
  local m1, m2;
  assert Type(dfa1) eq Rec; assert #dfa1`initial le 1;
  assert Type(dfa2) eq Rec; assert #dfa2`initial le 1;
  assert dfa1`alphabetsize eq dfa2`alphabetsize;
  m1 := StandardFormDFA(MinimizeDFA(dfa1));
  m2 := StandardFormDFA(MinimizeDFA(dfa2));
  return m1`final eq m2`final and m1`transitions eq m2`transitions;
end intrinsic;

intrinsic LanguageDFA(dfa::Rec, min::RngIntElt, max::RngIntElt :
                      words := false) -> SetEnum
{Set of words in language of dfa with lengths from min to max. If word is true
then members of dfa`alphabet should be group elements, and language is returned
as group elements. Otherwise returned as integer lists.}
  local alph, tab, init, acc, ng, lang, cword, elt, done, backtrack, cstate, i,
        clength, fe;
  assert Type(dfa) eq Rec; assert #dfa`initial le 1;
  if words then
    assert assigned dfa`alphabet and #dfa`alphabet eq dfa`alphabetsize;
    alph := dfa`alphabet;
  end if;
  tab := dfa`transitions;
  if #dfa`initial eq 0 then
    return {};
  end if;
  init := Representative(dfa`initial);
  acc := dfa`final;
  ng := dfa`alphabetsize;
  lang := {};
  // cword will be the current word in the search (as list of integers)
  // clength its current length, and cstatelist the list of states of dfa
  // arising when scanning the word.
  cword := [Integers()|];
  cstatelist := [init];
  clength := 0;
  done := false;
  while not done do
  // first check if we want the current word.
     if clength ge min and cstatelist[clength+1] in acc then
       if words then
         elt := cword eq [] select alph[1]^0 else &*[alph[w] : w in cword]; 
         Include(~lang, elt);
       else 
         Include(~lang, cword);
       end if;
     end if;
  // now proceed to next word in search.
     fe := 1;
     backtrack:=true;
     while backtrack and not done  do
       if clength lt max then
         cstate := cstatelist[clength+1];
         i := fe;
         while backtrack and i le ng do
           if tab[cstate][i] gt 0 then
           // found next node
             clength +:= 1;
             cword[clength] := i;
             cstatelist[clength+1] := tab[cstate][i];
             backtrack := false;
           end if;
           i +:= 1;
         end while;
       end if;
       if backtrack then
         if clength eq 0 then
           done := true;
         else
           fe := cword[clength]+1;
           Prune(~cword);
           clength -:= 1;
         end if;
       end if;
     end while;
  end while;
  return lang;
end intrinsic;

intrinsic WordCount(dfa::Rec, len::RngIntElt) -> SeqEnum
{returns list l of length len+1 where l[i] is number of words of length i-1
in the language of dfa}
  local sct, nsct, lct, tab, ns, ng, n, row; 
  assert Type(dfa) eq Rec; assert #dfa`initial le 1;
  tab := dfa`transitions;
  ns := #tab;
  if #dfa`initial eq 0 then
    return [ 0 : i in [1..len+1] ];
  end if;
  init := Representative(dfa`initial);
  return LanguageCountInternal(init, dfa`transitions, dfa`final, len);
end intrinsic;

intrinsic GrowthFunctionDFA(dfa::Rec) -> FldFunRatUElt
{The growth function of the given DFA}

  local tab, ns, ds, lct, F, prod, vecs, vec, M, sol,
        den, num, dd, dn, p, isc, N; 
  require #dfa`initial le 1: "Number of initial states must be at most 1";
  tab := dfa`transitions;
  ns := #tab;
  F := FunctionField(Integers());
  if #dfa`initial eq 0 then
    return F!0;
  end if;
  x := F.1;
  lct := WordCount(dfa, 2*ns-1);
  if forall{i:i in [ns+1..2*ns] | IsZero(lct[i])} then
    /* finite language */
    return &+[lct[i]*x^(i-1):i in [1..ns]];
  end if;
  //set up
  //system of equations to solve for recursion between elements of lct.
  //numerator of growth function has degree at most ns-1,
  //denominator has degree at most ns
  //We first solve modulo a prime, to estimate the degree of the denominator
  p := 32717;
  M := CyclicShiftsMatrix(GF(p), ns, ns, lct);
  vprint DFA, 1: "Have matrix over prime field";
  vec := -Vector(GF(p), lct[ns+1..2*ns]);
  isc, sol, N := IsConsistent(M, vec);
  assert isc;
  ReduceVector(N, ~sol);

  assert not IsZero(sol); //because we've taken out the finite language case

  ds := Depth(sol);
  dd := Max( ns-ds+1, 1); //upper bound on denominator
  P := PolynomialRing(GF(p));
  z := P.1;
  den := 1 + z*P!Reverse(Eltseq(sol));
  assert Degree(den) eq dd;
  num := den * P!lct[1..ns];
  num := P!Eltseq(num)[1..ns];
  dn := Degree(num);
  assert dn lt ns;
  dn := Max(dn, dd-1);
  vprintf DFA, 1:
     "Have solution mod prime. Degrees: %o/%o\n", dn, dd;
  // dd is likely to be correct. We also use dd as initial numerator
  // estimate, but that may be wrong. Numerator can have degree at most ns-1.
  // billu added code to estimate degree of numerator (after a couple of
  // bad experiences). dn is this estimate.
  repeat 
    M := CyclicShiftsMatrix(dd, dd, lct[dn-dd+2..dn+dd]);
    vprint DFA, 1: "Have matrix over integers";
    vec := -Vector(Integers(), lct[dn+2..dn+dd+1]);
    isc, sol, N := IsConsistent(M, vec);
    if isc then
      ReduceVector(N, ~sol);
      //solution is very unlikely to be incorrect, but we should check!
      for i in [dn+3..ns] do
        vec := Vector(Integers(), lct[i..i+dd-1]);
        if InnerProduct(vec,sol) ne -lct[i+dd] then
          vprint DFA, 1:
                     "Unexpected inconsistency - but no cause for concern!";
          isc := false;
          break;
        end if;
      end for;
    end if;
    if isc then
      vprint DFA, 1: "Have solution over integers";
    else vprint DFA, 1: "No solution - increasing degree estimates";
      dd := Min(dd+1, ns);
      dn := Min(dn+10, ns-1);
    end if;
  until isc;
   //We are relying on fact that we have a solution with as many leading
   //0's as possible.
  P := PolynomialRing(Integers());
  z := P.1;
  den := 1 + z*P!Reverse(Eltseq(sol));
  num := den * P!lct[1..ns];
  num := P!Eltseq(num)[1..ns];
  return (F!num)/(F!den);
end intrinsic;

intrinsic SizeDFA(dfa::Rec) -> RngIntElt
{return size of language of dfa - could be infinity}
  assert Type(dfa) eq Rec; assert #dfa`initial le 1;
  f := GrowthFunctionDFA(dfa);
  if Degree(Denominator(f)) gt 0 then
    return Infinity();
  end if;
  return &+Eltseq(Numerator(f));
end intrinsic;

intrinsic ComplementDFA(dfa::Rec) -> Rec
{Return DFA whose language is complement of dfa}
 local ans, ns, ng, tab, init, final, acc, queue, ct, st, iters,
        newfinal, newinit, ctab, oldncs, ncs, p, fs;
  assert Type(dfa) eq Rec; assert #dfa`initial le 1;
  tab := dfa`transitions;
  ns := #tab;
  ans := rec<  DFAREC | alphabetsize := dfa`alphabetsize,
                        initial := dfa`initial >;
  if assigned dfa`alphabet then ans`alphabet := dfa`alphabet; end if;
  ng := dfa`alphabetsize;
  if #dfa`initial eq 0 then
    ans`initial:={1}; ans`final:={1};
    ans`transitions:=[ 1 : i in [1..ng] ];
    return ans;
  end if;
  init := Representative(dfa`initial);
  //it is convenient to make failure state a new state in this function.
  ns +:= 1;
  Append(~tab,[0 : i in [1..ng]]);
  for s in [1..ns] do for g in [1..ng] do
    if tab[s][g] eq 0 then tab[s][g]:=ns; end if;
  end for; end for;
  //now just take complement of final states
  ans`transitions := tab;
  ans`final := {1..ns} diff dfa`final;
  return ans;
end intrinsic;

ProdTable := function( dfa1, dfa2 )
//compute dfa of ordered pairs of states from dfa1, dfa2.
//Will be used to construct meet and join of dfa1, dfa2.
//the dfa returned will have no final component.
//Assume they have initial states. 
  local init1, init2, tab1, tab2, ans, states, ct, ng, st, tab, row, im, p;
  init1 := Representative(dfa1`initial);
  init2 := Representative(dfa2`initial);
  tab1 := dfa1`transitions;
  tab2 := dfa2`transitions;
  ans := rec<  DFAREC | alphabetsize := dfa1`alphabetsize, initial := {1} >;
  states := {@ <init1,init2> @};
  ng := dfa1`alphabetsize;
  ct := 0;
  tab := [];
  while ct lt #states do
    ct +:= 1;
    st := states[ct];
    row := [];
    for g in [1..ng] do
      im := < st[1] eq 0 select 0 else tab1[st[1]][g],
              st[2] eq 0 select 0 else tab2[st[2]][g] >;
      if im[1] eq 0 and im[2] eq 0 then
        p := 0;
      else
        p := Position(states, im);
        if p eq 0 then
          Include(~states, im);
          p := #states;
        end if;
      end if;
      Append(~row, p);
    end for;
    Append(~tab, row);
  end while;
  ans`states := SetToSequence(states);
  ans`transitions := tab;
  return ans;
end function;

intrinsic MeetDFA(dfa1::Rec, dfa2::Rec) -> Rec
{Return DFA whose language is intersection of languages of dfa1 and dfa2}
  local ans, prod, states;
  assert Type(dfa1) eq Rec; assert #dfa1`initial le 1;
  assert Type(dfa2) eq Rec; assert #dfa2`initial le 1;
  assert dfa1`alphabetsize eq dfa2`alphabetsize;
  ans := rec<  DFAREC | alphabetsize := dfa1`alphabetsize >;
  if assigned dfa1`alphabet then ans`alphabet := dfa1`alphabet;
  elif assigned dfa2`alphabet then ans`alphabet := dfa2`alphabet;
  end if;
  if #dfa1`initial eq 0 or #dfa2`initial eq 0 then
    ans`initial:={}; ans`final:={}; ans`transitions:=[];
    return ans;
  end if;
  prod := ProdTable(dfa1,dfa2);
  ans`transitions := prod`transitions;
  states := prod`states;
  ans`initial := {1};
  ans`final := {};
  for s in [1..#states] do
    if states[s][1] in dfa1`final and states[s][2] in dfa2`final then
      Include(~ans`final, s);
    end if;
  end for;
  return ans;
end intrinsic;

intrinsic JoinDFA(dfa1::Rec, dfa2::Rec) -> Rec
{Return DFA whose language is union of languages of dfa1 and dfa2}
  local ans, prod, states;
  assert Type(dfa1) eq Rec; assert #dfa1`initial le 1;
  assert Type(dfa2) eq Rec; assert #dfa2`initial le 1;
  assert dfa1`alphabetsize eq dfa2`alphabetsize;
  ans := rec<  DFAREC | alphabetsize := dfa1`alphabetsize >;
  if assigned dfa1`alphabet then ans`alphabet := dfa1`alphabet;
  elif assigned dfa2`alphabet then ans`alphabet := dfa2`alphabet;
  end if;
  if #dfa1`initial eq 0 then return dfa2;
  elif #dfa2`initial eq 0 then return dfa1;
  end if;
  prod := ProdTable(dfa1,dfa2);
  ans`transitions := prod`transitions;
  states := prod`states;
  ans`initial := {1};
  ans`final := {};
  for s in [1..#states] do
    if states[s][1] in dfa1`final or states[s][2] in dfa2`final then
      Include(~ans`final, s);
    end if;
  end for;
  return ans;
end intrinsic;

intrinsic ExistsDFA(dfa::Rec) -> Rec
{dfa should be a 2-variable automaton. Return DFA whose language is the set
of words v for which there exists a word w with (v,w) accepted by dfa.}
  as := dfa`alphabetsize;
  tab := dfa`transitions;
  issq, ngp1 := IsSquare(as+1);
  if not issq then
    error "Input dfa is not a 2-variable dfa";
  end if; 
  ng := ngp1-1;
  ans := rec< DFAREC | alphabetsize := ng, initial := {1} >;
  //each state of ans is a subset of the states of dfa.
  states := {@ SetToIndexedSet(dfa`initial) @};
  table := [];
  cs := 1;
  //build states and transition table of ans
  while cs le #states do
    row := [];
    for g in [1..ng] do 
      //calculate transition of g on state cs
      im := {@ @};
      for s in states[cs] do for g2 in [(g-1)*ngp1+1 .. g*ngp1] do
        if tab[s][g2] ne 0 then
          Include(~im, tab[s][g2]);
        end if;
      end for; end for;
      if im eq {@ @} then
        Append(~row,0);
        continue g;
      end if;
      pos := Position(states,im);
      if pos eq 0 then
        Include(~states,im);
        pos := #states;
      end if;
      Append(~row,pos);
    end for;
    Append(~table, row);
    cs +:= 1;
  end while;
  ans`transitions := table;
  //now work out which states are accepting
  ns := #states;
  fdfa := [ false : i in [1..#tab]];
  for x in dfa`final do fdfa[x] := true; end for;
  fans := [false : i in [1..ns]];
  for i in [1..ns] do
    st := states[i];
    ct := 1;
    while ct le #st do
      s := st[ct]; 
      if fdfa[s] then
        fans[i] := true;
        continue i;
      end if;
      for g2 in [ng*ngp1+1 .. as] do
        if tab[s][g2] ne 0 then
          Include(~st, tab[s][g2]);
        end if;
      end for;
      ct +:= 1;
    end while;
  end for;
  ans`final := { i : i in [1..ns] | fans[i] };
  
  return ans;
end intrinsic;

intrinsic WordAcceptor(G::GrpAtc) -> Rec
{The record describing the word acceptor of the automatic group G}
    table := WordAcceptorTable(G);
    assert #table gt 0;
    return rec<DFAREC|
	  initial	:= {1},
	  final		:= {1..#table},
	  alphabetsize 	:= #table[1],
	  transitions	:=  table >;
end intrinsic;

intrinsic WordDifferenceAutomaton(G::GrpAtc) -> Rec
{The record describing the word difference automaton of the automatic group G}
    table := WordDifferenceTable(G);
    assert #table gt 0;
    return rec<DFAREC|
	  initial	:= {1},
	  final		:= {1},
	  alphabetsize 	:= #table[1],
	  transitions	:=  table >;
end intrinsic;

intrinsic WordAcceptor(G::GrpFPCox) -> Rec
{The record describing the Brink-Howlett shortlex word acceptor of the coxeter group G}
    table := [];
    a := Ngens(G);
    act := ReflectionTable(G);
    a := #act;
    ss := {@ {Integers()|} @};
    position := 1;
    repeat
	x := ss[position];
	table[position] := [0:i in [1..a]];
	for i := 1 to a do
	    if i notin x then
		target := {y : r in (x join {1..i-1}) | y ne 0 where y := act[i][r]};
		Include(~target, i);
		targetpos := Index(ss, target);
		if targetpos eq 0 then
		    Include(~ss, target);
		    table[position][i] := #ss;
		else
		    table[position][i] := targetpos;
		end if;
	    end if;
	end for;
	position +:= 1;
    until position gt #ss;
    assert #table eq #ss;
    return rec<DFAREC|
	  initial	:= {1},
	  final		:= {1..#table},
	  alphabetsize 	:= a,
	  transitions	:=  table >;
end intrinsic;

intrinsic GrowthFunction(G::GrpAtc:Primes := []) -> FldFunRatUElt
{The growth of G as a rational function over Z.}
    return GrowthFunctionDFA(WordAcceptor(G));
end intrinsic;
