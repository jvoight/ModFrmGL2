freeze;
/*
This file contains functions called:
CoprimeWhichGroup(group, p, e)
NonCoprimeWhichGroup(group, p, e)
CoprimeMaximals(group, p, e)
NonCoprimeMaximals(group, p, e)
L5qIdentify(group, q)
*/

import "reds.m": SLPointStab, SLStabOfNSpace, SLStabOfNSpaceMeetDual, SLStabOfNSpaceMissDual;
import "imp_and_gamma.m": ImprimsMeetSL, GammaLMeetSL;
import "select_conj.m": ImageCopies, SelectGroupGeneral;
import "subfield.m": SubfieldSL;
import "psl2q.m": MakeHomomGeneral;
import "gl2.m": PGammaL2;

/****************************************************************/
/****************************************************************/
//says in the case (p^e-1, 5) = 1 whether input group contains
//duality automorphism

function CoprimeWhichGroup(quot,groupquot,phi)
  is_novelty:= not groupquot subset sub < quot | phi >;
  return is_novelty;
end function;

/****************************************************************/
/****************************************************************/

/* is_novelty if it contains duality; i.e. if it's not contained in 
 * the NORMAL subgroup generated by <delta, phi>.
 * the point stabiliser is <phi, iota> (and all it's conjugates)
 * the kernel is <phi>              if p = 1 (5)
 * the kernel is <phi^4, phi^2iota> if p = 2,3 (5)
 * the kernel is <phi^2, phi*iota>  if p = 4 (5)
 * never reach non-coprime code if p = 0 (5).
 * obviously the kernel is normal
 * if we have a group that's in a point stabiliser but not in the
 * kernel then we'll need to select one conjugacy class from 5, so will
 * need an outer element.
 * we will always choose an outer element of order two that is not in
 * the kernel - this will always act in the same way as duality (tho'
 * it could be a suitable power of the field aut).
 */

function NonCoprimeWhichGroup(quot,groupquot,delta,phi,iota,p)
  is_novelty:= not groupquot subset sub < quot | delta, phi >;
  stab:= sub<quot | phi, iota>;
  in_stab:= exists(t){i : i in [0..4] | groupquot subset stab^(delta^i)} ;
  if p mod 5 eq 1 then
    kernel:= sub<quot|phi>;
  elif (p mod 5 eq 2) or (p mod 5 eq 3) then
    kernel:= sub<quot|phi^4, phi^2*iota>;
  elif (p mod 5 eq 4) then
    kernel:= sub<quot|phi^2, phi*iota>;
  end if; 
  in_kernel:= groupquot subset kernel;

  if in_stab and not in_kernel then
    invol := Random(groupquot);
    while (invol in kernel) or (not Order(invol) eq 2) do 
       invol := Random(groupquot);
    end while;
  else 
    invol:= Identity(groupquot);
  end if;
  return is_novelty, in_kernel, in_stab, invol;
end function;


/****************************************************************/

//This makes those maximal subgroups when q neq 1 (mod 5)

function CoprimeMaximals(p, e, factor, is_novelty, Print)
  q:= p^e;

  maximals:= [];
  
  if Print gt 1 then "getting reducibles"; end if;
  if not is_novelty then
    Append(~maximals,  (SLPointStab(5, q)@factor));
    Append(~maximals,  (SLStabOfNSpace(5, q, 2)@factor));
    Append(~maximals,  (SLStabOfNSpace(5, q, 3)@factor));
    Append(~maximals,  (SLStabOfNSpace(5, q, 4)@factor));
  else 
    Append(~maximals, (SLStabOfNSpaceMeetDual(5, q, 1)@factor));
    Append(~maximals, (SLStabOfNSpaceMissDual(5, q, 1)@factor));
    Append(~maximals, (SLStabOfNSpaceMeetDual(5, q, 2)@factor));
    Append(~maximals, (SLStabOfNSpaceMissDual(5, q, 2)@factor));
  end if;


  if Print gt 1 then "getting imprimitives"; end if;
  if q gt 4 then
    Append(~maximals, (ImprimsMeetSL(5, q, 5)@factor));
  end if;

  if Print gt 1 then "getting superfield"; end if;
  Append(~maximals, (GammaLMeetSL(5, q, 5)@factor));

  if Print gt 1 then "getting subfields"; end if;
  fac:= Factorisation(e);
  for x in fac do
    f:= e div x[1];
    Append(~maximals, (sub<SL(5, q)|Eltseq(SL(5, p^f).1), 
              Eltseq(SL(5, p^f).2)>@factor));
  end for;

  if IsOdd(p) then
    if Print gt 1 then "getting orthogonal"; end if;
    so:= sub<SL(5, q)|SO(5, q)>;
    Append(~maximals, so@factor);
  end if;

  if IsEven(e) then
    if Print gt 1 then "getting unitary"; end if;
    Append(~maximals, (SU(5, p^(e div 2))@factor));
  end if;

  return maximals;
end function;




/********************************************************************/
//makes maximals when (p^e-1, 5) = 5.

