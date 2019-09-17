freeze;

//
//	Finite Irreducible Unitary Reflection Groups
//
//	Don Taylor
//
//	Version 1: 14 April 1997
//	Version 2:  9 January 1998
//	Version 3: 22 January 1998
//	Version 4: 30 June 1998
//  Version 5:  6 January 1999
//	Version 6: 16 April 2000
//
// ====================================================
// Construction of all finite irreducible unitary reflection
// groups in C^n.  In addition to the symmetric groups
// W(A_n) = Sym(n+1), for n > 3, there are 34 primitive groups
// and an infinite family G(m,p,n) of imprimitive groups.
// ====================================================
// Intrinsics defined in this file:
//
// RootSystemMatrix
// ComplexReflectionGroupOld
// ShephardToddOld
// ImprimitiveReflectionGroupOld
//
// ====================================================
// History:
//  4 May 97  Added all groups in GL(3,C).
//  8 May 97  Added most of the groups in GL(2,C).
// 12 May 97  Added ST32, ST33, ST34.
// 19 May 97  Completed all subgroups of GL(2,C).
// 25 May 97  Changed matrices to more compact form.
// 14 Jun 97  Added all real reflection groups.
//            Added root system matrices for some complex groups.
// 15 Jun 97  Added support for types L and M.
// 17 Jun 97  Removed most 'ST' functions, leaving ShephardTodd.
// 23 Jun 97  Added all irreducible imprimitive reflection groups.
// 10 Dec 97  Fixed an error in the diagram of type J_3. Corrected
//		      some orthogonal group notation.
//  9 Jan 98  Changed all fields in the constructions to use the
//		      CyclotomicField() function.
// 22 Jan 98  Changed all degree 2 extensions to use QuadraticField()
//	          Added support for root system matrices corresponding
//	          to linearly dependent vectors.  Removed some dead code.
// 30 Jun 98  Corrected an error in the definitions of r5 and rr5
//	          in ShephardTodd().
// 28 Aug 98  Renamed O_5 to O_4.
//  6 Jan 99  Changed many function definitions to intrinsics
//            Changed error detection to use require* syntax
// 16 Apr 00  Fixed error in ImprimitiveReflectionGroup
//  9 Sep 10  All intrinsics in this file are deprecated
// ====================================================
// Future: Work over the integers of the various fields so
// that the groups can be mapped more easily to linear groups
// over finite fields.
// Add diagram support for the groups in dimension 2.
// ====================================================

// ----------------------------------------------------
intrinsic RootSystemMatrix ( t::MonStgElt, n::RngIntElt ) -> AlgMatElt 
{The matrix of (modified) inner products of unit root vectors
 vectors corresponding to a reflection group of type t and
 rank n}
