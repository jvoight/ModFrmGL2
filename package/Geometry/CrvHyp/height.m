freeze;
// ALWAYS DOCUMENT YOUR CHANGES (what/when/how)
// in the header of this file
// these package files are updated concurrently by
// ourselves (magma) AND M. Stoll
// Thank you!


////////////////////////////////////////////////////////////////////////
//                                                                        
//      Computation of canonical heights using                                
//      arithmetic intersection theory                                      
//                                                                                                      
//      Jan Steffen Mueller (February 2011),
//      using some code due to David Holmes.  
//                                                                        
////////////////////////////////////////////////////////////////////////


/*-------------------------------------------------------------------
  CHANGES
  =======
  
  2011-10-20 JS Mueller
    Added LocalIntersectionData - this has applications e.g. for the 
      computations of p-adic heights using the construction of 
      Coleman-Gross.

  2012-03-13 JS Mueller
    Removed checks exp gt 0 in finite_intersection.

  2012-06-13 JS Mueller
    Changed find_disjoint_multiple, now requires divisors of degree g  
      if the genus and degree of the curve are both even. This was
      causing problems in some cases.

  2012-Jul-27 M Watkins, added try/catch to CanonicalHeight and HeightPairing

  2017-05-19 JS Mueller
    Added UseArakelov option to HeightPairingMatrix and Regulator.
    Fixed several bugs.
    Rewrote int_with_spec_fiber; introduced 
      - divisor_on_regular_model
      - hard_int_with_special_fiber
      - my_point_on_regular_model
      - reduction_points
-------------------------------------------------------------------*/


/*-------------------------------------------------------------------
  To do
  =======

  Add function fields!
 
-------------------------------------------------------------------*/



////////////////////////////////////////////////////////////////////////
//
//      Wrapper functions to deal with number fields
//      and function fields simultaneously.
//      
////////////////////////////////////////////////////////////////////////


my_degree := func<K | ISA(Type(K), FldFunRat) select 1 else Degree(K)>;


function local_factor(Kp)

  if ISA(Type(Kp), RngSerLaur) then // p is a place of a function field
    return 1;
  else 
 //   return Log(RF ! Prime(Kp)) * AbsoluteInertiaDegree(Kp);
 return 1;
    return AbsoluteInertiaDegree(Kp);
  end if;
end function;


function my_integers(K)

  if ISA(Type(K), FldFun) then
    return MaximalOrderFinite(K);
  else 
    return Integers(K);
  end if;  
end function;


function my_factorisation(n, R)

  vprintf JacHypHeight, 3: "  Computing prime factorisation of %o\n", n;
  if ISA(Type(n), RngIntElt) or ISA(Type(n), RngUPolElt)  or ISA(Type(n), RngOrdIdl) 
          or ISA(Type(n), RngOrdFracIdl) then
    return Factorisation(n);
  elif ISA(Type(n), FldRatElt) or ISA(Type(n), FldFunRatUElt) then 
    return Factorisation(R ! n);
  else
    return Factorisation(ideal<R | n>);
  end if;	
end function;


function my_bad_primes(C)
  
  K := BaseRing(C);
  if ISA(Type(K), FldFunG) then
    disc := Discriminant(C);
    // For our applications we only care about finite primes
    fact := my_factorisation(disc, my_integers(K));
    return [t[1] : t in fact];
  else 
    return BadPrimes(C);
  end if;
end function;


function my_denominator(a)

  K := Parent(a);
  if ISA(Type(K), FldFun) then
    return Denominator(a, my_integers(K));
  else 
    return Denominator(a);
  end if;  
end function;


// n is an integers,  R a ring of integers of a number field
// returns the list of prime ideals of R dividing n

function my_prime_divisors(n, R)

  if ISA(Type(R), RngInt) then
    return PrimeDivisors(n);
  else
    return [T[1] : T in my_factorisation(n, R)];
  end if;	
end function;


// Returns the completion Rp of a Dedekind domain R at p as a fixed precision ring 
// with precision prec; also returns the coercion from R to Rp.

function my_completion(R, p, prec)

 if Type(R) eq RngInt then
   Rp, phi := pAdicRing(p, prec);
   return Rp, phi;
 end if; 
 Rp, phi := Completion(R, p : Precision := prec); 
 if ISA(Type(Rp), RngPad) or ISA(Type(Rp), FldPad) then
   Rpf := ChangePrecision(Rp, prec);
   psi := Coercion(Rp, Rpf);
 elif ISA(Type(Rp), RngSerLaur) then
   Rpf := LaurentSeriesRing(BaseRing(Rp), prec);
   psi := Coercion(Rp, Rpf);
 end if; 
 return Rpf, phi * psi; 
end function;


function my_is_square(a)
  if IsWeaklyZero(a) then return true, a-a; end if;

  if ISA(Type(a), RngSerExtElt) then
    f := Polynomial([-a, 0, 1]);
    fact := Factorisation(f);
    ind := Index([Degree(pair[1]): pair in fact], 1);
    if IsZero(ind) then
      return false, false;
    else
      return true, -ConstantCoefficient(fact[ind, 1]);
    end if;
  else 
    b, s := IsSquare(a);
  end if;  
  if b then
    return b, s;
  else
    return b, false;
  end if;  
end function;


function my_is_ramified(K)

  if ISA(Type(K), RngSerExt) then
    return RamificationDegree(K) eq 1;
  end if;
  return IsRamified(K);
end function;

////////////////////////////////////////////////////////////////////////
//
//      Vanishing and precision functions for local fields 
//      
////////////////////////////////////////////////////////////////////////


function my_prec(R)

  return Precision(R ! 1);
end function;


function make_is_zero(R)

  if ISA(Type(R),  FldPad) or ISA(Type(R), RngSerLaur) or ISA(Type(R), RngSerExt) then
    return func< z | IsWeaklyZero(z)>;
  else
    return func< z | z eq R!0 >;
  end if;
end function;


function make_is_zero_pol(R)

  iszero := make_is_zero(R);
  return func< f | &and[iszero(c):c in Coefficients(f)]>;
end function;


////////////////////////////////////////////////////////////////////////
//
//      Functions for coercion and modification of polynomials
//      
////////////////////////////////////////////////////////////////////////

function my_coeffs(f)

  if IsZero(f) then
    return [Zero(BaseRing(f))];
  end if;
  return Coefficients(f);
end function;