function NonCoprimeMaximals(p, e, factor, psl, is_novelty,
                      in_kernel, in_stab, invol, Print)

  assert IsPrime(p);
  q:= p^e; 
  assert q mod 5 eq 1;
  diag:= GL(5, q).1@factor;

  maximals:= [];

  if Print gt 1 then "getting reducibles"; end if;
  if not is_novelty then
    Append(~maximals,  (SLPointStab(5, q)@factor));
    Append(~maximals,  (SLStabOfNSpace(5, q, 2)@factor));
    Append(~maximals,  (SLStabOfNSpace(5, q, 3)@factor));
    Append(~maximals,  (SLStabOfNSpace(5, q, 4)@factor));
  else 
    Append(~maximals, (SLStabOfNSpaceMeetDual(5, q, 1)@factor));
    Append(~maximals, (SLStabOfNSpaceMissDual(5, q, 1)@factor));
    Append(~maximals, (SLStabOfNSpaceMeetDual(5, q, 2)@factor));
    Append(~maximals, (SLStabOfNSpaceMissDual(5, q, 2)@factor));
  end if;

  if Print gt 1 then "getting imprimitive"; end if;
  Append(~maximals, (ImprimsMeetSL(5, q, 5)@factor));

  if Print gt 1 then "getting semilinear"; end if;
  Append(~maximals, (GammaLMeetSL(5, q, 5)@factor));

  if Print gt 1 then "getting subfield groups"; end if;
  fac:= Factorisation(e);
  for x in fac do
    f:= e div x[1];
    if (x[1] eq 2 and (p^f mod 5) eq 4) or (x[1] eq 5) then
      if (in_kernel) then
        sl:= SubfieldSL(5, p, e, f)@factor;
        groups:= ImageCopies(sl, 5, diag);
        maximals:= maximals cat groups;
      elif in_stab and (not in_kernel) then
        sl:= SubfieldSL(5, p, e, f)@factor;
        Append(~maximals, SelectGroupGeneral(psl,sl,diag,invol));
      end if;
    else
      Append(~maximals, SubfieldSL(5, p, e, f)@factor);
    end if;  
  end for;
 
  if in_stab and IsOdd(q) then
   "getting orthogonal group";
    so:= sub<SL(5, q)|SO(5, q)>@factor;
    if in_kernel then
      groups:= ImageCopies(so,5,diag);
      maximals:= maximals cat groups;
    else
      Append(~maximals, SelectGroupGeneral(psl,so,diag,invol));
    end if;
  end if;

  if IsEven(e) then
    if not (p^(e div 2) mod 5 eq 1) then
      Append(~maximals, sub<SL(5, q)| SU(5, p^(e div 2))>@factor);
    elif in_stab then
      su:= sub<SL(5, q)|SU(5, p^(e div 2))>@factor;
      if in_kernel then
        groups:= ImageCopies(su,5,diag);
        maximals:= maximals cat groups;
      else
        Append(~maximals, SelectGroupGeneral(psl,su,diag,invol));
      end if;
    end if;  
  end if;

  return maximals;
end function;


/*****************************************************************/

/* The main function. 
 * Input: - a group isomorphic to an almost simple group with 
 *          socle PSL(5, q) for q \neq p,
 *        - the prime power q
 *        - a flag "max" (default true) to say whether we want 
 *          the maximals or just to do constructive recognition.
 *        - a Print level (default 0) if > 1 we print stuff.
 *
 * Output: - 5 things. the third one is the maximal subgroups, 
 *           the others seem to be various homomorphisms.
 */


function L5qIdentify(group, q:  max:= true, Print:=0)
  fac:= Factorisation(q);
  assert #fac eq 1;
  p:= fac[1][1];
  e:= fac[1][2];
  assert e gt 1;

  if Print gt 1 then print "Making standard group"; end if;
  gl := GL(5,p^e);
  sl := SL(5,p^e);
  apsl := PGammaL2(5,p^e);
  factor := hom< gl->apsl | apsl.1, apsl.2 >;
  psl := sl @ factor;


  if Print gt 1 then print "Setting up isomorphism"; end if;
  homom, soc, group:=
       MakeHomomGeneral(group, 5, p, e, psl, apsl, factor : Print:=0);

  // Set up the subgroup of the outer automorphism group induced by group
  if max then
    d:= Gcd(q-1, 5);
    quot, proj := quo<apsl|psl>;
    delta := proj(apsl.1); assert Order(delta) eq d; //diagonal aut.
    phia := proj(apsl.3); assert Order(phia) eq e;     //field aut.
      //had used phi twice!
    iota := proj(apsl.4); assert Order(iota) eq 2;   //graph aut
    newgens := [ apsl | group.i @ homom : i in [1..Ngens(group)] ];
    groupquot := sub< quot | [proj(g) : g in newgens] >; 
  end if;

  if Print gt 1 then print "Calling FPGroupStrong"; end if;
  F, phi := FPGroupStrong(sub< psl | [ soc.i @ homom : i in [1..Ngens(soc)] ]>);

  if Print gt 2 then print "minimising generators"; end if; 
  //get apsl right
  ord_apsl:= Order(apsl);
  newgens := [ apsl | group.i @ homom : i in [1..Ngens(group)] ];
  subapsl := sub< apsl | newgens >;
  RandomSchreier(subapsl);
  for g in Generators(apsl) do if not g in subapsl then
     Append(~newgens,g); subapsl := sub< apsl | newgens >;
     RandomSchreier(subapsl);
  end if; end for;
  apsl := sub<apsl|subapsl>;
  apsl`Order:= ord_apsl;

  if not max then
    return homom, apsl, [], F, phi;
  end if;

  if d eq 1 then
    is_novelty := CoprimeWhichGroup(quot,groupquot,phia);
    if Print gt 1 then print "is novelty =", is_novelty; end if; 
    maximals := CoprimeMaximals(p, e, factor, is_novelty, Print);
  elif d eq 5 then
    is_novelty, in_kernel, in_stab, invol:=
    NonCoprimeWhichGroup(quot,groupquot,delta,phia,iota,p);
    if Print gt 1 then 
      print "is novelty =", is_novelty, "in_kernel =", in_kernel;
      print "in_stab =", in_stab; 
    end if;
    invol:= invol@@proj;
    maximals:=NonCoprimeMaximals(p,e,factor,psl,is_novelty,
         in_kernel,in_stab,invol, Print);
  end if;

  return homom, apsl, maximals, F, phi;

end function;