// ----------------------------------------------------
// The (i,j)-th entry is delta_ij + (alpha_j - 1)(e_i,e_j) where
// e_1, e_2, ... are fundamental root vectors and alpha_j is an
// m-th root of unity, for some m.  By assumption, the e_i have
// length 1.
//
// The (i,i)-th entry is alpha_i and if this is -1, the node is
// shown as a circle, otherwise it is represented by alpha_i itself.
//
// This construction includes all finite irreducible Coxeter
// groups and all irreducible finite complex reflection groups
// of rank n which can be generated by n reflections.
// Cohen's notation is used for the complex reflection groups
// which are not Coxeter groups.
//
// The ordering of the fundamental root vectors is given in the
// following diagrams.  A pair of nodes not joined by an edge
// corresponds to a matrix entry of 0.  A single bond corresponds
// to 1 and all other bonds are labelled by the matrix entry
// (reading from left to right, from lower numbered node to higher).
//
// Thus an unlabelled edge between nodes of reflections of order 2
// corresponds to an inner product of -1/2.
//
// The j-th reflection is r_j, where
//
//            e_i o r_j = e_i + (alpha_j - 1)(e_i,e_j) e_j
//
// Thus the j-th column of the matrix representing r_j coincides
// with the j-th column of the root system matrix.  (Matrices act
// on the right.)
//
// The Gramians of the root diagrams marked with an asterisk ( * )
// are 0.  In this case, the function ReflectionGroup() defined below
// constructs the finite group, NOT the affine version.
//
//       1   2   3       n
// A_n   o---o---o- ... -o
//
//       1   2
// AA_n  o---o- ... -o---o               *   W(AA_n) = W(A_(n-1))
//       |               |
//       o---o- ... -o---o
//       n  n-1
//
//
// B_n
//       o===o---o- ... -o
// C_n   sqrt(2)
//
//
// BB_n  o===o---o- ... -o===o           *   W(BB_n) = W(B_(n-1))
//       sqrt(2)         sqrt(2)
//
//
//                         o n-1
//                        /
// CC_n  o===o---o- ... -o               *   W(CC_n) = W(C_(n-1))
//       sqrt(2)          \
//                         o n
//
//      1 o
//         \ 3  4       n
// D_n      o---o- ... -o
//         /
//      2 o
//
//      1 o                o n-1
//         \ 3  4         /
// DD_n      o---o- ... -o n-2           *   W(DD_n) = W(D_(n-1))
//         /              \
//      2 o                o n
//
//
//      2   3   4   5   6
// E_6  o---o---o---o---o
//              |
//            1 o
//
//
//      2   3   4   5   6   7
// E_7  o---o---o---o---o---o
//              |
//            1 o
//
//
//      2   3   4   5   6   7   8
// E_8  o---o---o---o---o---o---o
//              |
//            1 o
//
//
//       3   4   5   6   7
// EE_7  o---o---o---o---o
//               |
//             2 o                       *   W(EE_7) = W(E_6)
//               |
//             1 o
//
//
//        2   3   4   5   6   7   8
// EE_8   o---o---o---o---o---o---o      *   W(EE_8) = W(E_7)
//                    |
//                  1 o
//
//
//       2   3   4   5   6   7   8   9
// EE_9  o---o---o---o---o---o---o---o   *   W(EE_9) = W(E_8)
//               |
//             1 o
//
//
//      1   2   3   4
// F_4  o---o===o---o
//          sqrt(2)
//
//
//       1   2   3   4   5
// FF_5  o---o===o---o---o               *   W(FF_5) = W(F_4)
//           sqrt(2)
//
//
//      1   2
// G_2  o===o
//      sqrt(3)
//
//
//       1   2   3
// GG_2  o===o---o                       *
//       sqrt(3)
//
//
//      1   2   3
// H_3  o===o---o
//       tau           tau^2 = tau + 1
//
//
//      1   2   3   4
// H_4  o===o---o---o
//       tau
//
//
// Cohen's vector graphs (and more):
//
//            2
//            o
// J_3(4)    / \
//        1 o===o 3
//           -c           c^2 = c - 2
//
//
//            2
//            o
// J_3(5)    / \
//        1 o===o 3
//          w tau       w^2 + w + 1 = 0
//
//
//            3
//            o
// K_4       / \
//      o---o===o                        W(K_4) = G(3,3,4)
//      1   2 w 4
//
//
//            3
//            o
// K_5       / \
//      o---o===o---o
//      1   2 w 4   5
//
//
//            3
//            o
// K_6       / \
//      o---o===o---o---o
//      1   2 w 4   5   6
//
//
//            3
//            o
// K_7       / \
//      o---o===o---o---o---o            *   W(K_7) = W(K_6)
//      1   2 w 4   5   6   7
//
//
//      1     2     3
// L_3  w === w === w
//        -w^2  w^2
//
//          1
//           w
//       w^2 \\ 3    4
// LL_4        w === w                   *   W(LL_4) = W(L_3)
//       w^2 // w^2
//           w
//          2
//
//      1     2     3     4
// L_4  w === w === w === w
//       -w^2   w^2  -w^2
//
//
//      1     2     3     4     5
// L_5  w === w === w === w === w        *   W(L_5) = W(L_4)
//       -w^2   w^2  -w^2   w^2
//
//
//      1     2
// M_2  o === w
//      sqrt(2)
//
//
//      1     2     3
// M_3  o === w === w
//      sqrt(2) -w^2
//
//
//      1     2     3     4
// M_4  o === w === w === w              *   W(M_4) = W(M_3)
//      sqrt(2) -w^2  w^2
//
//
//          2
//          o
// N_4     / \ 3   4
//      1 o===o---o
//         i-1
//
//
//              3
// O_4  2 o --- o --- o 4                *   |W(O_4) : W(N_4)| = 6
//         \  // \\  /
//          \//i-1\\/
//           o === o
//         1   i+1   5
//
//
// Root diagrams for groups in U_2(C)
//
//
//      1     2
// L_2  w === w			G4
//        w^2
//
//
//	    1     2
//      w === w			G5
//
//
// ----------------------------------------------------
  An := function( n )  // the matrix for type A_n

    A := -Id(MatrixRing(IntegerRing(),n));
    for i in [1..n-1] do
      A[i][i+1] := 1;
      A[i+1][i] := 1;
    end for;
    return A;

  end function;

  case t:

  when "A", "a":
    requirege n, 1;
    rsMatrix := An( n );

  when "AA", "Aa", "aA", "aa":
    requirege n, 3;	// for type AA, the rank must be at least 3
    rsMatrix := An( n );
    rsMatrix[1][n] := 1;
    rsMatrix[n][1] := 1;

  when "B", "b", "C", "c":
    requirege n, 2;	// for type B or C, the rank must be at least 2
    K := QuadraticField( 2 ); a := K.1;
    rsMatrix := MatrixAlgebra(K,n)!An( n );
    rsMatrix[2][1] := a;
    rsMatrix[1][2] := a;

  when "BB", "Bb", "bB", "bb":
    requirege n, 3;	// for type BB, the rank must be at least 3
    K := QuadraticField( 2 ); a := K.1;
    rsMatrix := MatrixAlgebra(K,n)!An( n );
    rsMatrix[2][1] := a;
    rsMatrix[1][2] := a;
    rsMatrix[n-1][n] := a;
    rsMatrix[n][n-1] := a;

  when "CC", "Cc", "cC", "cc":
    requirege n, 4;	// for type CC, the rank must be at least 4
    K := QuadraticField( 2 ); a := K.1;
    rsMatrix := MatrixAlgebra(K,n)!An( n );
    rsMatrix[2][1] := a;
    rsMatrix[1][2] := a;
    rsMatrix[n][n-2] := 1;
    rsMatrix[n-2][n] := 1;
    rsMatrix[n][n-1] := 0;
    rsMatrix[n-1][n] := 0;

  when "D", "d":
    requirege n, 3;	// for type D, the rank must be at least 3
    rsMatrix := An( n );
    rsMatrix[1][3] := 1;
    rsMatrix[3][1] := 1;
    rsMatrix[1][2] := 0;
    rsMatrix[2][1] := 0;

  when "DD", "Dd", "dD", "dd":
    requirege n, 5;	// for type DD, the rank must be at least 5
    rsMatrix := An( n );
    rsMatrix[1][3] := 1;
    rsMatrix[3][1] := 1;
    rsMatrix[1][2] := 0;
    rsMatrix[2][1] := 0;
    rsMatrix[n][n-2] := 1;
    rsMatrix[n-2][n] := 1;
    rsMatrix[n][n-1] := 0;
    rsMatrix[n-1][n] := 0;

  when "E", "e":
    requirerange n, 6, 8;	// for type E, the rank must be 6, 7 or 8
    rsMatrix := An( n );
    rsMatrix[1][2] := 0;
    rsMatrix[2][1] := 0;
    rsMatrix[1][4] := 1;
    rsMatrix[4][1] := 1;

  when "EE", "Ee", "eE", "ee":
    requirerange n, 7, 9;	// for type EE, the rank must be 7, 8 or 9
    rsMatrix := An( n );
    if n eq 7 then 
      rsMatrix[2][3] := 0;
      rsMatrix[3][2] := 0;
      rsMatrix[2][5] := 1;
      rsMatrix[5][2] := 1;
    elif n eq 8 then
      rsMatrix[1][2] := 0;
      rsMatrix[2][1] := 0;
      rsMatrix[1][5] := 1;
      rsMatrix[5][1] := 1;
    else
      rsMatrix[1][2] := 0;
      rsMatrix[2][1] := 0;
      rsMatrix[1][4] := 1;
      rsMatrix[4][1] := 1;
    end if;
    
  when "F", "f":
    require n eq 4: "for type F, the rank must be 4";
    K := QuadraticField( 2 ); a := K.1;
    rsMatrix := MatrixAlgebra(K,4)!An( 4 );
    rsMatrix[2][3] := a;
    rsMatrix[3][2] := a;

  when "FF", "fF", "Ff", "ff":
    require n eq 5: "for type FF, the rank must be 5";
    K := QuadraticField( 2 ); a := K.1;
    rsMatrix := MatrixAlgebra(K,5)!An( 5 );
    rsMatrix[2][3] := a;
    rsMatrix[3][2] := a;

  when "G", "g":
    require n eq 2: "for type G, the rank must be 2";
    K := QuadraticField( 3 ); b := K.1;
    rsMatrix := MatrixAlgebra(K,2)!An( 2 );
    rsMatrix[1][2] := b;
    rsMatrix[2][1] := b;

  when "GG", "gG",  "Gg", "gg":
    require n eq 3: "for type GG, the rank must be 3";
    K := QuadraticField( 3 ); b := K.1;
    rsMatrix := MatrixAlgebra(K,3)!An( 3 );
    rsMatrix[1][2] := b;
    rsMatrix[2][1] := b;

  when "H", "h":
    requirerange n, 3, 4; 	// for type H, the rank must be 3 or 4
    K := QuadraticField( 5 ); z := K.1;
    tau := (1+z)/2;
    rsMatrix := MatrixAlgebra(K,n)!An( n );
    rsMatrix[1][2] := tau;
    rsMatrix[2][1] := tau;

  when "J4", "j4":
    require n eq 3: "for type J4, the rank must be 3";
    K := QuadraticField( -7 ); z := K.1;
    c := (1+z)/2;
    rsMatrix := MatrixAlgebra(K,3)!
      [ -1,  1, -c,
         1, -1,  1,
       -1+c, 1, -1];

  when "J5", "j5":
    require n eq 3: "for type J5, the rank must be 3";
    K := CyclotomicField( 15 ); z := K.1;
    w    := z^5;
    tau  := 1 + z^3 + z^12;
    rsMatrix := MatrixAlgebra(K,3)!
      [ -1,    1, w*tau,
         1,   -1,   1,
      w^2*tau, 1,  -1];

  when "K", "k":
    requirerange n, 4, 7;	// for type K, the rank must be 4, 5, 6 or 7
    K := QuadraticField( -3 ); z := K.1;
    w := (-1+z)/2;
    rsMatrix := MatrixAlgebra(K,n)!An( n );
    rsMatrix[2,4] := w;
    rsMatrix[4,2] := w^2;

  when "L", "l":
    requirerange n, 2, 5;	// for type L, the rank must be 2, 3, 4 or 5
    K := QuadraticField( -3 ); z := K.1;
    w := (-1+z)/2;
    if n eq 2 then
      rsMatrix := MatrixAlgebra(K,2)!
        [ w, w^2,
        -w^2,  w];
    elif n eq 3 then
      rsMatrix := MatrixAlgebra(K,3)!
        [ w, -w^2,  0,
         w^2,  w,  w^2,
          0, -w^2,  w];
    elif n eq 4 then
      rsMatrix := MatrixAlgebra(K,4)!
        [ w, -w^2,  0,   0,
         w^2,  w,  w^2,  0,
          0, -w^2,  w,  -w^2,
	  0,   0,  w^2,  w];
    else
      rsMatrix := MatrixAlgebra(K,5)!
        [ w, -w^2,  0,   0,   0,
         w^2,  w,  w^2,  0,   0,
          0, -w^2,  w,  -w^2, 0,
	  0,   0,  w^2,  w,  w^2,
          0,   0,   0,  -w^2, w];
    end if;

  when "LL", "lL", "Ll", "ll":
    require n eq 4: "for type LL, the rank must be 4";
    K := QuadraticField( -3 ); z := K.1;
    w := (-1+z)/2;
    rsMatrix := MatrixAlgebra(K,4)!
      [ w,    0,   w^2,   0,
        0,    w,   w^2,   0,
      -w^2, -w^2,   w,   w^2,
        0,    0,  -w^2,   w];

  when "M", "m":
    requirerange n, 2, 4;	// for type M, the rank must be 2, 3 or 4
    K := CyclotomicField( 24 ); z := K.1;
    w := z^8;
    a := z^3 + z^21;
    if n eq 2 then
      rsMatrix := MatrixAlgebra(K,2)!
        [ -1,    a,
        (1-w)/a, w];
    elif n eq 3 then
      rsMatrix := MatrixAlgebra(K,3)!
        [ -1,    a,   0,
        (1-w)/a, w,  -w^2,
           0,   w^2,  w];
    else
      rsMatrix := MatrixAlgebra(K,4)!
        [ -1,    a,   0,   0,
        (1-w)/a, w,  -w^2, 0,
           0,   w^2,  w,  w^2,
           0,    0,  -w^2, w];
    end if;

  when "N", "n":
    require n eq 4: "for type N, the rank must be 4";
    K := QuadraticField( -1 ); i := K.1;
    rsMatrix := MatrixAlgebra(K,4)!
      [-1,  1, i-1, 0,
        1, -1,  1,  0,
      -i-1, 1, -1,  1,
        0,  0,  1, -1];

  when "O", "o":
    require n eq 4: "for type O, the rank must be 4";
    K := QuadraticField( -1 ); i := K.1;
    rsMatrix := MatrixAlgebra(K,5)!
      [-1,  1, i-1, 0, i+1,
        1, -1,  1,  0,  0,
      -i-1, 1, -1,  1, i-1,
	    0,  0,  1, -1,  1,
      -i+1, 0,-i-1, 1, -1];

  else
    error
    "the type must be one of A, AA, B, BB, C, CC, D, DD,\n\
     E, EE, F, FF, G, GG, H, J4, J5, K, L, LL, M, N, O";

  end case;

  return rsMatrix;