function my_polynomial(L, x)

  iszero := make_is_zero(Universe(L));
  if &and [iszero(l) : l in L] then return Polynomial([Zero(L)]); end if;
    a1 := Zero(Parent(x)) + &+ [x ^ (i - 1) * L[i] : i in [1..#L] | not iszero(L[i])];
    return a1;
end function;


// f is a polynomial over a field k, PK is the polynomial ring in 1 variable over another field K
// phi is a map from k to K. This function coerces f into PK using phi.

function coerce_polynomial(f, phi)

  if CanChangeUniverse(Coefficients(f), Domain(phi)) then
    return Polynomial([phi( c) : c in Coefficients(f)]);
  end if;
  if CanChangeUniverse(Coefficients(f), Codomain(phi)) then
    return ChangeRing(f, Codomain(phi));
  end if;
  error " bad call to coerce_polynomial";
end function;


function coerce_polynomials(L, phi)
 return [coerce_polynomial(f, phi) : f in L];
end function;


// Due to David Holmes,
// produces an equation with integral primitive coefficients over Q_v.

rat_to_int := function (g, v) 

  if ISA(Type(v), RngIntElt) or ISA(Type(v), RngUPolElt) then 
          piv := v;
  else	
          piv := UniformizingElement(v);
  end if;	
  if g eq 0 then 
    return 0;
  else 
    return g * piv ^ (-Min([Valuation(a, v) : a in Coefficients(g)]));
  end if;
end function;



// h is a p-adic poynomial. If integral, this doesn't do anything.
// Otherwise it returns the poly with cleared denominator and the denominator.

function clear_p_denominator(h)

  K := CoefficientRing(Parent(h)); 
  if h eq 0 then 
    return h, One(K);
  else
    min_val := Min([Valuation(a) : a in Coefficients(h)] cat [0]);
    pi := UniformizingElement(K);
    return h * pi ^ (-min_val), pi ^ (-min_val);
  end if;
end function;

function clear_denominators(h)
  if ISA(Type(CoefficientRing(Parent(h))), FldPad) then 
    return clear_p_denominator(h);
  else 
    return ClearDenominators(h);
  end if;
end function;


// h is a p-adic poynomial. 
// this returns a primitive constant multiple of h and the content.
  
function make_p_primitive(h)

  if h eq 0 then 
    return 0;
  else
    min_val := Min([Valuation(a) : a in Coefficients(h)]);
    pi := UniformizingElement(BaseRing(h));
    return h * pi ^ (-min_val), pi ^ (-min_val);
  end if;
 end function;


// h is a univariant poly over a p-adic ring or field, 
// P2 is a multivariate poly ring over the ring or the ring of ints of the field.

function uni_to_int_multi(h, P2)

  h0, d0 := clear_p_denominator(h);
  R := BaseRing(P2);
  if Valuation(d0) lt 0 then
    d0 := One(R);
  else
    d0 := R ! d0;
  end if;	
  t := P2.1;
  return &+ [t ^ i * R ! (Coefficient(h0, i)) : i in [0..Degree(h0)]], d0;
end function;


// f is an integral polynomial in one var wrt the power basis of K, where K is either an
// absolute number field or a function field over a finite field k.
// P3 is a poly ring in 3 vars over Z or k[x], where the last variable satisfies the minimal
// polynomial of K.

function make_multi_over_ext(f, P3)

  K := BaseRing(f);
  R := Integers(BaseRing(K));
  coeffs := [Coefficients(f)];
  t := P3.1;
  T := P3.3;
  function subs_alpha(a)
    seq := Eltseq(a);
    return &+ [T ^ (i - 1) * R ! (seq[i]) : i in [1..#seq]];
  end function;
  coeffs := [subs_alpha(c): c in Coefficients(f)];
  f1 := &+ [t ^ (i - 1) * (coeffs[i]) : i in [1..#coeffs]];
  return f1;
end function;




////////////////////////////////////////////////////////////////////////
//
//      Miscellaneous helper functions
//      
////////////////////////////////////////////////////////////////////////


contains_branch_points := func<D | Resultant(D[1], D[2]) eq 0>;


// Determine whether the given representative D of a point P on Jacobian
// contains a point at infinity P0 in its positive part.
// If yes, also return P0 and its multiplicity in D

function contains_point_at_infinity(P)

  da := Degree(P[1]);
  d := ISA(Type(BaseRing(P[1])), FldCom) or ISA(Type(BaseRing(P[1])), FldRe) 
              select Round(Re(P[3])) else P[3]; 
  d := Integers() ! d;
  if da lt d then
    P0 := [1, LeadingCoefficient(P[2]), 0];
    return true, P0, d - da;
  end if;
  return false, false, false;
end function;


// Given two divisors D1 and D2, check whether
// their supports are disjoint on the affine piece Z ne 0.
// Written by David Holmes

function have_common_affine_support(D1, D2)

  dum := true;
  // for us the zero-divisor has common affine support with all divisors
  if &and[IsZero(a):a in [D1[1]-1,D1[2],D1[3]]] or &and[IsZero(a) : a in 
                                  [D2[1]-1,D2[2],D2[3]]] then return true; end if;
  K := BaseRing(D1[1]);
  if ISA(Type(K), FldFunG) or ClassNumber(K) eq 1 then
    gcd := Gcd(D1[1], D2[1]);
    if gcd eq 1 then
      dum := false;
    else 
      gcd2 := Gcd(gcd, D1[2] - D2[2]);
      if gcd2 eq 1 then
        dum := false;
      end if;
    end if;
  else
    gcdish := Resultant(D1[1], D2[1]);
    if gcdish ne 0 then
      dum := false;
    else
      gcdish2 := Resultant(gcdish, D1[2] - D2[2]);
      if gcdish2 ne 0 then 
        dum := false;
      end if;
    end if;
  end if;
  return dum;
end function;


// L is a list of points on the same Jacobian. 
// n is an integer such that all L[i] greater than n have been checked for branch points.
// Check whether all elements of L have disjoint affine support.
// Also check whether the L[i] contain branch points in their support for i < n + 1.
// If inf is true, also check for common points at infinity in the positive part

function are_disjoint(L, n, inf)

  for i := 1 to #L do
    if i le n and IsZero(Resultant(L[i, 1], L[i, 2])) then
      return false;
    end if;  
    for j := i + 1 to #L do
      if have_common_affine_support(L[i], L[j]) then
        return false;
      elif inf then
        bP, P0 := contains_point_at_infinity(L[i]);
        bQ, Q0 := contains_point_at_infinity(L[j]);
        if bP and bQ and P0 eq Q0 then
          return false;
        end if;
      end if; 
    end for;  
  end for;  
  return true;
end function;


// Given a divisor in Mumford coordinates, return it as an element of the divisor 
// group on the curve.
// Written by David Holmes. 

function mumford_to_effective_div(D, C)

  Coord<X,Y> := CoordinateRing(AmbientSpace(AffinePatch(C, 1)));
  map := hom<Parent(HyperellipticPolynomials(C)) -> Coord | X>;
  bP, P0, nP := contains_point_at_infinity(D);
  if bP then  // need to add nP times the place corresponding to P0
    return Divisor(AffinePatch(C, 1), ideal<Coord | map(D[1]), Y - map(D[2])>)
                                                              + nP * Place(C ! P0);
  else   
    return Divisor(AffinePatch(C, 1), ideal<Coord | map(D[1]), Y - map(D[2])>);
  end if;
end function;


function my_points_at_infinity(C, phi)

  // Compute the L-rational points at infinity on a hyperelliptic curve 
  // C over a field K, where L/K and phi is coercion K -> L
  b, C := IsHyperellipticCurve(C);
  f := HyperellipticPolynomials(C);
  g := Genus(C);
  lcf := Coefficient(f, 2 * g + 2);
  if IsZero(phi(lcf)) then
    return {@ C(phi) ! [1, 0, 0] @};
  else
    b, sqrt := IsSquare(phi(lcf));
    return b select {@ C(phi) ! [1, sqrt, 0], C(phi) ![1, -sqrt, 0] @} else {@ @};
  end if;
end function;
 

////////////////////////////////////////////////////////////////////////
//
//      Archimedean functions
//      
////////////////////////////////////////////////////////////////////////


function my_is_real(sigma)
  
  if ISA(Type(sigma), PlcNumElt) then
    return IsReal(sigma);
  else
    return true;
  end if;
end function;

function my_conjugate(a)
  
  return IsReal(a) select a else Conjugate(a);
end function;


// fun is a function, D1 and D2 are divisors on a curve C,
// sigma is an archimedean place of the base field of C.
// Evaluate fun at D1 - D2, all embedded using sigma.
// First version written by David Holmes.

function complex_evaluate(fun, D1, D2, C, sigma, prec)

  if ISA(Type(sigma), Infty) then
    K := Rationals();
  else 
    K := NumberField(sigma);
  end if;  

  supp1, mult1 := Support(D1);
  supp2, mult2 := Support(D2);
  dum := 1;
  // Evaluate fun at prime divisors in the support of D1.
  for i in {1..#supp1} do
    eval1 := Evaluate(fun, supp1[i]);
    if Parent(eval1) eq K then 
      // Embed using sigma and raise to the correct power
      dum *:= (Evaluate(eval1, sigma : Precision := prec)) ^ (Degree(supp1[i]) * mult1[i]);
    else 
      taus := ISA(Type(sigma), Infty) select [<tau , 1> : tau in InfinitePlaces(Parent(eval1))]
                                      else Decomposition(Parent(eval1), sigma);
      // Embed using places extending sigma and raise to the correct power
      dum *:= (&* ([Evaluate(eval1, tau[1] : Precision := prec) ^ 1 : tau in taus] cat
                   [my_conjugate(Evaluate(eval1, tau[1] : Precision := prec) ) :
                     tau in taus | my_is_real(sigma) and IsComplex(tau[1])])) ^ mult1[i];
    end if;
  end for;

  // Evaluate fun at prime divisors in the support of D2.
  for i in {1..#supp2} do
    eval2 := Evaluate(fun, supp2[i]);
    error if eval2 eq 0 or ISA(Type(eval2), Cat) , "supports of divisors not disjoint";
    if Parent(eval2) eq K then 
      // Embed using sigma and raise to the correct power
      dum /:=(Evaluate(eval2, sigma : Precision := prec)) ^ (Degree(supp2[i]) * mult2[i]);
    else 
      taus := ISA(Type(sigma), Infty) select  [<tau , 1> : tau in InfinitePlaces(Parent(eval2))]
                                      else Decomposition(Parent(eval2), sigma);
      // Embed using places extending sigma and raise to the correct power
      dum /:= (&* ([Evaluate(eval2, tau[1] : Precision := prec) ^ 1 : tau in taus] cat
                   [my_conjugate(Evaluate(eval2, tau[1] : Precision := prec) ) :
                     tau in taus | my_is_real(sigma) and IsComplex(tau[1])])) ^ mult2[i];
    end if;
  end for;
  return dum;
end function;


// Compute the imaginary part of a complex matrix.

function im_matrix(M)

 row_vector_list := [];
 for i := 1 to Nrows(M) do
   Append(~row_vector_list, [Imaginary(a) : a in Eltseq(M[i])]);
 end for; 
 return Matrix(row_vector_list);
end function;


// P is  a point on a curve, A is the analytic Jacobian of the curve.
// Map P to A.

function curve_to_ana_jac(P, A)

  // Need B2inv because we work with a different big period matrix.
  B2inv := A`B2Inverse;
  P := ChangeUniverse([P[1], P[2], P[3]], BaseRing(A));
  AP := B2inv * ToAnalyticJacobian(P[1], P[2], P[3], A);
  return AP; 
end function;


// P is a point on the algebraic Jacobian, given in Mumford representation.
// We find the points in its support and map them to a sequence of points 
// on the analytic Jacobian A. If inf is true, consider points at infinity.

function jacobian_to_divisor_on_ana_jac(P, A, inf)

  roots := Roots(ChangeRing(P[1], BaseRing(A)));
  // Take care of multiple roots. We don't want to use the Abel-Jacobi map more often than we have to.
  divP := [[d1[1], Evaluate(ElementToSequence(P)[2], d1[1]), 1, d1[2]] : d1 in roots];
  AP_list := [<curve_to_ana_jac(d, A), d[4]>  : d in divP];
  bP, P0, nP := contains_point_at_infinity(P);
  if inf and bP then 
    Append(~AP_list, <curve_to_ana_jac([P0[1], P0[2], P0[3]], A), nP>);
  end if;
  return AP_list;
end function;


// P is a point on the algebraic Jacobian, given in Mumford representation.
// This maps it to the analytic Jacobian A.
// if inf is true, consider points at infinity.

function jacobian_to_ana_jac(P, A, inf)
  divis := jacobian_to_divisor_on_ana_jac(P, A, inf);
  AP := &+ [d[2] * d[1] : d in divis];
  return AP;
end function;


// L is a list of points on the algebraic Jacobian of a hyperelliptic curve,
// A is the correspoding analytic Jacobian and mu is an integer.
// Let D_P1, D_P2, D_Q1 be the positive parts of the canonical representative of 
// L[1], L[2], L[3], respectively. If L[4] is nonzero, then let D_Q2 be the positive 
// part of the canonical representative of L[4], otherwise let D_Q2 be either a 
// multiple of the line at  infinty or of the zero divisor of x - mu, in case mu 
// is non-zero, such that D_Q1 - D_Q2 has degree zero.
//
// Compute the sum of intersections (D_P1 - D_P2, D_Q1 - D_Q2)_sigma.
//
// Here we require that D_P1 and D_P2 are non-special.
// Such archimedean intersections are defined using Green's functions on the Riemann
// surface of the curve. For non-special divisors these can be expressed using certain
// theta functions on the Jacobian (see Lang, Fundamentals of diophantine geometry,
// chapter 13), at least up to an additive constant.
// Since D_P1 - D_P2 and D_Q1 - D_Q2 have degree 0, the constant disappears.

function ArchimedeanIntersection(L, A, mu) 

  P1, P2, Q1, Q2 := Explode(L);
  g := Genus(A);
  pi := Pi(BaseRing(A));
  tau_v := SmallPeriodMatrix(A);
  BPM := BigPeriodMatrix(A);
  B := Transpose(BPM);
  B2 := Transpose(Matrix([Eltseq(B[i]) : i in [g + 1..2 * g]]));
  A`B2Inverse := B2 ^ (-1);
  im_tau_v_inv := (im_matrix(tau_v)) ^ (-1);
  product := 1;
  P1P2_are_inverses := &and [IsZero(d) : d in [P1[1] - P2[1], P1[2] + P2[2], P1[3] - P2[3]]];
  
  // Map P1 and P2 to A, but forget about points at infinity, since otherwise D_P1 might 
  // have degree g + 1.
  AP1 := jacobian_to_ana_jac(P1, A, false);
  if P1P2_are_inverses then // Can save application of Abel-Jacobi map.
    AP2 := -AP1;
  else
    AP2 := jacobian_to_ana_jac(P2, A, false);
  end if; 
  Q2_is_zero := IsZero(Q2[1] - 1) and IsZero(Q2[2]) and IsZero(Q2[3]); 

  // Now find the divisors D_Q1 and D_Q2 on the Riemann surface
  // and the images of the points in their supports under the Abel-Jacobi map.
  DivAE1 := jacobian_to_divisor_on_ana_jac(Q1, A, true);
  if Q2_is_zero then
    if P1P2_are_inverses then 
      DivAE2 := [<Zero(Parent(DivAE1[1, 1])), 1> : i in [1..Round(Re(Q1[3]))]];
    elif IsZero(mu) then
      fl := A`EvenLeadingCoefficient;
      divP := [[1, fl, 0], [1, -fl, 0]];
      DivAE2 := [<curve_to_ana_jac([P[1], P[2], P[3]], A), BaseRing(A) ! (Q1[3] / 2)> : P in divP];
    else
      _, y_mu := my_is_square(Evaluate(HyperellipticPolynomial(A), BaseRing(A) ! mu));
      divP := [[BaseRing(A) ! mu, y_mu, 1],  [BaseRing(A) ! mu, -y_mu, 1]];
      DivAE2 := [<curve_to_ana_jac([P[1], P[2], P[3]], A), BaseRing(A) ! (Q1[3] / 2)> : P in divP];
    end if;
  else
    DivAE2 := jacobian_to_divisor_on_ana_jac(Q2, A, true);
  end if;   

  // Compute theta functions with characteristic char and apply them to
  // i(P) - P1, and i(P) - P2, where P runs through the support of D_Q1 and D_Q2
  // and i is the Abel-Jacobi map.
  char_list := [0.5 : i in [1..g]] cat [(g - i) * 0.5 : i in [0..g - 1]];
  char := Transpose(Matrix(BaseRing(A), [char_list]));
  product *:= &* [Theta(char, P[1] - AP1, tau_v) ^ P[2] : P in DivAE1]; 
  product /:= &* [Theta(char, P[1] - AP2, tau_v) ^ P[2] : P in DivAE1];
  if not P1P2_are_inverses and Q2_is_zero then // Otherwise the following two are the same.
    product *:= &* [Theta(char, Q[1] - AP2, tau_v) ^ Q[2] : Q in DivAE2];
    product /:= &* [Theta(char, Q[1] - AP1, tau_v) ^ Q[2] : Q in DivAE2];
  end if;
  sum := -Log(Abs(product));
  im_diff := im_matrix(AP1 - AP2);

  // Compute remaining terms.
  sum -:= 2 * pi * (&+ [P[2] * Transpose(im_diff) * im_tau_v_inv * im_matrix(P[1])
                           : P in DivAE1])[1, 1];
  sum +:= 2 * pi * (&+ [Q[2] * Transpose(im_diff) * im_tau_v_inv * im_matrix(Q[1]) 
                           : Q in DivAE2])[1, 1];
  return sum;
end function;


// L is a list of points on the algebraic Jacobian of a hyperelliptic curve C,
// beta is a function on C, mu is an integer.
// Let D_P1, D_P2, D_Q1 be the positive parts of the canonical representative of 
// L[1], L[2], L[3], respectively. If L[4] is nonzero, then let D_Q2 be the positive 
// part of the canonical representative of L[4], otherwise let D_Q2 be either a 
// multiple of the line at  infinty or of the zero divisor of x - mu, in case mu 
// is non-zero, such that D_Q1 - D_Q2 has degree zero.
//
// Compute the sum of intersections (D_P1 - D_P2, D_Q1 - D_Q2)_sigma 
// plus log | beta(D_Q1 - D_Q2) |_sigma, where sigma runs through the places 
// of the base field of C. 

function ArchimedeanNeronSymbol(L, C, beta, mu, prec)

  K := BaseRing(C);
  symbol := 0;
  _<X,Y> := FunctionField(C);

  // Compute the divisors D_Q1 and D_Q2
  DQ1 := mumford_to_effective_div(L[3], C);   
  if mu eq 0 then
    if IsZero(L[4, 3]) then
      DQ2 := IsOddDegree(C) select Place(PointsAtInfinity(C)[1]) else Numerator(Divisor(1 / X));
    else
      DQ2 := mumford_to_effective_div(L[4], C); 
    end if;  
  else  
    DQ2 := Numerator(Divisor(X - mu));
  end if;  
  if Denominator(Degree(DQ1) / Degree(DQ2)) ne 1 then
    "Problem with the archimedean computations!";
    "Try choosing a different mu (or none at all, if possible).";
  end if;

  DQ2 := Integers() ! (Degree(DQ1) / Degree(DQ2)) * DQ2;

  embeddings := InfinitePlaces(BaseRing(C));
  CF := ComplexField(prec);

  for sigma in embeddings do
    // Compute the analytic Jacobian of C embedded using sigma.
    if ISA(Type(K), FldRat) then
      Asigma := AnalyticJacobian(C : Precision := prec);
    else
      Asigma := AnalyticJacobian(C, sigma : Precision := prec);
    end if;
    // Embed the points in L using sigma
    Lsigma := [[Polynomial([CF ! Evaluate(c,  sigma : Precision := prec + 5) : 
                  c in my_coeffs(P[i])]) : i in [1..2]] cat [CF ! P[3]] : P in L];

    // Compute the intersection (D_P1 - D_P2, D_Q1 - D_Q2)_sigma.
    intsigma := ArchimedeanIntersection(Lsigma, Asigma, mu);
    vprintf JacHypHeight, 3: "Archimedean intersection at %o is equal to %o\n",sigma, intsigma;


    // Add  log |beta(D_Q1 - D_Q2)|_sigma.
    logsigma := Log(Abs(CF ! complex_evaluate(beta, DQ1, DQ2, C, sigma, prec + 5)));
    vprintf JacHypHeight, 3: "log |beta(D_Q1 - D_Q2)|_sigma = %o\n", logsigma;
    symbolsigma := intsigma + logsigma;
    vprintf JacHypHeight, 2: "Intersection at %o is equal to %o\n", sigma, symbolsigma / 2;

    // Scale result depending on sigma being real or not.
    if ISA(Type(K), FldRat) or IsReal(sigma) then
      factor := 1;
    else
      factor := 2;
    end if;  
    symbol +:= factor * symbolsigma;
  end for;  
  return CF ! symbol / 2;
end function;

    

////////////////////////////////////////////////////////////////////////
//
//      Non-archimedean functions
//      
////////////////////////////////////////////////////////////////////////


// f is a univariate polynomial over a local field with integral coordinates.
  
function has_squarefree_reduction(f)

  Zp := my_integers(BaseRing(f));
  Fp, phip := ResidueClassField(Zp);
  return not IsSquare(coerce_polynomial(f, phip));
end function;


// a is a univariate polynomial over a local field with integral coordinates.
// Test whether one of its roots reduces to infinity mod p.
  
function is_on_wrong_affine_piece(a)

  return IsZero(Valuation(ConstantCoefficient(a))) and Valuation(LeadingCoefficient(a)) gt 0;
end function;


// a1 and a2 are univariate polynomials over a local field with integral coordinates.
// Test whether they have a common root mod p.

function possible_intersection(a1, a2)

  Rp := my_integers(BaseRing(a1));
  Fp, phi := ResidueClassField(Rp);
  a11 := coerce_polynomial(a1, phi);
  a21 := coerce_polynomial(a2, phi);
  return IsZero(Resultant(a11, a21)) or ((Degree(a11) lt Degree(a1)) and (Degree(a21) lt Degree(a2)));
end function;


// Extend the non-archimedean local field K by a root of the univariate polynomial
// f over K.

function an_extension(f, K)

  fac, _, cert := Factorisation(f : Extensions := true);
  _, ind := Min([t[2]:t in fac]); // changed. Previously the min was taken as the index.
  RR := cert[ind]`Extension;
  KK := FieldOfFractions(RR);
  phi := Coercion(K, KK);
  return KK, phi;
end function;


// a1 and a2 are univariate polynomials over a local field with integral coordinates.
// Test whether a1 and a2 have a common root mod p that is the x-coordinate of a singular
// point on the reduction of the curve given by y^2=f(x).
// Due to David Holmes.

must_have_regular_common_support := function(a1, a2, f);

  K := BaseRing(a1);
  R := my_integers(K);
  kv, phiv := ResidueClassField(R);
  Pv := PolynomialRing(kv);
  fv := coerce_polynomial(f, phiv);
  if IsSquare(fv) then
    return false;
  end if;  
  a1v := coerce_polynomial(make_p_primitive(a1), phiv); 
  a2v := coerce_polynomial(make_p_primitive(a2), phiv); 
  if Characteristic(kv) eq 2 then
    return Gcd([Derivative(fv), a1v, a2v]) eq 1;
  else
    return Gcd([Gcd(Derivative(fv), fv), a1v, a2v]) eq 1;
  end if;
end function;


// a is a univariate polynomial over a global field K, v is a non-archimedean place of K.
// Test whether a root of a mod v is the x-coordinate of a singular
// point on the reduction of the curve given by y^2=f(x) mod v.
// Due to David Holmes.

has_good_reduction_over := function(a, f, v);

  K := BaseRing(a);
  R := my_integers(K);
  Fv, phiv := ResidueClassField(v);
  Pv := PolynomialRing(Fv);
  fv := coerce_polynomial(rat_to_int(f, v), phiv);
  a *:= LCM([Denominator(c) : c in Coefficients(a)]);
  av := coerce_polynomial(rat_to_int(a, v), phiv);
  if Valuation(R ! 2, v) gt 0 then
    return Gcd(Derivative(fv), av) eq 1;
  else
    return Gcd(Gcd(fv, Derivative(fv)), av) eq 1;
  end if;
end function;

// Perform a change of coordinates to move "infinity" to the origin, so we can apply
// the usual intersection processes. 
// Should generally be applied to factors that are irreducible over Q_v.
// Due to David Holmes.

xy_to_st :=  function (a, b, genus)

  coeffsa1 := Reverse(Coefficients(a));
  coeffsb1 := ([0 : a in {1..genus + 1 - Degree(b)}] cat Reverse(Coefficients(b)));
  x := Parent(a).1;
  return [my_polynomial(coeffsa1, x), my_polynomial(coeffsb1, x)];
end function;


// L1 and L2 are lists of polynomials, containing one or two elements.
// We want to find the possible places of intersection of V(L1) and V(L2).
// We assume that the ground field is an absolute extension of the rationals
// or of a global rational function field

function global_groebner_basis(L1, L2, f)
  K := BaseRing(L1[1]);
  R := my_integers(K);
  d1 := LCM([my_denominator(c): c in Coefficients(L1[1])]);
  d2 := LCM([my_denominator(c): c in Coefficients(L2[1])]);
  if ISA(Type(R), RngInt) or ISA(Type(K), FldFunRat) then
    PR<t, u> := PolynomialRing(R, 2, "grevlex");
    ff := &+ [t ^ i * R ! Coefficient(f, i):i in [0..Degree(f)]];
    a1 := &+ [t ^ i * R ! (d1 * Coefficient(L1[1], i)): i in [0..Degree(L1[1])]];
    a2 := &+ [t ^ i * R ! (d2 * Coefficient(L2[1], i)): i in [0..Degree(L2[1])]];

    if #L1 eq 2 then
      e1 := IsZero(L1[2]) select 1 else LCM([my_denominator(c): c in Coefficients(L1[2])]);
      b1 := IsZero(L1[2]) select PR ! 0 else &+ [t ^ i * R ! (e1 * Coefficient(L1[2], i)) :
                                                                     i in [0..Degree(L1[2])]];
    end if;
    if #L2 eq 2 then	
      e2 := IsZero(L2[2]) select 1 else LCM([my_denominator(c): c in Coefficients(L2[2])]);
      b2 := IsZero(L2[2]) select PR ! 0 else &+ [t ^ i * R ! (e2 * Coefficient(L2[2], i)) :
                                                                     i in [0..Degree(L2[2])]];
      if #L1 eq 2 then
         I := ideal<PR | u^2 - ff, a1, a2, e1 * u - b1, e2 * u - b2>;
      else	
         I := ideal<PR |  u^2 - ff, a1, a2,  e2 * u - b2>;
      end if;
    elif #L1 eq 2 then
      I := ideal<PR | u^2 - ff, a1, a2, e1 * u - b1 >;
    else 
    	I := ideal<PR | u ^ 2 - ff, a1, a2 >;
    end if;	
  else 
    min_poly := DefiningPolynomial(K);
    PQ := PolynomialRing(BaseRing(min_poly), 1);
    _, min_poly := IsUnivariate(ClearDenominators(MultivariatePolynomial(PQ, min_poly, 1)));
    min_poly_coeffs := Coefficients(min_poly);
    PR<t, u, T> := PolynomialRing(Integers(BaseRing(K)), 3);
    rel1 := &+ [T ^ (i - 1) * Integers(BaseRing(K)) ! min_poly_coeffs[i] : 
                                                      i in [1..#min_poly_coeffs]];
    a1 := make_multi_over_ext(d1 * L1[1], PR);
    a2 := make_multi_over_ext(d2 * L2[1], PR);
    ff := make_multi_over_ext(f, PR);
    if #L1 eq 2 then
      e1 := IsZero(L1[2]) select 1 else LCM([my_denominator(c): c in Coefficients(L1[2])]);
      b1 := IsZero(L1[2]) select PR ! 0 else make_multi_over_ext(e1 * L1[2], PR);
    end if;
    if #L2 eq 2 then	
      e2 := IsZero(L2[2]) select 1 else LCM([my_denominator(c): c in Coefficients(L2[2])]);
      b2 := IsZero(L1[2]) select PR ! 0 else make_multi_over_ext(e2 * L2[2], PR);
      if #L1 eq 2 then
        I := ideal<PR | rel1, u^2 - ff, a1, a2, e1 * u - b1, e2 * u - b2>;
      else	
        I := ideal<PR | rel1, u^2 - ff, a1, a2,  e2 * u - b2>;
      end if;
    elif #L1 eq 2 then
      I := ideal<PR | rel1, u^2 - ff, a1, a2, e1 * u - b1 >;
    else 
      I := ideal<PR | rel1, u^2 - ff, a1, a2 >;
    end if;	
  end if;	
  B := GroebnerBasis(I);
  return B, [d1, d2];
end function;


// Compute the size of the algebra R/IR, where I is the zero-dimensional ideal generated by B. 
// Here the coefficient ring R is supposed to be a p-adic quotient ring (because 
// Magma can't compute Groebner bases of p-adic rings) or a finite precision series
// ring over a finite field. 
// In the situations we are interested in, this will be the same as the length 
// of the corresponding O_Cv-module, where Cv is an irreducible component of the
// special fiber of a smooth projective curve over R.

function local_module_length(B)

  my_exponents := func<f, n | IsOne(#Terms(f)) select Exponents(f) else [0:i in [1..n]]>; 
  // Returns the list of exponents if f is a monomial of positive degree
  cond_satisfied := func<I, cond | &or [I[j] lt cond[j]: j in [1..#I]] >; 
  // Checks if the monomial with exponents I is a multiple of the one w exponents cond

  if not IsGroebner(B) then
    B := GroebnerBasis(B);
  end if;
  q0 := B[#B];
  error if TotalDegree(q0) ne 0, "Module is not finite. Try rerunning this computation with
                                                                     higher local precision.";
  //   q0 is an element of R. 
  R := Parent(B[1]);
  v0 := Valuation(BaseRing(R) ! q0); 
  if IsOne(#B) then  
  //      q0 is the unique element of B
    return v0;
  end if;

  if IsZero(v0) then  //    I contains 1
    return 0;
  end if;
  sum := v0;
  pi := UniformizingElement(BaseRing(R));
  n := Rank(R);
  Conditions := [];
  //  start with monomials of total degree 1. They will be initialized below
  TD := 1;
  current_exponents := [[0:i in [1..n]]];
  while true do
    tuples_left := false;
    old_exponents := current_exponents;
    current_exponents := [];
    for i := 1 to #old_exponents do
      I := old_exponents[i];
      //  We add new monomials by increasing the degrees of our current monomials in each 
      //  indeterminate by 1
      for j := 1 to n do
        I[j] +:= 1;
        //    We only add the monomial to our list if it hasn't already been taken care of
        if I notin current_exponents and &and[cond_satisfied(I, cond):cond in Conditions] then  
          Include(~current_exponents, I);
          a := 0;
          r := NormalForm(Monomial(R, I), B);//mod out by B
                  
          //  The following while-loop does the actual work by computing the smallest power a of pi
          //  such that pi ^ a can be expressed using other monomials of equal or lower degree
          while my_exponents(r, n) eq I   do
            a +:= 1;
            r := NormalForm(pi * r, B);
          end while;
          //      if the monomial is in the ideal, all its multiples will be
          if a eq 0 then 
            Append(~Conditions, I);
          else
            tuples_left := true; // still work to do!
            sum +:= a;
          end if;
        end if;  
        I[j] -:= 1;
      end for;
    end for;
    if tuples_left then
      TD +:= 1;
    else
      return sum;  
    end if;  
  end while;
end function;


// Prec is a point record on a regular model M.
// Determine whether the reduction of the point is singular.

function is_singular(Prec, M)

  if #Prec`component_indices gt 1 then // intersection point
    return true;
  elif M`abstract_fibres[Prec`component_indices][1]`multiplicity gt 1 then 
    // component of multiplicity > 1
    return true;
  else // other singular point
    ptc := M`patches[Prec`patch_index];
    pt := Prec`point_reduction;  
    ik := Coercion(M`k, Parent(pt[1]));
    if Universe(pt) eq M`k then
      ChangeUniverse(~pt, M`k);
    end if;
    return IsSingular(Curve(AffineSpace(Parent(ptc`eqns_k[1])), ptc`eqns_k)(ik) !  pt);
  end if;
end function;

function pseudoinverse(A)

  // Compute the Moore-Penrose pseudoinverse of a square matrix A.
  k := Nrows(A);
  assert k eq Ncols(A); // A must be square  
  K := FieldOfFractions(BaseRing(A));
  S := Matrix(K, k, [K ! (1 / k) : i in [1..k^2]]);
  return (A - S)^(-1) + S;
end function;

// Compute the intersection (Phi(D).EE)_p, where D and E are divisors of degree 0
// with Zariski closures DD and EE, respectively, p is a finite prime and Phi(D) 
// is a Q-fibral divisor such that (DD+Phi(D).C_i)_p=0 for all irreducible componente
// C_i of the special fiber above p.
// We only need the vectors wD and wE of intersection multiplicities (DD.C_i)_p and
// (EE.C_i)_p, the intersection matrix I of the special fiber and the vector of its
// multiplicities. 

function comp_Phi(wD, wE, I, mults, p)
  I := ChangeRing(I, Rationals());
  r := #mults;
  A := Matrix(Rationals(), r, r, [[mults[i]*mults[j]*I[i,j] : j in [1..r]] : i in [1..r]]);
  sD := [wD[i]*mults[i] : i in [1..r]];
  sE := [wE[i]*mults[i] : i in [1..r]];
  assert IsZero(&+sD); assert IsZero(&+sE);
  vD := Matrix(Rationals(), 1, sD);
  vE := Matrix(Rationals(), 1, sE);
  vprintf JacHypHeight, 3: " vD = %o\n", vD;
  vprintf JacHypHeight, 3: " vE = %o\n", vE;
  phi1 := (Transpose(vE) * pseudoinverse(A) * vD)[1,1];
  // sanity checks:
  phi2 := (Transpose(vD) * pseudoinverse(A) * vE)[1,1];
  assert phi1 eq phi2;
  wD := Matrix(Rationals(), 1, wD);
  wE := Matrix(Rationals(), 1, wE);
  phis := [];
  for i := 1 to Nrows(I) do
    wDi := RemoveRow(wD, i);
    wEi := RemoveRow(wE, i);
    Ii := RemoveRowColumn(I, i, i);
    Iiinv := Ii ^ (-1);
    PhiDi := Iiinv * wDi;
    Append(~phis, (Transpose(wEi) * PhiDi)[1, 1]);
  end for;
  Append(~phis, phi1);
  assert #SequenceToSet(phis) eq 1; // correction term is well-defined
  return phi1;
end function;

function sort_fibers(M)
  if assigned M`regular_fibres_indices then
    return M`regular_fibres_indices;
  end if;
 return [1..#M`abstract_fibres];
end function; 

// Compute the intersection of the images of P and Q on the special fiber over a regular model of
// the curve over a local ring. Prec and Qrec are records returned by PointOnRegularModel(M,R), 
// where R=P,Q, resp. If the points reduce to singular points on the special fiber, we need to 
// lift the prime divisors over the local ground field instead.

function have_nonsingular_intersection_on_regular_model(Prec, Qrec, M)

  if Prec`point_reduction ne Qrec`point_reduction or Prec`component_indices ne 
                Qrec`component_indices or Prec`patch_index ne Qrec`patch_index then
    return true, 0;
  end if;
  if is_singular(Prec, M) then
    return false, Prec`patch_index;
  end if;
  Pr := Prec`point_coords;
  Qr := Qrec`point_coords;
  return true, Rationals() ! Minimum([Valuation(Pr[1] - Qr[1]), Valuation(Pr[2] - Qr[2]), 
                                        Valuation(Pr[3] - Qr[3])]);
end function;

// Helper function: Replace each occurence of the uniformising element pi in the polynomial
// pol by the polynomial rep.

function replace_pi(pol, pi, rep)
  replc := func<c | ExactQuotient(c, pi ^ v) * rep ^ v
                     where v := Valuation(c)>;
  repeat
    old := pol;
    pol := &+ [replc(cs[i]) * ms[i] : i in [1..#ms]]
            where cs := Coefficients(old) where ms := Monomials(old);
  until pol eq old;
  return pol;
end function;

// Helper function: Divide the multivariate polynomial g by the exact power of each 
// variable of its parent.

function divide_by_powers(pol)
  // To do: Check more carefully what we're dividing out -- see the reg models code.
  for i := 1 to Rank(Parent(pol)) do
    while IsDivisibleBy(pol, Parent(pol).i) do
      pol := pol div Parent(pol).i;
    end while;
  end for;
  return pol;
end function;

function multiplicity_of_point(idl, pt_coords)
  // copied over from RegModel.m/main.m
  Pol := Generic(idl);
  S := Scheme(AffineSpace(Pol), idl);
  F := Universe(pt_coords);
  d := Degree(F, BaseRing(Pol));
  // S(F)!pt_coords sometimes fails -- no idea why!?!
  // F should always be an honest extension of BaseRing(Pol)!
  // Workaround:
  K := ext<BaseRing(Pol) | d>;
  phi := Coercion(F, K);
  pt_K_coords := [phi(a) : a in pt_coords];
  m := Multiplicity(S, S(K)!pt_K_coords);
  return d*m;
end function;

// Lift a divisor given by the polynomials in B to the patch of the regular model M given
// by the patch index idx. ip is the coercion of the ground field K = M`K into the base
// field of L1.

function divisor_on_regular_model(B, M, ip, idx, PK13)

  C := M`C;
  K := M`K;
  R := M`R;
  K1 := BaseRing(B[1]); //Assume K1 is a field
  pi := UniformizingElement(K1);

  function _replace_pi(pol, pi, rep)
    // replace all occurences of pi in pol by rep.    

    function _replc(c)
      if IsWeaklyZero(c) then return 0; end if;
      v := Valuation(c);
      return ExactQuotient(c, pi ^ v) * rep ^ v;
    end function;

    repeat
      old := pol;
      pol := &+ [_replc(cs[i]) * ms[i] : i in [1..#ms]]
              where cs := Coefficients(old) where ms := Monomials(old);
    until pol eq old;
    return pol;
  end function;

  function _divide_by_powers(pol)

    // divide pol by the highest power of every variable dividing pol. 
    for i := 1 to Rank(Parent(pol)) do
      while IsDivisibleBy(pol, Parent(pol).i) do
        pol := pol div Parent(pol).i;
      end while;
    end for;
    return pol;
  end function;

  index := idx;
  indices := [];
  while index ne <0, 1> do
    Append(~indices, index);
    index := M`patches[index]`parent;
  end while;
  // Now indices contains the indices of patches used to construct the relevant patch
  // down to one of the patches covering the original singular model.
  depth := #indices;
  
  x1 := PK13.1; y1 := PK13.2; pi1 := PK13.3; 
  assert K1 eq Codomain(ip); // sanity check
  iota := Coercion(R, Domain(ip));
  h := hom< Universe(M`patches[indices[1]]`map)  -> PK13 | iota * ip, x1, y1, pi1 >;
  maps := [];
  for index in indices do // can't coerce multivariate polynomials to completion
    Append(~maps, [h(g) : g in (M`patches[index]`map)]);
  end for;
  // Now maps contains the blow-up maps connecting the patches indexed by indices.
  vprintf JacHypHeight, 3: " maps = %o\n", maps;
  L := [];
  vprintf JacHypHeight, 3: "   starting patch = %o\n", indices[depth] ;
  vprintf JacHypHeight, 3: "indices = %o\n", indices;
  
  if indices[depth] eq <1, 1> then
    // need to change representation of the divisors.
    multi := hom< Universe(B)  -> PK13 | y1 >;
    if #B eq 2 then
      B := xy_to_st(B[1], B[2], Genus(C));
      L := [clear_denominators(x1 - multi(B[2]))];
    else
      B := [my_polynomial(Reverse(Coefficients(B[1])), Parent(B[1]).1)];
    end if;
  else 
    assert indices[depth] eq <1, 3>;
    multi := hom< Universe(B)  -> PK13 | x1 >;
    if #B eq 2 then 
      L := [clear_denominators(y1 - multi(B[2]))];
    end if;
  end if;
  L cat:= [clear_denominators(multi(B[1]))];

  // Replace occurences of pi.
  L := [_replace_pi(g, pi, pi1) : g in L];
  vprintf JacHypHeight, 3: " starting ideal = %o\n", L;
  for i := 1 to depth - 1 do
    // Apply blow-up maps
    L := [Evaluate(g, maps[depth - i]) : g in L];
    rep := -h(M`patches[indices[depth - i]]`eqns[2] - 
                          TrailingTerm(M`patches[indices[depth - i]]`eqns[2]));
    // Replace occurences of pi by rep where rep = pi on the current patch.
    L := [(_replace_pi(g, pi, rep)) : g in L];
    // Divide by unnecessary powers of variables.
    L := [_divide_by_powers(g) : g in L]; 
    vprintf JacHypHeight, 3: " ideal after blowup %o is  %o\n", i,L;
  end for;
  return L, h;
end function;

// L1 is a list of polynomials defining an irreducible divisor on a curve C over a 
// non-archimedean local field Kp, ip is the coercion of the global ground field K into Kp.
// Assume that the points in its support map to the same point on 
// the reduction of the patch given by index on the regular model M. We also assume that
// that point is singular.
// 
// Compute the intersection multiplicities of the Zariski closure of this divisor 
// with the irreducible vertical components of  M
// by lifting the representative given by L1 to a representative over the 
// patch of M given by index.

function hard_int_with_special_fiber(L1, M, ip, Prec)
  
  Kp := BaseRing(L1[1]);
  Rp := Integers(Kp);
  pi := UniformizingElement(Kp);
  Fp, phi := ResidueClassField(Rp);
  inds := sort_fibers(M);
  mults := Multiplicities(M);
  w := [Rationals()!0 : i in inds];
  index := Prec`patch_index;
  PKp3<x1, y1, pi1> := PolynomialRing(Kp, 3);
  L, h := divisor_on_regular_model(L1, M, ip, index, PKp3);
  vprintf JacHypHeight, 3: " Lift of %o\n to the regular model is \n%o\n", L1, L;
  
  fu := h(M`patches[index]`eqns);
  L cat:= fu;
  vprintf JacHypHeight, 3: " Point reduces to = %o\n", Prec`point_reduction;
  Pkp3 := Universe(Prec`component_eqns[1]);
  res := Coercion(Kp, Rp) * phi * Coercion(Fp, BaseRing(Pkp3));
  res_poly := hom< PKp3  -> Pkp3 | res, Pkp3.1, Pkp3.2, Pkp3.3>;

  for i in [1..#Prec`component_indices] do
    idx := Prec`component_indices[i]; 
    cpt_basis := Prec`component_eqns[i];
    idl := Ideal([res_poly(a) : a in L] cat cpt_basis);
    int := multiplicity_of_point(idl, Prec`point_reduction); 
    w[Index(inds, idx)] +:= int; 
  end for;
  return w;
end function;


function my_point_on_regular_model(x1, y1, M, ip, original, FF)

  // Lift an L-rational point P on a curve C: y^2 = FF(X) to a regular model M of C.
  // Here P = (x1, y1) if original and P = (1, y1, x1) otherwise.
  // ip is coercion from the field C is defined over to L
  C := M`C;
  _, y11 := my_is_square(Evaluate(FF, x1));
  // (x1,y1) might be slightly off the curve due to precision loss.
  if Valuation(y1 - y11) gt Valuation(y1 + y11) then
    y1 := y11;
  else 
    y1 := -y11;
  end if;
  P := original select C(ip) ! [x1, y1] else C(ip) ! [1, y1, x1];
  // Compute image of P on M.
  repeat 
    try 
      Prec := PointOnRegularModel(M, P);
      return Prec, P;
    catch e;
      // Undetected precision loss.
      precis := Minimum([AbsolutePrecision(c) : c in Eltseq(P)]);
      P := C(ip) ! [ChangePrecision(c, precis-1) : c in Eltseq(P)];
    end try;
  until precis lt Precision(Parent(x1)) div 3;
  // If we get here, let PointOnRegularModel throw an error.
  return PointOnRegularModel(M, P), P;
end function;


function reduction_points(L, M, F, ip)

// L is a list of univariate polynomials containing either one or two elements and
// defining a divisor D on the curve C:y^2 = F(x) over a non-archimedean local field Kp.
// M is a regular model of C over Kp, wD is a vector of length n, where n is the number of
// components of the special fiber of M. ip is the coercion map from the field K used 
// to construct M.
//
// Compute a point on the regular model which D reduces to (or two such points, in case D
// defined a pair of points, swapped by the hyperelliptic involution).
  assert IsIrreducible(L[1]);
  Kp := BaseRing(F);
  assert Degree(L[1]) gt 0; // Want affine points.
  if Degree(L[1]) gt 1 then
    // Extend the ground field, because we want the divisor to have pointwise rational support.
    K, iK := an_extension(L[1], Kp);
    fact := Factorisation(coerce_polynomial(L[1], iK));
    min_deg, ind := Min([Degree(t[1]) : t in fact]);
    assert min_deg eq 1; // should have a linear factor
    LK := [fact[ind, 1]]; 
    if #L gt 1  then
      Append(~LK, coerce_polynomial(L[2], iK) mod LK[1]);
    end if;
    FK := coerce_polynomial(F, iK); 
    // Call function on linear factor
    return reduction_points(LK, M, FK, ip*iK);
  else // L defines a point or a pair of points.
    x1 := -Coefficient(L[1], 0) / Coefficient(L[1], 1);
    if #L eq 2 then // L defines a point 
      y1 := Evaluate(L[2], x1);
      Prec, P := my_point_on_regular_model(x1, y1, M, ip, true, F);
      return [my_point_on_regular_model(x1, y1, M, ip, true, F)];
    else 	
      // L defines a pair of points, conjugate under the hyperelliptic involution
      y1_squared := Evaluate(F, x1);
      bool, y1 := my_is_square(y1_squared);
      if bool then 
        return [my_point_on_regular_model(x1, y, M, ip, true, F) : y in [y1, -y1]];
      else //need to extend the field by a root of x^2-F(x1)
        K, iK := an_extension(Polynomial(Kp, [-y1_squared, 0, 1]), Kp);
        FK := coerce_polynomial(F, iK);
        y1K_squared := Evaluate(FK, K ! x1);
        boo, y1K := my_is_square(y1K_squared);
        assert boo;
        return [my_point_on_regular_model(K!x1, yK, M, ip*iK, true, FK) : yK in [y1K, -y1K]];
      end if; // bool
    end if; // #L eq 2 
  end if; // Degree(L[1]) gt 1
end function; 


function int_with_special_fiber(L, M, F, ip)

// L is a list of univariate polynomials containing either one or two elements and
// defining a divisor D on the curve C:y^2 = F(x) over a non-archimedean local field Kp.
// M is a regular model of C over Kp, wD is a vector of length n, where n is the number of
// components of the special fiber of M. ip is the coercion map from the field K used 
// to construct M.
//
// Compute the vector of intersection multiplicities (DD.C_i)_p, where DD is the Zariski 
// closure of D over M and C_i runs through the irreducible components of the special fiber of M.
  inds := sort_fibers(M); 
  mults := Multiplicities(M);
  w := [Rationals()!0 : i in inds];  // w is the vector of intersection multiplicities
  assert Degree(L[1]) gt 0; // handle this special case separately
  fact_A := Factorisation(make_p_primitive(L[1]));
  for t in fact_A do
    L1 := [make_p_primitive(t[1])];
    if #L eq 2 then // Mumford representation
      Append(~L1, L[2] mod L1[1]);
    end if;	
    // let D denote the irreducible divisor associated to t (if #L=1, there are 2 D's)
    // find a point on the special fiber which D reduces to
    redn_pt_recs := reduction_points(L1, M, F, ip);  // have 1 or 2 points, depending on #L
    vertical_line_int_pt := false; 
    for redn_pt_rec in redn_pt_recs do 
      redn_inds := redn_pt_rec`component_indices; // which components does D reduce to?
      if  #redn_inds eq 1 then  // D only reduces to one component
        idx := Index(inds, redn_inds[1]);
        w[idx] +:= Degree(t[1]) * t[2] / mults[idx];
      else // D reduces to an intersection point between two components
        if not vertical_line_int_pt then
          ints := hard_int_with_special_fiber(L1, M, ip, redn_pt_rec);
          w := [w[i] + t[2] * ints[i] : i in [1..#w]];
          if #redn_pt_recs eq 2 then // L1 defines a vertical line which reduces to an 
                                     // intersection point on the special fiber. Only
                                     // compute intersection on special fiber once.
            vertical_line_int_pt := true;
          end if;
        end if;
      end if; // #redn_inds eq 1 
    end for; // redn_pt_rec in redn_pt_recs 
  end for;  // t in fact_A
  total_int := &+[w[i]*mults[i] : i in [1..#w]]; // int with total special fiber, for checking
  check_int := #L eq 2 select Degree(L[1]) else 2;
  error if total_int ne check_int,
         "\nIntersection with special fiber incorrect. This is a bug.";
  return w;
end function;


// L1 and L2 are lists of polynomials defining irreducible divisors on a curve C over a 
// non-archimedean local field Kp, ip is the coercion of the global ground field K into Kp. 
// Assume that the divisors become pointwise rational over a 
// totally ramified extension and so the points in their support map to the same point on 
// the reduction of the patch given by index on the regular model M. We also assume that
// that point is singular.
// 
// Compute the intersection multiplicity of the Zariski closures of these divisors on M
// by lifting the representatives given by L1 and L2 to representatives over the 
// patch of M given by index.

function singular_intersection(L1, L2, M, ip, index)
  Kp := BaseRing(L1[1]);
  Rp := Integers(Kp);
  pi := UniformizingElement(Kp);
  PKp3<x1, y1, pi1> := PolynomialRing(Kp, 3);
  L1, h1 := divisor_on_regular_model(L1, M, ip, index, PKp3);
  L2, h2 := divisor_on_regular_model(L2, M, ip, index, PKp3);
  L := L1 cat L2;
  PKp3 := Universe(L);
  fu := h1(M`patches[index]`eqns);
  if ISA(Type(M`K), FldFunG) then
    quo_ring := Rp;
  else
    quo_ring := quo<Rp | pi ^ (Precision(Rp) + 30) >;
  end if;  
  P_quo_ring := ChangeRing(PKp3, quo_ring);
  vprintf JacHypHeight, 3: " L = %o\n", L cat fu;
  // Compute local Groebner basis.
  local_groebner_basis := GroebnerBasis(ChangeUniverse(L cat fu, P_quo_ring));
  vprintf JacHypHeight, 3: " local groebner basis = %o\n", local_groebner_basis;
  // Compute the intersection as a module length .
  lml := local_module_length(local_groebner_basis);
  vprintf JacHypHeight, 2: " Intersection = %o\n", lml;

  return lml;
end function;



// L1 and L2 are lists of polynomials containing one or two elements and representing effective 
// divisors D and E on the  curve C:y^2=F(x) over a non-archimedean local field Kp. 
// M is a regular model of C over O_Kp or 0 if the reduction of
// C mod  p is non-singular, ip the coercion of the global ground field K into Kp.
// ramified is true iff Kp is ramified over the completion of K and exp is the largest possible 
// individual intersection
// between prime divisors of degree one dividing the Zariski closures DD and EE of D and E, resp.
//
// This function computes the intersection multiplicity (DD.EE)_p unless 
//  1) Kp is a ramified extension of the completion of K 
//  2) p is a bad prime
//  3) the points in the support of DD and EE reduce to singular points on the special fiber of M.
// 
// If these three hold, the function returns false, and singular_intersection should be called 
// instead.
//
// The idea is as follows: We first split the divisors up so that the irreducible parts only 
// intersect on one affine piece at a time. If the prime is good, or the intersection can only 
// take place at points that are already regular on the reduction of C mod p, we use the Mumford
// representation to compute the intersection over Kp using local_module_length. 
//
// Otherwise, we extend the field until both divisors acquire pointwise rational support. 
// If 1)-3) don't all hold, we then compute the intersections between the closures of the prime 
// divisors of degree 1 on the regular model directly.
// Otherwise we simply call singular_intersection.


function have_nonsingular_p_intersection(L1, L2, F, M, C, ip, ramified, force_ground_field, exp)

  original_F := F;
  genus := Ceiling(Degree(F)/2) - 1;
  Kp := BaseRing(F);
  Rp := my_integers(Kp);
  iszero := make_is_zero(Kp);
  iszeropol:= make_is_zero_pol(Kp);

  function abs_coeff_vals(L)
    coeffs := &cat[Coefficients(h): h in L];
    return Maximum([Abs(Valuation(c)) : c in coeffs | not iszero(c)]);
  end function;

  if #L2 eq 2 then 	
    A2, B2 := Explode(L2);
    if #L1 eq 2 then
      // both divisors in Mumford representation
      A1, B1 := Explode(L1);
      type := 1;
    else 
      // one divisor in Mumford representation, one given by a single polynomial
      A1 := Explode(L1);
      type := 2;
    end if;	
  else 
    if #L1 eq 2 then
      // one divisor in Mumford representation, one given by a single polynomial
      // we want to assume the latter is A1 for simplicity
      A2, B2 := Explode(L1);
      A1 := Explode(L2);
      type := 2;
    else 
      // both divisors given by a single polynomial
      A1 := Explode(L1);
      A2 := Explode(L2);
      type := 3;
    end if;	
  end if;	

  intersection_number := 0;

  //some booleans needed in the loop below
  switch := false;
  B11_reduction_problem := false;

  // take out common non-unit factor
  A1 := make_p_primitive(A1); 
  A2 := make_p_primitive(A2);
  x := Parent(A1).1;
  FF := F;

  //now factor A1 and A2
  fact_A1 := Factorisation(A1);
  fact_A2 := Factorisation(A2);
  if type eq 1 and #fact_A2 lt #fact_A1 then 
    // Switch (A1, B1) and (A2, B2), if both B1 and B2 are defined and there are less factors 
    // in A2 than in A1.
    // More efficient for implementation reasons. 
    fact_temp := fact_A2;
    fact_A2 := fact_A1;
    fact_A1 := fact_temp;
    B_temp := B2;
    B2 := B1;
    B1 := B_temp;
  end if;

  for t1 in fact_A1 do
    // take out common non-unit factor
    R1 := make_p_primitive(t1[1]);
    original_R1 := R1;
    if is_on_wrong_affine_piece(R1) then
      switch := true;
    end if;
    if type eq 1 then
      B11 := B1 mod R1; //Note that B11 might not be integral at this point!
      original_B11 := B11;
    end if;	
    exp1 := t1[2]; //multiplicity

    for t2 in fact_A2 do
      // take out common non-unit factor
      R2 := make_p_primitive(t2[1]);
      exp2 := t2[2]; //multiplicity
      done_with_factor  := false;
      if possible_intersection(R1, R2) then
        if type lt 3 then
          // B2 defined - reduce mod R2
          B21 := B2 mod R2;
        end if;	
        if switch or is_on_wrong_affine_piece(R2) then
          // switch to other affine piece
          original_R1 := R1;
          if type eq 1 then
            // B1 defined 
            B11 := original_B11;
            R1, B11 := Explode(xy_to_st(R1, B11, genus));	
            B11 := B11 mod R1;
          end if;	
          if type lt 3 then
            // B2 defined
            R2, B21 := Explode(xy_to_st(R2, B21, genus));
            // To do: Check that we don't have to move R1 to other affine piece in this case.
            B21 := B21 mod R2;
          end if;	
          FF := my_polynomial([0:a in {1..2 * genus + 2 - Degree(FF)}] 
                                            cat Reverse(Coefficients(FF)), x);
        end if;
        if M cmpeq 0 or must_have_regular_common_support(R1, R2, FF) or force_ground_field then 
          //  intersection can be computed on original model.
          B11_reduction_problem := type lt 2 and IsZero(Valuation(LeadingCoefficient(R1))) 
                                       and Minimum([Valuation(c): c in Coefficients(B11)]) lt 0;
          B21_reduction_problem := type lt 3 and IsZero(Valuation(LeadingCoefficient(R2))) 
                                       and Minimum([Valuation(c): c in Coefficients(B21)]) lt 0;
          if B11_reduction_problem or B21_reduction_problem then
            // Need to extend the field because of one of the following:
            // 1) Support of V(R2, B21) reduces to affine piece Z=1,  but B21 is not integral.
            // 2) Support of V(R1, B11) reduces to affine piece Z=1,  but B11 is not integral. 
            if B21_reduction_problem and B11_reduction_problem then
              // It technically doesn't matter which polynomial is used for the extension.
              R_list := [R1, R2];
              _, R_index := Minimum([Degree(R):R in R_list]); 
              //So we take the polynomial of lower degree to get a smaller extension
              R_choice := R_list[R_index];
            elif B11_reduction_problem then
              R_choice := R1;
            else 	
              R_choice := R2;
            end if;
            K, iK := an_extension(R_choice, Kp);
            // Now extend the field, unless the points in the support 
            // of the divisors reduce to a singular pt mod p and the field is ramified.
            if must_have_regular_common_support(R1, R2, FF) or not my_is_ramified(K) then
              R1K := coerce_polynomial(R1, iK);
              R2K := coerce_polynomial(R2, iK);
              if type lt 3 then
                B2K := coerce_polynomial(B21, iK);
                L2K := [R2K, B2K];
                if type lt 2 then
                  B1K := coerce_polynomial(B11, iK);
                  L1K := [R1K, B1K];
                else
                  L1K := [R1K];
                end if;
              else 
                L1K := [R1K];
                L2K := [R2K];
              end if;
              FK := coerce_polynomial(FF, iK);
              vprintf JacHypHeight, 3: "Need to extend the field to: \n%o\n", K;
              // Compute intersection over extension
              bool, int := have_nonsingular_p_intersection(L1K, L2K, FK, M, C, ip * iK, 
                              ramified or my_is_ramified(K), false, RamificationDegree(K) * exp);
              assert bool;
              intersection_number +:= exp1 * exp2 * int / RamificationDegree(K);		
              done_with_factor := true;
            end if;
          end if; 
          // Can work over the ground field
          if not done_with_factor then
            Pr2<t, u> := PolynomialRing(Rp, 2, "grevlex");
            L1 := [uni_to_int_multi(R1, Pr2)];
            L2 := [uni_to_int_multi(R2, Pr2)];

            // coerce the polynomial into poly ring in 2 variables
            if type lt 3 then
              if B21_reduction_problem then // B21 not integral; need to clear denominator.
                b21, d2 := clear_p_denominator(B21);
                Append(~L2, Rp ! d2 * u - uni_to_int_multi(b21, Pr2));
              else
                Append(~L2, u - uni_to_int_multi(B21, Pr2));
              end if;
              if type lt 2 then
                if B11_reduction_problem then // B11 not integral; need to clear denominator.
                  b11, d1 := clear_p_denominator(B11);
                  Append(~L1, Rp ! d1 * u - uni_to_int_multi(b11, Pr2));
                else
                  Append(~L1, u - uni_to_int_multi(B11, Pr2));
                end if;
              end if;
            end if;	
            fp := uni_to_int_multi(FF, Pr2);
            // Now compute the Groebner basis over the truncated local ring.
            trunc := Maximum(exp,  abs_coeff_vals(L1 cat L2));
            if ISA(Type(Domain(ip)), FldFunG) then
              quo_ring := Rp;
            else
              quo_ring := quo<Rp | UniformizingElement(Rp) ^ (trunc + 10)>;
            end if;
            P_quo_ring := ChangeRing(Pr2, quo_ring);
            local_groebner_basis := GroebnerBasis(ChangeUniverse(L1 cat L2 cat [u ^ 2 - fp], 
                                                                                P_quo_ring));
            vprintf JacHypHeight, 3: " local groebner basis = %o\n", local_groebner_basis;

            // Compute the intersection as a module length.
            lml := local_module_length(local_groebner_basis);
            vprintf JacHypHeight, 3: " length = %o\n", lml;

            intersection_number +:= exp1 * exp2 * lml;
          end if; // not done_with_factor
                        
        elif Degree(R1) * Degree(R2) gt 1 then
          // Now we have an intersection over a singular point of the reduction of C 
          // over some extension. 
          // Need to extend the field until all points in the support are defined over the 
          // ground field
          R_list := [R1, R2];
          _, R_index := Maximum([Degree(R) : R in R_list]); 
          // We take the polynomial of higher degree to get a larger extension 
          R_choice := R_list[R_index];
          K, iK := an_extension(R_choice, Kp);
          R1K := coerce_polynomial(R1, iK);
          R2K := coerce_polynomial(R2, iK);
          if type lt 3 then
            B2K := coerce_polynomial(B21, iK);
            L2K := [R2K, B2K];
            if type lt 2 then
              B1K := coerce_polynomial(B11, iK);
              L1K := [R1K, B1K];
            else
              L1K := [R1K];
            end if;
          else 
            L1K := [R1K];
            L2K := [R2K];
          end if;
          FK := coerce_polynomial(FF, iK);
          bool, int := have_nonsingular_p_intersection(L1K, L2K, FK, M, C, ip * iK, 
                          ramified or my_is_ramified(K), false, exp * RamificationDegree(K));
          if not bool then 
            // K is totally ramified and the intersection point is singular
            vprintf JacHypHeight, 2: " Horizontal intersection at a singular point of 
                                                                  the special fiber\n";
            if not ramified then
              assert IsTotallyRamified(K); 
              // Check if the bad point is singular on first affine piece.
              if not iszeropol(FF - F) then  // switch to original affine piece
                if type eq 1 then
                  // B1 defined 
                  R1, B11 := Explode(xy_to_st(R1, B11, genus));	
                  B11 := B11 mod R1;
                end if;	
                if type lt 3 then
                  //B2 defined
                  R2, B21 := Explode(xy_to_st(R2, B21, genus));
                  B21 := B21 mod R2;
                end if;
              end if;

              L1 := [R1];
              L2 := [R2];
              if type lt 3 then
                Append(~L2, B21);
                if type lt 2 then
                  Append(~L1, B11);
                end if;
              end if;
          
              // Compute intersection by lifting L1 and L2 to patch of M given by int.
              if int[1] eq 1 then // Singular point on fiber is regular on the surface.
                bool, int := have_nonsingular_p_intersection(L1, L2, F, M, C, ip, ramified, 
                                                                  true, exp);
              else
                int := singular_intersection(L1, L2, M, ip, int);
              end if;
            else 
              return false, int;
            end if;
          else
            int /:= RamificationDegree(K);			
          end if;
          intersection_number +:= exp1 * exp2 * int;
        else 
          // Polynomials represent points
          x1 := -Coefficient(R1, 0) / Coefficient(R1, 1);
          x2 := -Coefficient(R2, 0) / Coefficient(R2, 1);
          y2_squared := Evaluate(FF, x2);
          y1_squared := Evaluate(FF, x1);
          // Are the points defined over Kp? If not, extend the field.
          bool2, y22 := my_is_square(y2_squared);
          bool1, y11 := my_is_square(y1_squared);
          if not bool1 then
            //need to extend the field by x^2-f(x1) or x^2-f(x2)
            K, iK := (an_extension(x ^ 2 - y1_squared, Kp));
            ip := ip * iK;
          elif not bool2 then	
            K, iK := (an_extension(x ^ 2 - y2_squared, Kp));
            ip := ip * iK;
          end if;
          if not bool1 or not bool2 then
            R1K := coerce_polynomial(R1, iK);
            R2K := coerce_polynomial(R2, iK);
            if type lt 3 then
              B2K := coerce_polynomial(B21, iK);
              L2K := [R2K, B2K];
              if type lt 2 then
                B1K := coerce_polynomial(B11, iK);
                L1K := [R1K, B1K];
              else
              L1K := [R1K];
              end if;
            else 
              L1K := [R1K];
              L2K := [R2K];
            end if;
            FK := coerce_polynomial(FF, iK);
            vprintf JacHypHeight, 2: "Need to extend the field to: \n%o\n", K;
            // Compute intersection over extension.
            bool, int := have_nonsingular_p_intersection(L1K, L2K, FK, M, C, ip * iK, 
                            ramified or my_is_ramified(K), false, exp * RamificationDegree(K));
            if not bool then
              if not ramified then // can compute intersection over K.
                assert IsTotallyRamified(K);
                if not iszeropol(FF - F) then  // switch to original affine piece
                  if type eq 1 then
                    // B1 defined 
                    R1, B11 := Explode(xy_to_st(R1, B11, genus));	
                    B11 := B11 mod R1;
                  end if;	
                  if type lt 3 then
                    //B2 defined
                    R2, B21 := Explode(xy_to_st(R2, B21, genus));
                    B21 := B21 mod R2;
                  end if;
                end if;

                L1 := [R1];
                L2 := [R2];
                if type lt 3 then
                  Append(~L2, B21);
                  if type lt 2 then
                    Append(~L1, B11);
                  end if;
                end if;
                // Compute intersection by lifting L1 and L2 to patch of M given by int.
                vprintf JacHypHeight, 3: " Horizontal intersection at a singular point of 
                                                                      the special fiber\n";
                int := singular_intersection(L1, L2, M, ip*iK, int);
              else 
                // need to compute intersection over subfield of K that is an
                // unramified extension of the original ground field.
                return false, int;
              end if;
            else
                int /:= RamificationDegree(K);			
            end if;
              intersection_number +:= exp1 * exp2 * int;
          else	
            // Can work over the ground field
            if type lt 3 then 
              // B2 defined
              y2 := Evaluate(B21, x2);
              if type eq 1 then 
                //B1 defined
                 y1 := Evaluate(B11, x1);
              else	
                // y2 is either one of the possible values, since we need to intersect with both points anyway
                y1 := y11;
              end if;
            else
              y1 := y11;
              y2 := y22;
            end if;	
            fC := coerce_polynomial(HyperellipticPolynomials(C), ip);
            if iszeropol(FF - fC) then
              // We're on the original affine piece
              P1rec, P1 := my_point_on_regular_model(x1, y1, M, ip, true, FF);
              P2rec, P2 := my_point_on_regular_model(x2, y2, M, ip, true, FF);
            else 	
              // We're not on the original affine piece
              P1rec, P1 := my_point_on_regular_model(x1, y1, M, ip, false, FF);
              P2rec, P2 := my_point_on_regular_model(x2, y2, M, ip, false, FF);
            end if;

            // Compute intersection on regular model
            bool, int := have_nonsingular_intersection_on_regular_model(P1rec, P2rec, M);
            if bool then
              intersection_number +:= exp1 * exp2 * int;
            else
              // need to compute intersection over subfield of Kp
              return false, int;
            end if;
            if type gt 1 then
              // Also need to intersect P2 with -P1
              // To do: Use my_point_on_regular_model.
              P1mrec := PointOnRegularModel(M, M`C(ip) ! [Eltseq(P1)[1], -Eltseq(P1)[2], Eltseq(P1)[3]]); 
              bool, int := have_nonsingular_intersection_on_regular_model(P1mrec, P2rec, M);
              assert bool; // Otherwise we should never get here, as the points are rational.
              intersection_number +:= exp1 * exp2 * int;
              if type eq 3 then
                // Also need to intersect -P2 with P1 and -P1
                P2mrec := PointOnRegularModel(M, M`C(ip) ! [Eltseq(P2)[1], -Eltseq(P2)[2], Eltseq(P2)[3]]);
                bool, int := have_nonsingular_intersection_on_regular_model(P1rec, P2mrec, M);
                assert bool; // Otherwise we should never get here, as the points are rational.
                intersection_number +:= exp1 * exp2 * int;
                bool, int := have_nonsingular_intersection_on_regular_model(P1mrec, P2mrec, M);
                assert bool; // Otherwise we should never get here, as the points are rational.
                intersection_number +:= exp1 * exp2 * int;
              end if;
            end if;
          end if; // not bool1 or not bool2 
        end if;	 // M cmpeq 0 or must_have_regular_common_support(R1, R2, FF) 
      end if; // possible_intersection(R1, R2) 
      // Need to reset the following in case we switched to other affine piece.
      FF := F; 
      R1 := original_R1;
      if type eq 1 then 
        B11 := original_B11;
      end if;	
    end for; // t2 in fact_A2 
    switch := false;
  end for; // t1 in fact_A1 
  return true, intersection_number;
end function;

function horizontal_intersection(L1, L2, F, M, C, ip, exp)
  bool, n := have_nonsingular_p_intersection(L1, L2, F, M, C, ip, false, false, exp);
  if not bool then
    vprintf JacHypHeight, 3: " Horizontal intersection at a singular point of the special fiber\n";
    // To do: singular_intersection assumes the div's become ptwise rat'l over a totally
    // ramified extension. Check that this is the case here.
    n := singular_intersection(L1, L2, M, ip, n);
  end if;
  return n;
end function;


// a is an element of the polynomial ring P3 over Z or over k[x] (k finite) in 3 variables, 
// but it contains only the third variable.
// Replace this variable by a primitive element of the extension R.

function replace_T_by_alpha(a, R)
  if ISA(Type(R), RngInt) or ISA(Type(R), RngUPol) then
    return Coefficients(a)[1];
  else	
    coeffs := Coefficients(a, Parent(a).3);
    alpha := PrimitiveElement(R);
    return &+ [alpha ^ (i - 1) * BaseRing(R) ! coeffs[i] : i in [1..#coeffs]];
  end if;	
end function;


function add_entry(L, triple)

  i := Index([t[1] : t in L], triple[1]);
  if i eq 0 then
    return Append(L, triple);
  else 
    L[i,2] +:= triple[2];
    return L;
  end if;	
end function;


  // P and Q are points on the Jacobian of the hyperelliptic curve C, given by lists (a1,b1,d)
  // and (a2,b2,d).
  // We assume that their reduced positive representations have disjoint support.
  // lambda and mu are elements of the ground field, pot_irreg_primes is a list of places p such 
  // that the reduction of C mod p may not be regular; prec is the desired precision.
  //
  // Let D_P and D_Q denote the positive parts of the canonical representatives of the divisor 
  // classes given by P and Q, respectively and let d, e denote their respective degrees. 
  // Let D_inf denote the line at infinity and D_lambda, D_mu the lines
  // defined by x-lambda and x-mu, respectively. L
  // If mu is zero, we compute the sum of all local non-archimedean Neron symbols
  //            <D_P - d/2 *D_lambda, D_Q - e/2 *D_inf>_p
  // and other wise we compute the sum of all local non-archimedean Neron symbols
  //            <D_P - d/2 *D_lambda, D_Q - e/2 *D_mu>_p
  //
  // We first find out which primes p may yield non-trivial Neron symbols using Groebner basis 
  // over the ring of integers of the ground field.
  // Let p be such a prime and let DD_P, DD_Q, DD_lambda, DD_mu and DD_inf denote the respective
  // closures of the divisors above on a regular model of C over Spec(O_p). 
  // If mu=0 (the other case is simular), we compute 
  //    <D_P - d/2 *D_lambda, D_Q - e/2 *D_infty>_p 
  //  = N_p((DD_P - d/2 *DD_lambda . DD_Q - e/2 *DD_infty)_p + (Phi_p . DD_Q-e/2* D_inf)_p), (1)
  // where  Phi_p is a Q-fibral divisor such that 
  //    (DD_P - d/2 * D_lambda + Phi_p. C_i)_p =0  for all irreducible components
  // C_i of the special fiber of the regular model above p and N_p is a certain local factor 
  // depending only on p.
  //
  // If p is not in pot_irreg_primes, then the second term in (1) vanishes and we can compute the
  // first term directly on the reduction mod p. Otherwise we compute the second term by finding 
  // the intersections of DD, DD_Q, etc. with the irreducible components C_i. 
  // The computation of the first term is more involved and depends on whether or not the points
  // in the support of any of the effective divisors considered map to singular points on the 
  // special fiber of the regular model.


function finite_intersection(P, Q, C, lambda, mu, pot_irreg_primes, local_prec)
  genus := Genus(C);
  K := BaseRing(P[1]);
  f := HyperellipticPolynomials(C);
  R := my_integers(K);
  x := Parent(P[1]).1;
  // If we have points at infinity in the support of the positive part of D_P or D_Q,
  // we need to treat these separately.
  bP, P0, nP := contains_point_at_infinity(P);
  bQ, Q0, nQ := contains_point_at_infinity(Q);
  dP := ISA(Type(K), FldFunG) select Integers() ! ConstantCoefficient(P[3]) else Integers() ! P[3];
  dQ := ISA(Type(K), FldFunG) select Integers() ! ConstantCoefficient(Q[3]) else Integers() ! Q[3];

  ints_list := [];
  // Compute a groebner basis to find primes of non-trivial intersection multiplicity
  groebner_basis, L := global_groebner_basis([P[1], P[2]], [Q[1], Q[2]], f);
  d1, d2 := Explode(ChangeUniverse(L, R));
  // The last element of the groebner basis tells us which primes contribute towards the 
  // intersection on the affine piece Z=1
  q0list := [g : g in groebner_basis | Degree(g, Parent(g).1) eq 0 
                                            and Degree(g, Parent(g).2) eq 0];
  // q0 is in Z or in Z[T], where T satisfies the min poly of K. need to find the corresponding 
  // element of R.
  q0list := [replace_T_by_alpha(q, R):q in q0list ];
  q0list := [q : q in q0list | not IsZero(q)];
  q0 := &* [q : q in q0list]; 

  // We find all primes p such that DD and EE intersect over p on the affine piece X=1
  more_primes := [p: p in my_prime_divisors(d1, R) | p in my_prime_divisors(d2, R)]; 
  //move points over to affine piece X=1
  f_inf := my_polynomial([0:a in {1..2 * genus + 2 - Degree(f)}] cat Reverse(Coefficients(f)), x);
  P_inf := xy_to_st(P[1], P[2], genus);
  P_inf[2] := P_inf[2] mod P_inf[1];
  Q_inf := xy_to_st(Q[1], Q[2], genus);
  Q_inf[2] := Q_inf[2] mod Q_inf[1];
  groebner_basis_inf := global_groebner_basis(P_inf, Q_inf, f_inf);
  q_inf := replace_T_by_alpha(groebner_basis_inf[#groebner_basis_inf], R);
  fact_qinf := [<p, Valuation(q_inf, p)> : p in more_primes];   
  if not (ISA(Type(R), RngInt) or ISA(Type(R), RngUPol)) then
    q0 := ideal<R | q0>;
  end if;	
  for i := 1 to #more_primes do
    p := more_primes[i];
    q0:=q0 div p ^ Valuation(q0, p);
  end for;	

  // We find all primes p such that DD_P and DD_Q intersect over p on the affine piece Z=1
  fact_q0 := my_factorisation(q0, R);
  fact := fact_q0 cat fact_qinf;

  
  // We find all primes p such that DD_Q and DD_lambda intersect over p on the affine piece Z=1 
  lambda_groebner_basis := global_groebner_basis([Q[1], Q[2]], [x - lambda], f);
  q0_lambda := lambda_groebner_basis[#lambda_groebner_basis];
  q0_lambda := replace_T_by_alpha(q0_lambda, R);
  fact_lambda := my_factorisation(q0_lambda, R);
  if IsZero(mu) then
    // don't move the divisor at infinity in the rep of Q
    // We find all primes p such that DD_P and DD_inf intersect at p 
    inf_groebner_basis := global_groebner_basis([P_inf[1], P_inf[2]], [x], f_inf);
    q0_inf := inf_groebner_basis[#inf_groebner_basis];
    q0_inf := replace_T_by_alpha(q0_inf, R);
    fact_inf := my_factorisation(q0_inf, R);
  else 
    // We find all primes p such that DD_P and DD_mu intersect over p on the affine piece Z=1 
    mu_groebner_basis := global_groebner_basis([P[1], P[2]], [x - mu], f);
    q0_mu := mu_groebner_basis[#mu_groebner_basis];
    q0_mu := replace_T_by_alpha(q0_mu, R);
    fact_mu := my_factorisation(q0_mu, R);

    // We find all primes p such that DD_lambda and mu intersect over p on the affine piece Z=1 
    mu_lambda_groebner_basis := global_groebner_basis([x - lambda], [x - mu], f);
    q0_mu_lambda := mu_lambda_groebner_basis[#mu_lambda_groebner_basis];
    q0_mu_lambda := replace_T_by_alpha(q0_mu_lambda, R);
    fact_mu_lambda := my_factorisation(q0_mu_lambda, R);

    if bP then 
      // We find all primes p such that DD_Q and DD_P0  intersect at p,
      // where P0 is the point at infinity in the positive part of P
      P0_groebner_basis := global_groebner_basis([Q_inf[1], Q_inf[2]], 
                                                   [x - P0[3], Parent(x) ! (P0[2])], f_inf);
      q0_P0 := P0_groebner_basis[#P0_groebner_basis];
      q0_P0 := replace_T_by_alpha(q0_P0, R);
      fact_P0 := my_factorisation(q0_P0, R);
    end if;
  end if;  
  if bQ then
    // We find all primes p such that DD_P and DD_Q0  intersect at p
    // where Q0 is the point at infinity in the positive part of Q
    Q0_groebner_basis := global_groebner_basis([P_inf[1], P_inf[2]], 
                                                    [x - Q0[3], Parent(x) ! (Q0[2])], f_inf);
    q0_Q0 := Q0_groebner_basis[#Q0_groebner_basis];
    q0_Q0 := replace_T_by_alpha(q0_Q0, R);
    fact_Q0 := my_factorisation(q0_Q0, R);
    if bP then
      // Also need to intersect the closures of the two points at infinity
      P0_Q0_groebner_basis := global_groebner_basis([x - P0[3], Parent(x) ! (P0[2])], [x - Q0[3], 
                                                                    Parent(x) ! (Q0[2])], f_inf);
      q0_P0_Q0 := P0_Q0_groebner_basis[#P0_Q0_groebner_basis];
      q0_P0_Q0 := replace_T_by_alpha(q0_P0_Q0, R);
      fact_P0_Q0 := my_factorisation(q0_P0_Q0, R);
    end if;       
  end if;

  // extension_fields contains those local fields that are needed in case the computation
  // of the regular model at p requires an extension of the global ground field.
  extension_fields := AssociativeArray();

  function get_extension_data(extension_fields, p);
    tuple := extension_fields[p];                          
    return tuple[1], tuple[2], tuple[3];
  end function;
  
  // Now we compute the correction terms (Phi_p. DD_Q-e/2* D_inf)_p resp. 
  // (Phi_p. DD_Q-e/2* D_mu)_p.
  for p in pot_irreg_primes do

    // Find which primes might require a non-trivial correction term.
    Kp, phip := my_completion(K, p, local_prec);
    listP := [[P[1], f], [P_inf[1], f_inf], [x - lambda, f]];
    if bP then Append(~listP, [x, f_inf]); end if; 
    listQ := [[Q[1], f], [Q_inf[1], f_inf]];
    if not IsZero(mu) then 
      Append(~listQ, [x - mu, f]);
    end if;
    if bQ or IsZero(mu) then  
      Append(~listQ, [x, f_inf]);
    end if;
    DP_has_bad_reduction := not &and[has_good_reduction_over(pair[1], pair[2], p): pair in listP];
    DQ_has_bad_reduction := not &and[has_good_reduction_over(pair[1], pair[2], p): pair in listQ];
    if not has_squarefree_reduction(coerce_polynomial(f, phip)) or 
                         (DP_has_bad_reduction and DQ_has_bad_reduction) then
      A1, A2, B1, B2, F := Explode(coerce_polynomials([P[1], Q[1], P[2], Q[2], f], phip));
      // Compute the regular model.
      M := RegularModel(C, p);
      if not M`original_is_regular or not has_squarefree_reduction(coerce_polynomial(f, phip)) then 
        // Curve wasn't regular to begin with or the special fiber wasn't irreducible.
        multiplicities := Multiplicities(M);
        if #multiplicities ne 1 then 
          //more than 1 component, so we may have nontrivial correction term
          if C ne M`C  then
            vprintf JacHypHeight, 3: " Regular model needs extension field\n"; 
            // Extension was needed to compute M;
            L := M`K;
            g := coerce_polynomial(DefiningPolynomial(L), phip);
            // Compute a common extension of Kp and L and store it along with the coercion from L 
            // and the regular model
            Lp, ip := an_extension(g, Kp);
            A1, A2, B1, B2, F := Explode(coerce_polynomials([A1, A2, B1, B2, F], ip));
            phip := map< L -> Lp | x:-> &+ [Lp | Kp ! ip(e[i]) * Lp.1 ^ (i - 1) : i in [1..#e]] 
                                                                           where e is Eltseq(x) >;
            extension_fields[p] := <Lp, phip, M>;
          else 
            Lp := Kp;
          end if;  
          w := [Rationals() ! 0 : i in [1..#multiplicities]]; // empty vector
          L1 := [A1, B1];
          L2 := [A2, B2];
          // To do: Is there some simple way to give magma the information that there's a repeated
          // factor?
           
          vprintf JacHypHeight, 2: "Compute intersection of DD_P with irreducible components\n" ;
          wD1 := int_with_special_fiber(L1, M, F, phip);
          
          vprintf JacHypHeight, 2: "Compute intersection of DD_Q with irreducible components\n" ;
          wE1 := int_with_special_fiber(L2, M, F, phip);
          
          A_lambda := coerce_polynomial(x - lambda, phip);
          vprintf JacHypHeight, 2: "Compute intersection of DD_lambda with irreducible 
                                                                                components\n";
          wD2 := int_with_special_fiber([A_lambda], M, F, phip);
          wD2 := [l * dP / 2 : l in wD2];

          if mu eq 0 then
            // find the vectors containing the intersection of DD_inf with the irreducible components
            vprintf JacHypHeight, 2: "Compute  intersection of DD_inf with irreducible components\n" ;
              
            inf_pts_set := my_points_at_infinity(M`C, phip);
            inf_pts := [M`C(phip) ! Eltseq(pt) : pt in inf_pts_set];
            vprintf JacHypHeight, 3: "Have %o rational pts at infinity\n", #inf_pts;
            wE2 := w;
            if IsOne(#inf_pts) then
              // Unique rational pt at infinity
              inf_pt := inf_pts[1];
              infrec := PointOnRegularModel(M, inf_pt);
              assert IsOne(#infrec`component_indices); 

              // Modify current vector of intersection multiplicities.
              idx := Index(sort_fibers(M), infrec`component_indices[1] );
              wE2[idx] +:= Degree(A2) / multiplicities[idx];
            else
              if IsZero(#inf_pts) then
                // No rational points at infinity. need to extend the field by a root of the 
                // leading coeff of F.
                Mp, ip := an_extension(Polynomial([-LeadingCoefficient(F), 0, 1]), Lp); 
                ip := phip * ip;
                inf_pts_set := my_points_at_infinity(M`C, ip);
                inf_pts := [M`C(ip) ! Eltseq(pt):pt in inf_pts_set];
              end if;	
              // now we must have two rational pts at infinity
              inf_int_pt := false;
              for j := 1 to 2 do
                inf_pt := inf_pts[j];
                vprintf JacHypHeight, 3: "pt at infinity = %o\n",inf_pt;
                infrec := PointOnRegularModel(M, inf_pt);
                vprintf JacHypHeight, 3: "indices: %o\n", infrec`component_indices;
                if #infrec`component_indices gt 1 or inf_int_pt  then 
                  // at least one of the points at infinity (hence both?!) reduces to an
                  // intersection point on the regular model.
                  inf_int_pt := true;
                else 
                  idx := Index(sort_fibers(M), infrec`component_indices[1] );
                  wE2[ idx ] +:= Degree(A2) / 2 / multiplicities[idx]; 
                end if;
              end for;        
              if inf_int_pt then
                vprintf JacHypHeight, 2: "index of component=%o\n", infrec`component_indices;
                // Work on the regular model of the curve given by f_inf, where the pts at
                // infinity are represented by 
                // This is stupid, because we need to compute another regular model
                // containing no new information but necessary at the moment because of how
                // hard_int_with_special_fiber is coded.
                C_inf := HyperellipticCurve(ChangeRing(f_inf, M`K)); 
                M_inf := RegularModel(C_inf, p);
                infrec1 := PointOnRegularModel(M_inf, C_inf(ip)!  Reverse(Eltseq(inf_pts[1])));
                infrec2 := PointOnRegularModel(M_inf, C_inf(ip)!  Reverse(Eltseq(inf_pts[2])));
                assert infrec1`component_indices eq infrec2`component_indices;
                wEE2 := hard_int_with_special_fiber([coerce_polynomial(x, phip)], M_inf, phip, infrec1);
                wE2 := [wE2[i] + wEE2[i] : i in [1..#wE2]];
              end if;
            end if;	
          else
            A_mu := coerce_polynomial(x - mu, phip);
            vprintf JacHypHeight, 3: "Compute intersection of DD_mu with irreducible components\n" ;
            // find the vectors containing the intersection of DD_mu with the irreducible components
            wE2 := int_with_special_fiber([A_mu], M, F, phip);
            wE2 := [l * dQ / 2 : l in wE2];

            if bP then
              P0rec := PointOnRegularModel(M, M`C ! P0);
              // find the vectors containing the intersection of DD_P0 with the irreducible components
              for ind in P0rec`component_indices do
                wD1[Index(sort_fibers(M), ind)] +:= nP;
              end for;
            end if;
          end if; 
          if bQ then 
            Q0rec := PointOnRegularModel(M, M`C ! Q0);
            // find the vectors containing the intersection of DD_Q0 with the irreducible components
            for ind in Q0rec`component_indices do
              wE1[Index(sort_fibers(M), ind)] +:= nQ ;
            end for;
          end if;  
          vprintf JacHypHeight, 3: "wD1= %o\n", wD1;
          vprintf JacHypHeight, 3: "wD2= %o\n", wD2;
          vprintf JacHypHeight, 3: "wE1= %o\n", wE1;
          vprintf JacHypHeight, 3: "wE2= %o\n", wE2;
          wD := [wD1[i] - wD2[i] : i in [1..#multiplicities]];
          vprintf JacHypHeight, 3: "Vector of intersection multiplicities of first divisor with 
                                                      irred cpts of the special fiber:\n%o\n", wD;
          wE := [wE1[i] - wE2[i] : i in [1..#multiplicities]];
          vprintf JacHypHeight, 3: "Vector of intersection multiplicities of second divisor with 
                                                      irred cpts of the special fiber:\n%o\n", wE;
          // Compute the second term in (1)
          if &and[IsZero(c) : c in wD] or &and[IsZero(c) : c in wE] then
            pi := 0;
          else 
            I := IntersectionMatrix(M);
            pi := comp_Phi(wD, wE, I, multiplicities, p);
          end if;
          vprintf JacHypHeight, 2: "Correction term at %o is equal to %o\n", p, pi;
	  ints_list := add_entry(ints_list, <p, - Rationals() ! pi, local_factor(Kp)>);

        end if;
      else // Curve was already regular.                        
        Remove(~pot_irreg_primes, Index(pot_irreg_primes, p));                    
      end if;
    end if; // not has_squarefree_reduction(coerce_polynomial(f, phip)) or ...
  end for; // p in pot_irreg_primes 
  // Now we compute the intersections between the various horizontal divisors.

  // Compute all (DD_P. DD_Q)_p
  vprintf JacHypHeight, 3: " possibly non-trivial intersection of D_P and D_Q at : %o\n", fact;
  for T in fact do
    p := T[1];
    exp := T[2];
    Kp, phip := my_completion(K, p, local_prec);

    A1, A2, B1, B2, F := Explode(coerce_polynomials([P[1], Q[1], P[2], Q[2], f], phip));
    M := 0;
    A1_inf := xy_to_st(A1, B1, genus)[1];
    A2_inf := xy_to_st(A2, B2, genus)[1];
    F_inf := coerce_polynomial(f_inf, phip);
    if p in pot_irreg_primes and not &and[must_have_regular_common_support(t[1], t[2], t[3]) 
                                          : t in [[A1, A2, F], [A1_inf, A2_inf, F_inf]]] then	
      // Need to work on regular model.
      if IsDefined(extension_fields, p) then
        // Need to work over extension of Kp
        Lp, phip, M := get_extension_data(extension_fields, p);
        A1, A2, B2, F := Explode(coerce_polynomials([A1, A2, B2, F], phip));
      else 
        M := RegularModel(C, p);
        if M`original_is_regular then 
          M := 0;
          Remove(~pot_irreg_primes, Index(pot_irreg_primes, p));
        end if;  
      end if;  
    end if;       
    // Compute intersection.
    n := horizontal_intersection([A1, B1], [A2, B2], F, M, C, phip, exp);
    vprintf JacHypHeight, 2: "Intersection multiplicity of D_P and D_Q at %o 
                                                      is equal to %o \n", p, n; 
    ints_list := add_entry(ints_list, <p, Rationals()! n, local_factor(Kp)>);
  end for; // T in fact

  // Compute all (DD_lambda. DD_Q)_p
  vprintf JacHypHeight, 3: " possibly non-trivial intersection of D_lambda and D_Q at : 
                                                                        %o\n", fact_lambda;
  for T in fact_lambda do
    p := T[1];
    exp := T[2];
    Kp, phip := my_completion(K, p, local_prec);
    A1, A2, B1, F := Explode(coerce_polynomials([Q[1], x - lambda, Q[2], f], phip));
    M := 0;
    if p in pot_irreg_primes and not must_have_regular_common_support(A1, A2, F) then	
      // Need to work on regular model.
      if IsDefined(extension_fields, p) then
        // Need to work over extension of Kp
        Lp, phip, M := get_extension_data(extension_fields, p);
        A1, A2, B1, F := Explode(coerce_polynomials([A1, A2, B1, F], phip));
      else 
        M := RegularModel(C, p);
        if M`original_is_regular then 
          M := 0;
          Remove(~pot_irreg_primes, Index(pot_irreg_primes, p));
        end if;  
      end if;  
    end if;       
    // Compute intersection.
    n := horizontal_intersection([A1, B1], [A2], F, M, C, phip, exp);
    vprintf JacHypHeight, 2: "Intersection multiplicity of D_lambda and D_Q at %o 
                                                            is equal to %o \n", p, n; 
    ints_list := add_entry(ints_list, <p, -Rationals() ! n * dP /2, local_factor(Kp)>);
  end for; // T in fact_lambda

  if mu eq 0 then
    // Compute all (DD_P. DD_inf)_p
    vprintf JacHypHeight, 3: " possibly non-trivial intersection of D_P and D_inf at : 
                                                                          %o\n", fact_inf;
    for T in fact_inf do
      p, exp := Explode(T);
      Kp, phip := my_completion(K, p, local_prec);
      A1, A2, B2, F := Explode(coerce_polynomials([x, P_inf[1], P_inf[2], f_inf], phip));
      M := 0;
      if p in pot_irreg_primes and not must_have_regular_common_support(A1, A2, F) then	
        // Need to work on regular model.
        if IsDefined(extension_fields, p) then
          // Need to work over extension of Kp
          Lp, phip, M := get_extension_data(extension_fields, p);
          A1 , A2 , B2 , F := Explode(coerce_polynomials([A1 , A2 , B2 , F] ,phip));
        else 
          M := RegularModel(C, p);
          if M`original_is_regular then 
            M := 0;
            Remove(~pot_irreg_primes, Index(pot_irreg_primes, p));
          end if;  
        end if;  
      end if;       
      // Compute intersection.
      n := horizontal_intersection([A1], [A2, B2], F, M, C, phip, exp);
      vprintf JacHypHeight, 2: "Intersection multiplicity of D_P and D_inf at %o 
                                                                is equal to %o \n", p, n; 
      ints_list := add_entry(ints_list, <p, -Rationals() ! n * dQ /2, local_factor(Kp)>);
    end for; // T in fact_inf

  // Now for the case of divisors possibly containing points at infinity in the positive part;
  // These must be rational. Also assume that P and Q do not contain the same point at infinity.
  else
    // Compute all (DD_P. DD_mu)_p
    vprintf JacHypHeight, 3: " possibly non-trivial intersection of D_P and D_mu at :
                                                                              %o\n", fact_mu;
    for T in fact_mu do
      p, exp := Explode(T);
      Kp, phip := my_completion(K, p, local_prec);
      A1, A2, B1, F := Explode(coerce_polynomials([P[1], x - mu, P[2], f], phip));
      M := 0;
      if p in pot_irreg_primes and not must_have_regular_common_support(A1, A2, F) then	
        // Need to work on regular model.
        if IsDefined(extension_fields, p) then
          // Need to work over extension of Kp
          Lp, phip, M := get_extension_data(extension_fields, p);
          A1, A2, B2, F := Explode(coerce_polynomials([A1, A2, B2, F], phip));
        else 
          M := RegularModel(C, p);
          if M`original_is_regular then 
            M := 0;
            Remove(~pot_irreg_primes, Index(pot_irreg_primes, p));
          end if;  
        end if;
      end if;       
      // Compute intersection.
      n := horizontal_intersection([A1, B1], [A2], F, M, C, phip, exp);
      vprintf JacHypHeight, 2: "Intersection multiplicity of D_P and D_mu at %o
                                                               is equal to %o \n", p, n;
      ints_list := add_entry(ints_list, <p, -Rationals() ! n * dQ /2, local_factor(Kp)>);
    end for; // T in fact_mu

    // Compute all (DD_lambda. DD_mu)_p
    vprintf JacHypHeight, 3: " possibly non-trivial intersection of D_lambda and D_mu at :
                                                                       %o\n", fact_mu_lambda;
    for T in fact_mu_lambda do
      p, exp := Explode(T);
      Kp, phip := my_completion(K, p, local_prec);
      A1, A2, F := Explode(coerce_polynomials([x - lambda, x - mu, f], phip));
      M := 0;
      if p in pot_irreg_primes and not must_have_regular_common_support(A1, A2, F) then	
        // Need to work on regular model.
        if IsDefined(extension_fields, p) then
          // Need to work over extension of Kp
          Lp, phip, M := get_extension_data(extension_fields, p);
          A1, A2, B2, F := Explode(coerce_polynomials([A1, A2, B2, F], phip));
        else 
          M := RegularModel(C, p);
          if M`original_is_regular then 
            M := 0;
            Remove(~pot_irreg_primes, Index(pot_irreg_primes, p));
          end if;  
        end if;  
      end if;       
      // Compute intersection.
      n := horizontal_intersection([A1], [A2], F, M, C, phip, exp);
      vprintf JacHypHeight, 2: "Intersection multiplicity of D_P and D_mu at %o
                                                                 is equal to %o \n", p, n; 
      ints_list := add_entry(ints_list, <p, Rationals() ! n * dP * dQ / 4, local_factor(Kp)>);
    end for; // T in fact_mu_lambda
    if bP then
      // Compute all (DD_P0. DD_Q)_p
      vprintf JacHypHeight, 3: " possibly non-trivial intersection of D_P0 and D_Q at : 
                                                                                %o\n", fact_P0;
      for T in fact_P0 do
        p, exp := Explode(T);
        Kp, phip := my_completion(K, p, local_prec);
        A1, A2, B1, B2, F := Explode(coerce_polynomials([x - P0[3], Q_inf[1], 
                                                  Parent(x) ! (P0[2]), Q_inf[2], f_inf], phip));
        M := 0;
        if p in pot_irreg_primes and not must_have_regular_common_support(A1, A2, F) then	
          // Need to work on regular model.
          if IsDefined(extension_fields, p) then
            // Need to work over extension of Kp
            Lp, phip, M := get_extension_data(extension_fields, p);
            A1, B1, A2, B2, F := Explode(coerce_polynomials([A1, B1, A2, B2, F], phip));
          else 
            M := RegularModel(C, p);
            if M`original_is_regular then 
              M := 0;
              Remove(~pot_irreg_primes, Index(pot_irreg_primes, p));
            end if;  
          end if;  
        end if;       
        // Compute intersection.
        n := horizontal_intersection([A1, B1], [A2, B2], F, M, C, phip, exp);
        vprintf JacHypHeight, 2: "Intersection multiplicity of D_P0 and D_Q at %o
                                                                 is equal to %o \n", p, n; 
        ints_list := add_entry(ints_list, <p, Rationals() ! n * nP, local_factor(Kp)>);
      end for; // T in fact_P0
    end if;
  end if;
  
  if bQ then
    // Compute all (DD_P. DD_Q0)_p
    vprintf JacHypHeight, 3: " possibly non-trivial intersection of D_P and D_Q0 at :
                                                                             %o\n", fact_Q0;
    for T in fact_Q0 do
      p, exp := Explode(T);
      Kp, phip := my_completion(K, p, local_prec);
      A1, A2, B1, B2, F := Explode(coerce_polynomials([x - Q0[3], P_inf[1], 
                                          Parent(x) ! (Q0[2]), P_inf[2], f_inf], phip));
      M := 0;
      if p in pot_irreg_primes and not must_have_regular_common_support(A1, A2, F) then	
        // Need to work on regular model.
        if IsDefined(extension_fields, p) then
          // Need to work over extension of Kp
          Lp, phip, M := get_extension_data(extension_fields, p);
          A1, A2, B2, F := Explode(coerce_polynomials([A1, A2, B2, F], phip));
        else 
          M := RegularModel(C, p);
          if M`original_is_regular then 
            M := 0;
            Remove(~pot_irreg_primes, Index(pot_irreg_primes, p));
          end if;  
        end if;  
      end if;       
      // Compute intersection.
      n := horizontal_intersection([A1, B1], [A2, B2], F, M, C, phip, exp);
      vprintf JacHypHeight, 2: "Intersection multiplicity of D_P and D_Q0 at %o
                                                                 is equal to %o \n", p, n; 
      ints_list := add_entry(ints_list, <p, Rationals() ! n * nQ, local_factor(Kp)>);
    end for; // T in fact_Q0
    if bP then
      // Compute all (DD_P0. DD_Q0)_p
      vprintf JacHypHeight, 3: " possibly non-trivial intersection of D_P0 and D_Q0 at :
                                                                           %o\n", fact_P0_Q0;
      for T in fact_P0_Q0 do
        p, exp := Explode(T);
        Kp, phip := my_completion(K, p, local_prec);
        A1, A2, B1, B2, F := Explode(coerce_polynomials([x - Q0[3], x - P0[3], 
                                    Parent(x) ! (Q0[2]), Parent(x) ! (P0[2]), f_inf], phip));
        M := 0;
        if p in pot_irreg_primes and not must_have_regular_common_support(A1, A2, F) then	
          // Need to work on regular model.
          if IsDefined(extension_fields, p) then
            // Need to work over extension of Kp
            Lp, phip, M := get_extension_data(extension_fields, p);
            A1, B1, A2, B2, F := Explode(coerce_polynomials([A1, B1, A2, B2, F], phip));
          else 
            M := RegularModel(C, p);
            if M`original_is_regular then 
              M := 0;
              Remove(~pot_irreg_primes, Index(pot_irreg_primes, p));
            end if;  
          end if;  
        end if;       
        // Compute intersection.
        n := horizontal_intersection([A1, B1], [A2, B2], F, M, C, phip, exp);
        vprintf JacHypHeight, 2: "Intersection multiplicity of D_P0 and D_Q0 at %o
                                                                   is equal to %o \n", p, n; 
        ints_list := add_entry(ints_list, <p, Rationals() ! n * nP * nQ, local_factor(Kp)>);
      end for; // T in fact_P0_Q0
    end if;
  end if;
  return ints_list;
 end function;	


// Given lists [a1, b1, d1] resp. [a2, b2, d2] representing points P and Q on the Jacobian 
// of a hyperelliptic curve, compute a multiple nP of P and a multiple mQ of Q such that
// the supports of the postive parts of the canonical representatives of nP and mQ
// have no point in common.
// We test the elements of P_list and Q_list, where
// P_list contains [P,2*P,3*P,4*P,...] and Q_list contains [Q,-Q,2*Q,-2*Q,3*Q,-3*Q,...].

function find_disjoint_multiple(P, Q);
  C := Curve(Parent(P));
  O := Zero(Parent(P));

  function is_bad(P, Q)
    return IsEven(Genus(C)) and IsEven(Degree(C)) and (Degree(P[1]) lt Genus(C) or
            Degree(Q[1]) lt Genus(C));
  end function;

  if are_disjoint([P, Q], 2, true) and not is_bad(P, Q) then
    return P, Q, -1;
  end if;
  P_list := [[P[1], P[2], P[3]]];	
  Q_list := [[Q[1], Q[2], Q[3]]];
  P0 := P;	
  Q0 := Q;
  factor := -1;
  while true do
    Q1 := [Q[1], -Q[2], Q[3]]; // Don't use -Q, because of odd genus, even degree problem.
    if Q1 in Q_list then return O, O, 0; else Append(~Q_list, Q1); end if;
    factor *:= -1;
    for i in [1..#P_list] do
      // Test whether Q1, P_list[i] works
      if are_disjoint([Q1, P_list[i]], 1, true) and not is_bad(Q1, P_list[i]) then
        return P_list[i], Q1, i * factor;	
      end if;
    end for;
    Q := Q + Q0;
    Q1 := [Q[1], Q[2], Q[3]];
    if Q1 in Q_list then return O, O, 0; else Append(~Q_list, Q1); end if;
    factor +:= 1;
    factor *:= -1;
    for i in [1..#P_list] do
      // Test whether Q1, P_list[i] works
      if are_disjoint([Q1, P_list[i]], 1, true) and not is_bad(P_list[i], Q1) then
        return P_list[i], Q1, i * factor;	
      end if;
    end for;
    P := P + P0;
    P1 := [P[1], P[2], P[3]];
    if P1 in P_list then return O, O, 0; else Append(~P_list, P1); end if;
    for j in [1..#Q_list] do
      // Test whether P1, O_list[i] works
      if are_disjoint([P1, Q_list[j]], 1, true) and not is_bad(P1, Q_list[j]) then
        return P1, Q_list[j], #P_list * Ceiling(j/2) * (-1) ^ j;	
      end if;
    end for;
  end while;	
end function;


// We compute the canonical height pairing of P and Q using the algorithm described in 
// Jan Steffen Mueller, "Computing canonical heights using arithmetic intersection theory"
// Math. Comp. 83 (2014), no. 285, 311-336.
// In large parts this is due  independently to David Holmes, see "Computing Néron-Tate heights 
// of points on hyperelliptic Jacobians", J. Number Theory 132 (2012), no. 6, 1295-1305
// The algorithm uses the theorem of Faltings and Hriljac which expresses the canonical height 
// pairing as a um of local Neron symbols, which in turn can be expressed using arithmetic 
// intersection theory.
// 
// Let D_P and D_Q denote the positive parts of the canonical representatives of the divisor
// classes given by P and Q, respectively and let d, e denote their respective degrees. 
// Let D_inf denote the line at infinity and D_lambda, D_mu the lines
// defined by x-lambda and x-mu, respectively. L
// If mu is zero, we compute the sum of all local Neron symbols
//            <D_P - d/2 *D_lambda, D_Q - e/2 *D_inf>_v
// and otherwise we compute the sum of all local Neron symbols
//            <D_P - d/2 *D_lambda, D_Q - e/2 *D_mu>_v
//
// For an archimedean prime v, we compute the local Neron symbol using theta functions on the 
// analytic Jacobian. This approach requires us to write one of our divisors as the difference 
// of two non-special divisors.


function height_pairing(P, Q, lambda, mu, prec, local_prec)

  original_P := P;
  original_Q := Q;
  C := Curve(Parent(P));

  // We only want models of the form y^2=f(x)
  C, phi := SimplifiedModel(C);
  P := Evaluate(phi, P);
  Q := Evaluate(phi, Q);
  J := Parent(P);
  K := BaseRing(C);
  if IsZero(P[2]) or IsZero(Q[2]) then // P or Q is a 2-torsion point.
    return ISA(Type(K), FldFunG) select 0 else RealField(prec) ! 0;
  end if;  

  // In the odd genus, even degree case we can only work with 2 rational pts at infinity.
  if IsDivisibleBy(Degree(HyperellipticPolynomials(C)), 4) then
    if not IsSquare(LeadingCoefficient(HyperellipticPolynomials(C))) then
      K := NumberField(Polynomial([-LeadingCoefficient(HyperellipticPolynomials(C)), 0, 1]));
      vprintf JacHypHeight, 2: "Need to extend the field to \n%o\n", K;
      JK := BaseChange(J, K);
      PK := JK ! P;
      QK := JK ! Q;
      return height_pairing(PK, QK, lambda, mu, prec + Degree(K), local_prec) / Degree(K);
    end if;
  end if;

  if ISA(Type(K), FldNum) and not IsAbsoluteField(K) then
    //only works for absolute extensions of Q
    K := AbsoluteField(K);
    J := BaseChange(J, K);
    P := J ! P;
    Q := J ! Q;
  end if;	

  // find_disjoint_multiple takes care of common support in divisors representing P and Q
  P, Q, factor := find_disjoint_multiple(P, Q);
  if IsZero(P) then 
    vprintf JacHypHeight, 1: "One of the points is torsion.";
    return ISA(Type(K), FldFunG) select 0 else RealField(prec) ! 0;
  end if;
  vprintf JacHypHeight, 1: "Use the points %o, %o\n", elt<J | [P[1], P[2]], P[3]>,
                                                               elt<J | [Q[1], Q[2]], Q[3]>; 
  factor *:= my_degree(K);
  Q := [Q[1], Q[2], Q[3]];
  point_list := [Q];

  if not ISA(Type(K), FldFunG) then
    // Now find representatives for archimedean intersections.
    // We need non-special divisors D_P1, D_P2 such that D_P1-D_P2 is linearly equivalent to 
    // n*D_P-D_lambda) for some n and both D_P1 and D_P2 have disjoint support with D_P, D_Q1 
    // and D_Q2, where D_Q1=D_Q and D_Q2=D_inf (resp. D_mu).
    // Let beta denote a function such that div(beta)=D_P1-D_P2-2*n*D_P+n*Degree(D_P)*D_lambda.
    // Then we compute the local Neron symbol at an archimedean place sigma as
    //     <D_P - D_lambda, D_Q1 - D_Q2>_sigma
    //  =  (D_P - D_lambda. D_Q1 - D_Q2)_sigma   (( . )_sigma is Arakelov intersection at sigma)
    //  =  1/n*(D_P1 - D_P2). D_Q1 - D_Q2)_sigma + 1/n * log | beta(D_Q1 - D_Q2) |_sigma  

    d := P[3];        
    e := Q[3];
    g := Genus(C);
    n := 1;
    P := elt<J | [P[1], P[2]], Integers() ! (P[3])>;
    P1 := P;
    msg:=false;
    repeat				
      if n gt 30 and not msg then msg:=true;
        "Can't represent a small multiple of the first point "*
        "as a difference of non-special divisors  that are relatively "*
        "prime to the canonical representative of the second point. "*
        "I'll keep  trying, but you should consider using the "*
        "parallelogram law to compute the desired canonical height "*
        "(pairing) indirectly.";
      end if;
      P1 +:= P;
      if IsZero(P1) then 
        // P is torsion
        return 0;
      end if;  
      n +:= 1;
    until Degree(P1[1]) eq g and Degree((-P1)[1]) eq g 
                            and are_disjoint([[P1[1], P1[2], P1[3]], Q], 1, false)
                            and are_disjoint([[(-P1)[1], (-P1)[2], (-P1)[3]], Q], 0, false);

    P2 := -P1; // We really need -P1 here so that in odd g, even deg the pts at infinity cancel.
    Q1 := Q;
    Q2 := [1, 0, 0];
    P1 := [P1[1], P1[2], P1[3]];
    P2 := [P2[1], P2[2], P2[3]];
    point_list cat:= [P1, P2];
  end if;
  P := [P[1], P[2], P[3]];
  point_list cat:= [P];
  bad := my_bad_primes(C);
  disc := Discriminant(C);
  // Find all primes such that a regular model computation will be necessary.
  pot_irreg_primes := [p : p in bad | Valuation(disc, p) gt 1];
  vprintf JacHypHeight, 1: "Primes of potentially irregular reduction %o\n", pot_irreg_primes; 


  // Find lambda such that the line given by x-lambda does not intersect any of the other 
  // relevant divisors.
  while &or[IsZero(Evaluate(PP[1], lambda)) : PP in point_list] do
    lambda +:= 1;
  end while;
   vprintf JacHypHeight, 1 : "lambda = %o\n", lambda;

  bP := contains_point_at_infinity(P);
  if bP then // Need to move the line at infinity, because it has common support with D_P.
    mu := Max(lambda + 1, mu);
    // Find mu such that the line given by x-mu does not have common support any of the other 
    // relevant divisors.
    while &or[IsZero(Evaluate(PP[1], mu)) : PP in point_list] do
      mu +:= 1;
    end while;
     vprintf JacHypHeight, 1 : "mu = %o\n", mu;
  else  
    mu := 0;
  end if; 
  ints_list := finite_intersection(P, Q, C, lambda, mu, pot_irreg_primes, 
                 local_prec + Ceiling(Log(Abs(factor))));
  RF := RealField(Ceiling(5/4*prec) + Ceiling(Log(Abs(2 * factor))));
  s0 := IsEmpty(ints_list) select Zero(RF) else 
                 &+[Log(RF ! Norm(t[1])) * RF ! (t[2]) * t[3] : t  in ints_list];
  vprintf JacHypHeight, 1 : "Finite part = %o\n", s0;

  if not ISA(Type(K), FldFunG) then
    // Find the canonical representatives of the points P1, P2, P.
    DP1 := mumford_to_effective_div(P1, C); 
    DP2 := mumford_to_effective_div(P2, C); 
    DP := mumford_to_effective_div(P, C);
    vprintf JacHypHeight, 3 : "Write D_P as the difference of the canonical representatives 
                of %o and %o\n", elt<J | [P1[1], P1[2]], P1[3]>, elt<J | [P2[1], P2[2]], P2[3]>; 
    bP := contains_point_at_infinity(P);
    FC<X, Y> := FunctionField(C);
    _, beta := IsPrincipal(DP1 - DP2 - 2 * n * DP + n * Degree(DP) * 
                                          Numerator(Divisor(C, X - lambda)));        
    
    si := Parent(s0) ! ArchimedeanNeronSymbol([P1, P2, Q1, Q2], C, beta, mu, 
                            Ceiling(5/4*prec) + Ceiling(Log(Abs(2 * factor * n))))/n;
    vprintf JacHypHeight, 3 : "Need to divide archimedean result by %o\n", n;
    vprintf JacHypHeight, 1 : "Infinite part = %o\n", si;
  end if;
  vprintf JacHypHeight, 1 : "Divide result by %o\n", factor;
  return 1 / factor * (s0 + si);
end function;


intrinsic LocalIntersectionData(P::JacHypPt, Q::JacHypPt : lambda := 0, mu := 1, 
                                                    LocalPrecision := 0) -> SeqEnum
{The non-archimedean local intersections used to compute the 
 canonical or p-adic height pairing of points P and Q on a hyperelliptic 
 Jacobian. The base field must be the rationals or a number field and the 
 positive parts of the canonical representatives of the points must 
 have disjoint support.}

  require IsIdentical(Parent(P), Parent(Q)):
          "The arguments must be points on the same Jacobian.";    
  J := Parent(P);
  C := Curve(J);
  f, h := HyperellipticPolynomials(C);
  F := BaseRing(J);
  t := Type(F);
  require Characteristic(F) ne 2:
          "The characteristic of the base ring of the Jacobian of argument 1 must not 
           have characteristic 2.";
  require ISA(t, FldRat) or ISA(t, FldNum):
           "The base ring of the Jacobian of argument 1 must be the rational field or a
             number field.";
  require not have_common_affine_support(P, Q):
           "The canonical representatives of the points must have disjoint support";
  require forall{c : c in Coefficients(4 * f + h ^ 2) | Denominator(c) eq 1}:
           "Defining polynomial of the curve must have integral coefficients.";
  local_prec := LocalPrecision eq 0 select 50 else LocalPrecision;
  bad := my_bad_primes(C);
  disc := Discriminant(C);
  // Find all primes such that a regular model computation will be necessary.
  pot_irreg_primes := [p : p in bad | Valuation(disc, p) gt 1];
  vprintf JacHypHeight, 1: "Primes of potentially irregular reduction %o\n", pot_irreg_primes; 

  ints_list := finite_intersection(P, Q, C, lambda, mu, pot_irreg_primes, local_prec); 	
  return ints_list;
end intrinsic;

intrinsic HeightPairing(P::JacHypPt, Q::JacHypPt : lambda := 0, mu := 1, Precision := 0, 
                                          LocalPrecision := 0, UseArakelov := false) -> FldReElt
{The canonical height pairing of points P and Q on a hyperelliptic Jacobian. 
This is defined as (h(P+Q) - h(P) - h(Q))/2, where h is the canonical height. 
The base field must be the rationals or a number field, or a rational function 
field in the genus 2 case}

  require IsIdentical(Parent(P), Parent(Q)):
          "The arguments must be points on the same Jacobian.";    
  J := Parent(P);
  F := BaseRing(J);
  t := Type(F);
  require Characteristic(F) ne 2:
          "The characteristic of the base ring of the Jacobian of argument 1 may not have 
           characteristic 2.";
  if Genus(Curve(J)) ne 2 then
    require ISA(t, FldRat) or ISA(t, FldNum):
           "The base ring of the Jacobian of argument 1 must be the rational field or a   
            number field.";
  else 
    require ISA(t, FldRat) or ISA(t, FldNum) or ISA(t, FldFunRat) and Rank(F) eq 1:
           "The base ring of the Jacobian of argument 1 must be the rational field, a 
            number field or a univariate rational function field.";
  end if;

  f, h := HyperellipticPolynomials(Curve(J));
  require forall{c : c in Coefficients(4 * f + h ^ 2) | Denominator(c) eq 1}:
           "Defining polynomial of the curve must have integral coefficients.";

  if not UseArakelov and Genus(Curve(J)) eq 2 and not ISA(t, FldNum) then
    C, phi := SimplifiedModel(Curve(J));
    P := Evaluate(phi, P);
    Q := Evaluate(phi, Q);
    K := KummerSurface(Parent(P));
    return (CanonicalHeight(K ! (P + Q) : Precision := Precision)
            - CanonicalHeight(K ! P : Precision := Precision)
            - CanonicalHeight(K ! Q : Precision := Precision)) / 2;
  end if;

  prec := Precision eq 0 select 30 else Precision; oprec:=prec;
  local_prec := LocalPrecision eq 0 select Maximum(50, prec + 10) else LocalPrecision;
  while true do b:=true; // local_prec,prec; // MW 27 Jul 2012
        try z:= height_pairing(P, Q, lambda, mu, prec, local_prec);
        catch e; local_prec:=Ceiling(local_prec*5/4);
                 prec:=Ceiling(prec*5/4); b:=false; end try;
        if b then return RealField(oprec)!z; end if; end while;
end intrinsic;


intrinsic CanonicalHeight(P::JacHypPt : lambda := 0, mu := 1, Precision := 0,
                               LocalPrecision := 0, UseArakelov := false) -> FldReElt
{The canonical height of the point P on the Jacobian of a hyperelliptic curve, 
which may be defined over the rationals, a number field or a univariate function field.}
  J := Parent(P);
  F := BaseRing(J);
  t := Type(F);
  require Characteristic(F) ne 2:
          "The characteristic of the base ring of the Jacobian of argument 1 must not 
           have characteristic 2.";
  if Genus(Curve(J)) ne 2 then
    require ISA(t, FldRat) or ISA(t, FldAlg): 
           "The base ring must be the rational field or a number field.";
  else 
    require ISA(t, FldRat) or ISA(t, FldAlg) or ISA(t, FldFunRat) and Rank(F) eq 1:
           "The base ring must be the rational field, a number field or a univariate 
            rational function field.";
  end if;

  f, h := HyperellipticPolynomials(Curve(J));
  require forall{c : c in Coefficients(4 * f + h ^ 2) | Denominator(c) eq 1}:
           "Defining polynomial of the curve must have integral coefficients.";

  if not UseArakelov and Genus(Curve(J)) eq 2 and not ISA(t, FldNum) then
    C, phi := SimplifiedModel(Curve(J));
    P := Evaluate(phi, P);
    return CanonicalHeight(KummerSurface(Parent(P)) ! P : Precision := Precision);
  end if;

  prec := Precision eq 0 select 30 else Precision; oprec:=prec;
  local_prec := LocalPrecision eq 0 select Maximum(50, prec + 10) else LocalPrecision;
  return height_pairing(P, P, lambda, mu, prec, local_prec);
end intrinsic;



intrinsic HeightPairingMatrix(S::[JacHypPt] : Precision := 0, UseArakelov := false) -> AlgMat
{Given a sequence of points P_i on a Jacobian of a hyperelliptic curve,
this returns the matrix (<P_i, P_j>), where < , > is the canonical height pairing}

  n := #S;
  hs1 := [ CanonicalHeight(P : Precision := Precision, UseArakelov) : P in S ];
  hs2 := [ [ (HeightPairing(S[i] , S[j] : Precision := Precision, UseArakelov)) : 
                                                        i in [1..j-1] ] : j in [2..n] ];
  mat := [ (i eq j) select hs1[i] else
           (i lt j) select hs2[j - 1, i] else hs2[i-1,j] : i, j in [1..n] ];
  return Matrix(n, mat);
end intrinsic;

intrinsic Regulator(S::[JacHypPt] : Precision := 0, UseArakelov := false) -> FldReElt
{The regulator of a sequence of points on the Jacobian of hyperelliptic curve 
i.e. the determinant of the height pairing matrix}

  J := Universe(S);
  F := BaseRing(J);
  t := Type(F);
  if Genus(Curve(J)) ne 2 then
    require ISA(t, FldRat) or ISA(t, FldAlg):
           "The base ring must be the rational field or a number field.";
  else 
    require ISA(t, FldRat) or ISA(t, FldAlg) or ISA(t, FldFunRat) and Rank(F) eq 1:
           "The base ring must be the rational field, a number field or 
            a univariate rational function field.";
  end if;
  return Determinant(HeightPairingMatrix(S : Precision := Precision, UseArakelov));
end intrinsic;