end intrinsic;

// ----------------------------------------------------
intrinsic ComplexReflectionGroupOld( M::AlgMatElt ) -> GrpMat, Fld
{The (complex) reflection group for the root system matrix M.
The field of definition is returned as well}
// ----------------------------------------------------
// We assume that `M` corresponds to a positive semidefinite
// inner product and that the first n-1 columns of M - Id
// are linearly independent.
//
// The fundamental reflections are created as matrices
// with respect to the standard basis of the reflection
// representation.  The matrices represent the action
// on row vectors.
//
// The k-th reflection matrix is obtained from the identity 
// matrix by replacing its k-th column with the k-th column
// of the root system matrix.
// 
// If the determinant of `M - Id` is 0, the matrices can be
// thought of as arising from transformations constructed as
// just described, but acting on the quotient of the space
// modulo the null space of `M - Id`.


  A := Parent( M );
  n := Degree( A );
  K := CoefficientRing(A);
  if Determinant ( M - A!1 ) eq 0 then 
    m := n - 1;
  else
    m := n;
  end if;
  A := MatrixAlgebra(K,m);
  rho := [];
  for k in [1..m] do
    r := Id(A);
    for i in [1..m] do		// only column `k` needs changing
      r[i,k] := M[i,k];
    end for;
    rho[k] := r;
  end for;
  if m lt n then
    N := NullSpace(M - Parent(M)!1);
    v := N.1;
    error if v[n] eq 0, "improper root system matrix";

// Sometimes the coefficient ring will not be a field, and so
// we have to be careful only to feed in root system matrices
// which have nice null spaces.

    if v[n] ne -1 then
      if v[n] ne 1 then
        v := v/v[n];
      end if;
      v := -v;
    end if;

    r := Id(A);
    for i in [1..m] do
    for j in [1..m] do
      r[i,j] +:= M[i,n]*v[j];
    end for;
    end for;
    rho[n] := r;
  end if;

  return sub< GL(m,K) | rho >, K;

end intrinsic;


intrinsic ComplexReflectionGroupOld( X::MonStgElt, n::RngIntElt ) -> GrpMat, Fld
{The complex reflection group of type X_n}
  return ComplexReflectionGroupOld( RootSystemMatrix( X, n ) );
end intrinsic;

/* 
This function depends on the way Magma constructs representatives 
of conjugacy classes and therefore it is not guarranteed to survive
version changes.

// Return representatives for the generators of the conjugacy classes
// of cyclic subgroups generated by reflections.
// ----------------------------------------------------
Reflections := function( grp )
// ----------------------------------------------------
  g1 := grp.1;
  M := MatrixRing(K,n) where K is Parent(g1[1,1]) where n is Degree(g1);
  CC := ConjugacyClasses( grp: Al := "Action" );
  C := [CC[i,3] : i in [2..#CC]];
  RR := [];

// This assumes that for b in CC, the conjugates of b^j are
// represented by b^j itself.

  while #C gt 0 do
    b := C[1];
    n := Order(b);
    for j in [1..n-1] do
      if (GCD(j,n) eq 1) then
        Exclude(~C,b^j);
      end if;
    end for;
    if Rank(M!b-M!1) eq 1 then
      Append(~RR,b);
    end if;
  end while;

  return RR;

end function;
*/

// ====================================================
// There are nineteen 2-dimensional primitive unitary
// reflection groups.
//
// Tetrahedral family: ST4, ..., ST7
// Octahedral family:  ST8, ..., ST15
// Icosahedral family: ST16, ..., ST22
// ====================================================
// There are five 3-dimensional unitary reflection groups:
//
// ST23: W(H_3) = Z_2 x PSL(2,5), order 120
// ST24: W(J_3(4)) = Z_2 x PSL(2,7), order 336
// ST25: W(L_3) = W(P_3) = 3^{1+2}.SL(2,3), order 648; Hessian group
// ST26: W(M_3) = Z_2 x 3^{1+2}.SL(2,3), order 1296; Hessian group
// ST27: W(J_3(5)) = Z_2 x (Z_3 . A_6), order 2160
// ====================================================
// There are five 4-dimensional unitary reflection groups in addition to Sym(5):
//
// ST28: W(F_4) = (SL(2,3) o SL(2,3)).(Z_2 x Z_2), order 1152
// ST29: W(N_4) = (Z_4 o 2^{1+4}).S_5, order 7680 (splits)
// ST30: W(H_4) = (SL(2,5) o SL(2,5))Z_2, order 14400
// ST31: W(O_4) = (Z_4 o 2^{1+4})Sp(4,2), order 46080 (non-split) 5 generators
// ST32: W(L_4) = Z_3 x Sp(4,3), order 155520 = 2^7 x 3^5 x 5
//
//   O_2(W(O_4)) is the normal closure of ($.1*$.3)^2.
//   The extra root is e_1 - e_3
// ====================================================
// There is one 5-dimensional unitary reflection group in addition to Sym(6).
//
// ST33: W(K_5) = Z_2 x Omega(5,3) = Z_2 x PSp(4,3) = Z_2 x PSU(4,2),
//                order 51840 = 2^7 x 3^4 x 5
// ====================================================
// There are two 6-dimensional unitary reflection groups in addition to Sym(7):
//
// ST34: W(K_6) = Z_3 . SO-(6,3), order 39191040 = 2^9 x 3^7 x 5 x 7
// ST35: W(E_6) = SO(5,3) = O^-(6,2) = PSp(4,3)Z_2 = PSU(4,2)Z_2, 
//		  order 51840 = 2^7 x 3^4 x 5
// ====================================================
// There is one 7-dimensional unitary reflection group in addition to Sym(8)
//
// ST36: W(E_7) = Z_2 x Sp(6,2), order 2903040 = 2^10 x 3^4 x 5 x 7
// ====================================================
// There is one 8-dimensional unitary reflection group in addition to Sym(9)
//
// ST37: W(E_8) = Z_2 . O+(8,2), order 696729600 = 2^14 x 3^5 x 5^2 x 7

// ====================================================
intrinsic ShephardToddOld ( n::RngIntElt ) -> GrpMat, Fld
{Return the primitive reflection group G_n in GL(m, C), using the Shephard-Todd
numbering.  The field of definition is also returned.}
// ----------------------------------------------------
  requirerange n, 4, 37;
// m = 2
  if 4 le n and n le 22 then
    if n le 7 then
      K := CyclotomicField( 12 ); z := K.1;
      i := z^3;
      w := z^4;
    elif n eq 12 then
      K := CyclotomicField( 8 ); z := K.1;
      i := z^2;
      a := z + z^7;
    elif n le 15 then
      K := CyclotomicField( 24 ); z := K.1;
      i := z^6;
      a := z^3 + z^21;
      w := z^8;
    else
      K := CyclotomicField( 60 ); z := K.1;
      i := z^15;
      w := z^20;
      tau := 1 + z^12 + z^48;			// tau^2 = tau + 1
    end if;
    G := GL(2,K);
  end if;
  if n in {6,7,13,15,17,19,21,22} then
    r := G![1,0,0,-1];					// order 2
  end if;
  if n in {4,5,6,7,10,11,14,15,18,19,20} then
    r1 := G![w*g/2 : g in [i-1,i-1,i+1,-(i+1)]];	// order 3
  end if;
  if n in {20,21} then
    rrr1 := G![w*g/2 : g in [tau*i-1,(tau-1)*i,(tau-1)*i,-(tau*i+1)]];
							// r5*r1*r5^-1
  end if;
  if n in {9,11,12,13,15} then
    r3 := G![g/a : g in [-1,1,1,1]];			// order 2
  end if;
  if n in {12,14} then
    rr3 := G![g/a : g in [-1,-1,-1,1]];			// r*r3*r
  end if;
  if n in {12,13} then
    rrr3 := G![g/a : g in [0,-(i+1),i-1,0]];		// (r1*r4)^-1*r3*(r1*r4)
  end if;
  if n in {8,9,10,11} then
    r4 := G![1,0,0,i];					// order 4
  end if;
  if n in {16,17,18,19} then
    r5 := G![-z^24*g/2 : g in [tau-i, tau-1, -(tau-1), tau+i]];	// order 5
  end if;

  if   n eq  4 then
    rr1 := G![w*g/2 : g in [i-1,-(i-1),-(i+1),-(i+1)]];	// order 3
    return sub<G | r1, rr1 >,K;
  elif n eq  5 then
    rr2 := G![w*g/2 : g in [-i-1,i-1,i+1,i-1]];		// r*r2*r
    return sub<G | r1, rr2 >,K;
  elif n eq  6 then
    return sub<G | r, r1 >,K;
  elif n eq  7 then
    r2 := G![w*g/2 : g in [-i-1,-i+1,-i-1,i-1]]; 	// order 3 w^2*r1^2
    return sub<G | r, r1, r2 >,K;
  elif n eq  8 then
    rr4 := G![g/2 : g in [i+1,i-1,i-1,i+1]];		// r3^-1*r4*r3
    return sub<G | r4, rr4 >,K;
  elif n eq  9 then
    return sub<G | r3, r4 >,K;
  elif n eq 10 then
    return sub<G | r1, r4 >,K;
  elif n eq 11 then
    return sub<G | r1, r3, r4 >,K;
  elif n eq 12 then
    return sub<G | r3, rr3, rrr3 >,K;
  elif n eq 13 then
    return sub<G | r, r3, rrr3 >,K;
  elif n eq 14 then
    return sub<G | r1, rr3 >,K;
  elif n eq 15 then
    return sub<G | r, r1, r3 >,K;
  elif n eq 16 then
    rr5 := G![-z^24*g/2 : g in [tau-i, -(tau-1), tau-1, tau+i]];	// order 5
    return sub<G | r5, rr5 >,K;
  elif n eq 17 then
    return sub<G | r, r5 >,K;
  elif n eq 18 then
    return sub<G | r1, r5 >,K;
  elif n eq 19 then
    return sub<G | r, r1, r5 >,K;
  elif n eq 20 then
    return sub<G | r1, rrr1 >,K;
  elif n eq 21 then
    return sub<G | r, rrr1 >,K;
  elif n eq 22 then
    rr  := G![0,1,1,0];						// r1^-1*r*r1
    rrr := G![g/2 : g in [tau,(tau-1)*i-1,-(tau-1)*i-1,-tau]];	// r5^-1*r*r5
    return sub<G | r, rr, rrr >,K;
// m = 3
  elif n eq 23 then  return ComplexReflectionGroupOld(RootSystemMatrix( "H", 3 ));
  elif n eq 24 then  return ComplexReflectionGroupOld(RootSystemMatrix( "J4", 3 ));
  elif n eq 25 then  return ComplexReflectionGroupOld(RootSystemMatrix( "L", 3 ));
  elif n eq 26 then  return ComplexReflectionGroupOld(RootSystemMatrix( "M", 3 ));
  elif n eq 27 then  return ComplexReflectionGroupOld(RootSystemMatrix( "J5", 3 ));
// m = 4
  elif n eq 28 then  return ComplexReflectionGroupOld(RootSystemMatrix( "F", 4 ));
  elif n eq 29 then  return ComplexReflectionGroupOld(RootSystemMatrix( "N", 4 ));
  elif n eq 30 then  return ComplexReflectionGroupOld(RootSystemMatrix( "H", 4 ));
  elif n eq 31 then  return ComplexReflectionGroupOld(RootSystemMatrix( "O", 4 ));
  elif n eq 32 then  return ComplexReflectionGroupOld(RootSystemMatrix( "L", 4 ));
// m = 5
  elif n eq 33 then  return ComplexReflectionGroupOld(RootSystemMatrix( "K", 5 ));
// m = 6OldComplex
  elif n eq 34 then  return ComplexReflectionGroupOld(RootSystemMatrix( "K", 6 ));
  elif n eq 35 then  return ComplexReflectionGroupOld(RootSystemMatrix( "E", 6 ));
// m = 7
  elif n eq 36 then  return ComplexReflectionGroupOld(RootSystemMatrix( "E", 7 ));
// m = 8
  elif n eq 37 then  return ComplexReflectionGroupOld(RootSystemMatrix( "E", 8 ));
  else
    error "ShephardTodd: out of range";  // this should never happen
  end if;

end intrinsic;


// ----------------------------------------------------
intrinsic ImprimitiveReflectionGroupOld( m::RngIntElt, p::RngIntElt, n::RngIntElt) 
  -> GrpMat, Fld
{The Shephard-Todd group G(m,p,n). The field of definition is returned as well}
// ----------------------------------------------------
// If m = p = 1, this function returns Sym(n) in its natural
// permutation representation - it is not irreducible.
  require m mod p eq 0: "second argument must divide first argument";
  if m gt 2 then
    K := CyclotomicField(m); z := K.1;
  else
    K := RationalField();
    z := -1;
  end if;
  M := MatrixRing(K,n);
  R := [];
  for i in [1..n-1] do
    r := Id(M);
    r[i,i]     := 0;
    r[i+1,i+1] := 0;
    r[i,i+1]   := 1;
    r[i+1,i]   := 1;
    R[i] := r;
  end for;
  if m gt 1 then
    t := Id(M);
    t[1,1] := z;
    if p gt 1 then 
      R[n] := t*R[1]*t^-1;
      if p lt m then
        R[n+1] := t^p;
      end if;
    else
      R[n] := t;
    end if;
  end if;
  return sub< GL(n,K) | R >,K;

end intrinsic;


