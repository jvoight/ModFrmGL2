/*
# Character: X11
# Comment: only fairly nasty
# Ind: 1
# Ring: Z
# Sparsity: 61%
# Maximum absolute entry: 29
# Checker result: pass
# Conjugacy class representative result: pass

local a, A, b, B, c, C, w, W, i, result, delta, idmat;

result := rec();
*/

E := RootOfUnity;

w := E(3); W := E(3)^2;
a := E(5)+E(5)^4; A := -1-a; //# b5, b5*
b := E(7)+E(7)^2+E(7)^4; B := -1-b; // # b7, b7**
c := E(11)+E(11)^3+E(11)^4+E(11)^5+E(11)^9; C := -1-c; //# b11, b11**
i := E(4);
//result.comment := "Sz8 as 91 x 91 matrices\n";

result := MatrixGroup<91, Integers() | 
Matrix(Integers(), [[1,-4,4,-1,-1,-5,-2,0,2,-2,4,5,-4,-3,4,3,1,-1,1,0,1,-2,1,-3,2,3,2,
  2,3,2,2,-5,4,-1,7,1,-1,-1,-2,-2,1,-1,4,-2,1,-3,2,2,-3,-1,4,0,2,0,
  4,2,-2,-2,-4,-1,-2,2,0,-2,1,-2,0,0,-3,3,-2,-5,1,0,-2,0,-2,0,0,-1,
  -2,-1,-2,-1,-2,3,1,-1,-1,0,-2],
[0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[8,3,2,1,-1,1,2,-3,-4,-1,-1,-2,-2,2,-4,-4,1,-4,2,-4,1,2,2,1,0,-3,0,
  -4,1,1,-6,4,-4,-1,-5,-4,1,-5,-3,2,-3,2,-4,-1,0,3,-5,4,5,0,-1,-2,
  3,2,0,3,4,-2,2,-5,0,3,-6,4,4,1,3,-2,1,-5,1,3,1,1,-1,-4,2,-4,3,1,
  1,1,-1,1,1,1,-2,-1,-1,-1,2],
[0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[2,2,1,1,0,2,0,1,2,0,-2,-2,0,1,-2,-2,-1,0,-1,-2,0,1,-1,1,0,-2,1,-2,
  0,0,-2,2,-1,-1,-3,-1,0,0,-1,1,-1,0,-1,0,0,0,-2,1,2,0,-1,0,0,0,1,
  0,1,0,1,1,-1,-1,-1,0,1,-1,1,-1,1,-2,1,3,-2,-1,0,-1,1,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0],
[8,4,2,4,1,3,-1,0,-5,0,-4,-8,-2,2,-5,-1,0,-6,-1,-4,3,5,5,8,3,0,0,-1,
  5,1,-5,4,-2,-4,-6,-1,-2,-4,-5,6,-2,3,-3,-1,0,3,-9,4,4,0,-4,1,-1,
  0,0,1,1,-1,5,-5,1,3,-6,0,2,0,4,-6,1,-7,1,5,-2,1,1,-5,4,-3,2,0,4,
  2,-1,1,1,-1,-2,-3,-2,1,1],
[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[10,6,3,1,2,2,-1,-2,-4,-1,-6,-7,-2,1,-7,0,2,-4,0,-7,5,5,3,8,3,0,1,
  0,5,1,-4,4,-2,-4,-6,-2,-3,-5,-5,6,-5,3,0,-1,0,1,-8,5,5,0,-4,2,-1,
  0,3,2,3,-2,5,-4,-1,2,-6,-1,3,-1,6,-6,1,-7,-1,4,-4,0,1,-5,3,-3,2,
  -2,3,1,-1,1,1,-2,-1,-4,-3,1,1],
[-2,-1,-2,0,-2,-1,2,-2,0,0,0,2,2,-1,1,1,0,1,2,4,-1,-4,-1,-4,-2,1,-3,
  0,-3,0,2,-1,1,1,4,-1,2,0,0,-1,0,1,0,1,-1,2,3,1,1,0,-1,-3,0,0,0,3,
  0,2,-2,3,0,1,1,1,-2,2,-2,3,0,0,-1,-2,3,0,-2,1,-1,1,-1,1,-2,1,1,1,
  1,0,1,1,1,0,0],
[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[-1,-1,0,-1,-1,-1,2,-2,0,-1,1,1,-1,0,1,-2,0,0,-1,0,1,0,0,-1,-3,-1,
  0,-1,-1,0,-1,0,-2,0,0,1,0,1,0,-2,0,1,0,0,2,0,0,0,-1,0,1,-1,2,1,0,
  0,2,-1,-2,0,0,-1,0,1,0,0,0,2,0,1,0,0,1,1,0,0,-1,0,0,-1,0,0,0,-1,
  0,0,1,1,1,-1,0],
[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[1,1,-1,3,0,5,1,0,-3,2,2,-6,1,5,-2,-5,-3,-1,-2,1,-1,2,2,2,0,-2,0,-4,
  -4,-2,-2,5,-3,0,-6,-1,2,-1,0,2,3,0,-5,1,0,1,-3,-1,3,1,-3,1,0,-2,
  -4,-4,1,0,4,-2,5,-1,-2,4,1,1,0,-1,1,-2,3,5,0,2,2,0,2,-3,1,3,2,1,
  2,-1,1,-2,0,1,1,0,1],
[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[-1,2,-1,-3,1,-2,1,3,8,1,-7,2,0,-3,0,3,3,3,-2,-2,1,1,-7,1,2,0,0,3,
  1,-3,3,0,-1,-2,-1,2,1,3,2,1,1,-1,1,3,0,-2,2,-3,-1,2,3,3,-3,2,2,-1,
  0,0,-4,4,-4,-1,5,-3,-2,-2,3,1,3,1,-1,0,-3,-3,-1,1,0,3,-1,-2,0,-2,
  -4,0,-1,-2,0,1,0,1,-2],
[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[-2,1,-2,0,-1,0,3,-1,5,0,-6,2,3,0,0,0,1,4,2,3,0,-3,-7,-3,-3,-3,-4,
  2,-2,-2,1,0,2,1,0,-1,2,2,3,0,-1,-1,2,2,0,-1,4,1,1,2,-2,-1,-2,1,2,
  2,1,4,-1,7,-5,-3,3,-3,-4,0,0,5,3,-1,0,-1,0,-3,-1,2,1,3,-2,-1,-2,
  0,0,2,-1,0,3,2,0,-2,0],
[-5,-6,2,-2,-1,-2,-3,-4,1,-2,7,4,-1,-1,7,0,-3,4,0,5,2,-4,0,-5,-3,1,
  0,2,-2,2,3,-5,6,2,9,2,-3,2,2,-6,1,-2,7,-3,2,-5,5,1,-3,-3,0,-1,3,
  -3,2,0,-1,1,-2,1,0,-4,1,-3,-1,-1,-2,4,-5,6,-2,-6,1,2,1,4,-4,2,-2,
  -2,-3,-1,4,-2,-2,2,5,1,0,-1,0],
[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[-4,-1,-2,-3,0,-1,1,-1,-1,-1,2,2,0,-2,2,-3,0,5,-2,4,0,-2,-1,-4,-1,
  -1,-2,0,-5,-1,1,1,-2,5,-1,1,1,1,1,-6,1,1,0,1,0,1,3,-5,-1,-2,2,-3,
  2,0,-4,-2,1,-1,-3,-2,3,-1,3,4,2,3,-1,2,-1,3,0,-1,2,2,-1,4,-3,1,1,
  0,0,0,1,-2,1,0,0,2,2,1,1],
[2,1,3,-1,3,-2,-2,4,1,-2,-3,1,-4,-2,0,3,3,-2,0,-4,2,3,1,3,2,2,3,2,
  7,0,-2,-3,2,-1,0,0,-2,0,-1,1,-2,-1,1,-3,1,-1,-4,1,-3,-1,4,4,-1,1,
  2,2,-2,-2,0,-3,-3,3,-1,-4,1,-2,1,-4,0,0,-1,-1,-3,-2,0,-2,0,0,1,-2,
  2,0,-3,2,-1,2,-2,-2,-1,2,-1],
[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[-11,-2,-7,-1,0,2,3,1,4,4,0,3,6,1,3,-2,-1,8,-1,8,-4,-4,-6,-6,-4,-2,
  -4,1,-9,-4,5,-1,-1,5,1,2,3,6,8,-2,4,-2,-1,4,0,0,8,-7,-1,2,0,-1,-2,
  0,-5,-4,0,5,-2,7,1,-5,8,2,-5,2,-4,7,2,5,1,-1,2,0,1,6,-2,4,-2,2,-2,
  -1,2,0,0,-2,2,6,3,-1,0],
[-3,1,-1,-3,0,-1,0,1,1,-2,-2,1,-1,-3,0,-1,1,3,-2,0,-1,0,-4,-1,0,-2,
  -1,1,-1,-1,-1,2,-2,3,-3,2,1,1,1,-5,0,1,0,2,0,0,1,-5,-2,-1,3,-2,0,
  1,-3,-2,-1,-2,-3,-2,2,-1,3,2,2,1,1,1,0,2,1,0,0,0,-1,2,-1,1,0,-1,
  1,0,-1,-2,1,0,-1,1,1,1,1],
[3,3,4,-1,3,3,-3,3,4,0,-3,-4,-3,0,-2,-2,-1,0,-6,-3,3,6,-2,6,3,-2,3,
  -2,2,-1,-4,4,-2,-3,-6,0,-2,0,0,2,1,-1,-2,-1,1,-1,-7,-1,2,-2,4,4,
  0,1,-1,-2,0,-2,1,-3,0,-1,-1,1,3,-3,6,-4,1,-1,1,5,-6,0,1,-2,1,-1,
  1,-1,3,-2,-2,-1,-1,-1,-1,1,0,3,1],
[2,-1,4,-4,-1,-2,-1,0,3,-4,-1,3,-2,-2,1,-1,1,3,-1,0,1,-1,-6,-2,1,-3,
  -1,0,0,0,-2,3,1,3,-2,-1,1,-1,0,-5,-1,-1,2,1,0,-1,1,-1,0,-2,3,-2,
  2,1,0,1,0,-2,-2,-1,-2,-2,1,-1,2,0,3,2,0,0,1,-1,-1,-1,-2,2,-1,0,0,
  -2,-1,-1,-1,-1,-1,2,1,0,0,1,1],
[12,9,2,5,2,9,2,-2,-3,2,-10,-13,1,7,-10,-6,-1,-7,-2,-6,4,9,3,13,0,
  -6,-1,-7,3,0,-12,10,-6,-6,-15,-6,0,-4,-3,11,-6,3,-8,-2,1,6,-13,8,
  12,0,-6,3,0,3,0,4,7,1,10,-2,-2,1,-10,1,2,0,8,-6,5,-13,3,12,-5,0,
  2,-8,7,-4,3,0,5,1,0,4,1,-3,-2,-1,-1,0,4],
[4,0,6,2,4,4,-7,1,3,3,4,-4,-4,3,1,-4,-4,-4,-5,-4,3,9,5,7,4,-1,7,-3,
  5,4,-6,-1,0,-7,-2,0,-7,1,1,5,0,-3,-1,-8,2,-3,-7,2,3,-5,4,5,3,0,2,
  -2,1,-2,3,-4,-2,-1,-5,0,5,-6,4,-7,-3,2,-1,5,-7,2,3,-4,1,-1,2,-1,
  2,-5,0,-1,-4,1,-1,1,-1,0,2],
[11,9,-2,1,-5,1,9,-6,-14,-4,-8,-8,0,0,-10,-5,3,-4,2,-3,1,-2,1,2,-2,
  -5,-9,-5,-4,-3,-7,15,-11,4,-15,-5,9,-9,-9,-2,-5,10,-8,8,-3,12,-6,
  2,7,3,-8,-9,1,3,-6,4,6,-3,3,-8,7,5,-6,8,4,10,5,0,5,-15,5,6,7,2,-4,
  -3,4,-6,4,2,4,8,-1,0,8,-3,-4,-4,0,1,3],
[-4,-2,2,0,5,0,-5,3,9,2,0,1,-2,-1,5,0,-1,2,-5,0,4,5,-1,4,2,2,5,3,5,
  1,1,-6,4,-6,4,5,-8,6,5,3,3,-4,3,-5,3,-6,-1,-2,-2,-2,5,7,-1,-1,3,
  -4,-1,1,-2,2,-5,-4,3,-4,-1,-7,2,-2,-2,7,-3,0,-7,0,3,0,-1,4,-1,-3,
  1,-5,-1,-1,-5,0,2,3,-1,0,-1],
[17,11,-2,6,-4,2,10,-6,-13,0,-12,-11,1,4,-14,-1,5,-12,6,-8,2,2,6,8,
  -1,-2,-6,-4,2,0,-8,11,-11,-4,-12,-7,6,-10,-11,10,-7,11,-9,4,-2,12,
  -10,11,11,6,-11,-5,-1,4,1,8,8,-1,6,-3,1,9,-11,5,1,6,6,-4,7,-19,2,
  8,5,0,-3,-10,8,-7,4,2,4,7,-3,4,6,-4,-4,-6,-2,-2,1],
[2,3,-2,8,3,7,-2,-2,-11,4,6,-12,-1,4,-4,-5,-4,-5,-3,-1,1,5,14,8,1,
  4,3,-1,2,1,-2,1,-3,-5,-3,2,-7,-2,-3,9,4,3,-5,-2,0,2,-11,0,3,1,-6,
  1,-2,-5,-4,-7,-1,1,8,-9,9,2,-6,6,2,-1,-1,-8,-2,-2,0,6,-1,6,6,-5,
  3,-4,2,4,6,3,3,-2,2,-3,-2,-1,-2,0,1],
[0,-1,5,-3,3,-1,-7,3,6,-2,0,2,-4,-3,2,0,-1,4,-5,-1,3,4,-3,2,5,0,3,
  1,4,2,-1,-1,3,-1,0,2,-5,2,1,-3,0,-3,4,-3,1,-3,-2,-3,-1,-5,6,2,1,
  0,1,-2,-2,-2,-2,-2,-2,-3,2,-2,4,-4,4,-3,-3,4,-1,0,-6,0,0,1,-2,2,
  0,-3,0,-4,-1,-2,-3,2,0,1,-1,3,1],
[-24,-9,-5,0,6,7,-10,10,20,9,8,2,6,2,13,0,-10,14,-11,11,-5,2,-10,0,
  1,1,7,4,-6,-4,12,-9,8,-3,8,11,-8,18,18,0,14,-13,4,0,2,-14,9,-16,
  -7,-1,6,10,-6,-7,-4,-18,-9,8,-2,12,1,-16,16,-5,-8,-10,-6,5,-3,20,
  0,0,-10,0,9,10,-4,10,-8,1,-2,-9,5,-5,-7,-3,6,11,3,1,-2],
[-3,-3,2,-8,0,-6,-2,0,6,-4,-1,8,-2,-5,4,4,2,5,-1,1,2,-2,-7,-4,2,1,
  0,1,-1,1,3,-1,2,3,4,1,0,2,2,-8,-1,-1,5,0,0,-2,5,-3,-3,-4,6,-1,2,
  2,1,2,-1,-2,-6,2,-2,-2,5,-2,1,0,2,3,-2,5,-2,-5,-1,-1,-3,4,-5,3,-1,
  -4,-3,-3,-1,-1,-1,1,1,1,1,3,0],
[-9,-7,-2,-9,-4,-10,3,0,7,-2,2,14,1,-7,8,7,4,7,2,5,-2,-9,-8,-12,-2,
  3,-3,5,-5,-1,11,-7,4,6,12,3,5,4,3,-11,1,-1,8,4,0,-3,16,-4,-8,0,6,
  -2,1,2,3,3,-2,-1,-11,9,-4,-1,10,-4,-4,2,-4,9,-1,8,-3,-11,5,-3,-5,
  8,-7,5,-3,-3,-7,-2,-2,-1,-1,1,3,1,3,0,-4],
[3,4,0,1,2,0,1,0,3,0,-7,-2,-2,-2,-2,2,2,0,-1,-2,3,2,-2,4,1,1,0,3,4,
  -2,0,-1,0,-5,0,1,-2,0,-1,5,0,1,0,1,0,-1,-5,2,2,2,0,2,-3,1,3,1,0,
  1,-1,0,-3,2,0,-2,-1,-2,4,-2,2,-2,-2,1,-3,-1,0,-3,2,1,0,-1,2,0,-3,
  1,0,-1,0,0,-2,1,-1],
[-15,-9,-5,0,-4,-5,1,-2,2,0,8,10,3,-4,10,4,-2,5,4,11,-5,-12,-1,-13,
  -6,5,-4,7,-5,1,11,-12,8,4,17,5,0,5,4,-6,4,-2,7,1,0,-4,13,-2,-9,1,
  0,-5,-1,-3,1,0,-6,5,-7,8,0,-2,8,-3,-7,1,-11,9,-4,10,-3,-11,7,0,-1,
  7,-5,6,-5,1,-6,1,3,-1,-1,3,5,3,2,-3,-3],
[15,7,4,1,-1,2,0,-5,-15,-4,-3,-10,-2,1,-9,-2,1,-6,1,-5,5,2,8,7,4,-2,
  -4,-5,1,3,-8,11,-5,2,-11,-6,1,-11,-11,1,-8,8,-4,0,-2,10,-10,7,8,
  -3,-7,-5,3,1,-3,6,5,-4,8,-11,5,6,-11,4,7,7,6,-7,0,-14,2,5,2,3,-2,
  -5,3,-7,5,0,4,5,1,1,5,-1,-4,-7,-2,3,4],
[16,6,3,6,-1,5,-1,-2,-12,0,-1,-14,-1,6,-9,-1,0,-11,1,-8,3,7,10,12,
  6,0,1,-5,4,2,-8,11,-5,-4,-11,-3,1,-10,-10,8,-3,6,-6,0,-2,6,-11,7,
  8,1,-8,0,1,-1,-1,1,4,-4,10,-10,6,5,-12,4,5,2,6,-9,1,-13,3,8,0,3,
  1,-8,6,-9,4,2,5,4,0,0,3,-3,-4,-7,-3,1,2],
[-3,-1,-2,0,-1,1,1,1,2,2,0,1,2,1,1,1,0,0,0,1,-2,-1,-2,-1,-1,0,0,0,
  -2,-1,2,0,0,0,1,1,3,2,2,0,2,-1,-1,2,0,0,3,-1,-1,2,0,1,-1,0,0,-1,
  0,1,-1,3,0,-1,2,0,-2,0,-2,2,1,1,1,0,1,-1,0,1,0,1,-1,1,-1,0,0,0,0,
  -1,0,1,1,-1,-1],
[5,0,8,-1,4,5,-9,2,4,-2,0,-5,-4,2,0,-3,-4,1,-6,-2,5,8,-1,8,6,-3,5,
  -4,4,3,-7,4,3,-2,-6,-1,-6,0,0,-1,-2,-3,1,-6,1,-2,-8,0,4,-8,3,4,3,
  -1,0,-1,0,-2,4,-5,-1,-4,-4,-1,6,-4,6,-6,-3,0,1,5,-9,1,2,-1,0,-1,
  1,-3,2,-4,2,-1,-3,1,0,0,-1,4,4],
[-1,-4,-1,2,-2,-9,2,-1,-3,-1,4,8,-2,-4,3,9,5,-5,9,-1,-2,-6,7,-5,-2,
  8,1,7,7,3,6,-13,6,-1,14,2,-1,-1,-3,2,-1,1,6,-2,0,-3,6,5,-8,4,1,-1,
  -1,0,7,5,-4,0,-4,2,-5,7,0,-5,-4,-1,-7,1,-2,3,-5,-10,6,-2,-2,-2,-1,
  1,-1,0,-3,2,-3,2,-1,4,0,-4,-2,-4,-5],
[-13,-12,0,-1,-2,-3,-4,1,1,0,21,9,-1,-1,12,-2,-6,6,0,9,-6,-8,2,-13,
  -1,4,4,0,-7,1,9,-8,6,5,14,5,-1,4,5,-10,10,-6,4,-1,0,-7,11,-7,-8,
  -2,5,-3,4,-6,-3,-8,-6,0,-5,-1,7,-4,6,4,1,-1,-10,5,-8,15,0,-8,5,4,
  1,8,-7,1,-2,4,-5,-2,5,-6,-2,4,3,4,2,-1,-2],
[-9,-1,-1,0,6,6,-6,6,11,6,1,-1,1,1,3,-3,-5,6,-8,2,-1,6,-3,3,2,0,6,
  1,0,-1,2,-4,2,-4,0,4,-7,9,9,4,6,-6,0,-3,1,-6,-1,-8,-1,-2,5,7,-3,
  -2,-1,-9,-3,3,0,4,-1,-7,6,-1,-1,-7,0,-2,-1,9,-1,4,-9,0,5,2,-1,5,
  -2,0,1,-6,1,-2,-4,-2,1,6,1,1,0],
[0,1,5,-3,4,2,-6,6,17,0,-6,2,-2,-1,2,0,-1,6,-6,-4,2,6,-12,4,5,-4,6,
  0,3,-1,-1,1,3,-4,-3,1,-3,6,6,0,1,-7,3,-1,1,-8,-1,-3,2,-3,6,7,-1,
  1,4,-3,0,0,-2,5,-7,-7,4,-6,1,-8,7,-1,1,4,0,3,-11,-4,1,1,0,4,-2,-4,
  -1,-7,-2,-1,-5,0,2,3,-1,2,0]])
,
Matrix(Integers(), [[8,3,2,1,-1,1,2,-3,-4,-1,-1,-2,-2,2,-4,-4,1,-4,2,-4,1,2,2,1,0,-3,
  0,-4,1,1,-6,4,-4,-1,-5,-4,1,-5,-3,2,-3,2,-4,-1,0,3,-5,4,5,0,-1,-2,
  3,2,0,3,4,-2,2,-5,0,3,-6,4,4,1,3,-2,1,-5,1,3,1,1,-1,-4,2,-4,3,1,
  1,1,-1,1,1,1,-2,-1,-1,-1,2],
[0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[6,8,2,0,7,8,-4,-4,-3,-2,-5,-9,-5,-1,-5,-12,-3,5,-7,-1,6,6,1,5,3,-5,
  0,-3,0,-1,-10,9,-4,1,-12,-2,-7,-3,-1,2,-1,2,-5,-2,0,3,-15,-3,10,
  -5,-1,-2,1,-1,-8,-5,2,0,5,-14,7,-2,-4,9,9,0,10,-6,-1,-3,1,8,-7,6,
  3,-3,2,-2,4,1,6,1,2,-2,2,-1,-2,3,-3,5,7],
[0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,
  0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,
  0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[0,-1,1,0,1,0,-2,0,0,0,3,0,-1,0,1,-1,-1,0,-1,0,1,1,3,0,1,1,2,-1,0,
  2,0,-1,1,-1,1,0,-2,0,0,0,1,-1,0,-3,0,-1,0,0,0,-2,1,1,1,-1,1,-1,0,
  -1,0,-1,1,0,-1,1,2,-1,0,-2,-2,2,-1,0,-1,1,0,0,-1,0,1,0,0,-1,1,-1,
  -1,0,0,0,0,0,0],
[-2,-3,-1,0,-2,1,-1,1,1,2,4,1,2,3,3,-2,-2,0,1,3,-3,-1,-1,-1,0,-2,-1,
  -2,-4,-1,0,1,1,3,-1,0,3,1,1,-1,2,-1,-1,1,0,0,3,-2,0,0,1,0,2,1,-3,
  -1,-1,1,0,0,1,-1,1,1,-2,0,-2,3,1,1,2,0,2,0,1,2,0,-1,-1,2,-2,0,0,
  0,-2,1,0,1,2,0,1],
[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[2,2,1,1,0,2,0,1,2,0,-2,-2,0,1,-2,-2,-1,0,-1,-2,0,1,-1,1,0,-2,1,-2,
  0,0,-2,2,-1,-1,-3,-1,0,0,-1,1,-1,0,-1,0,0,0,-2,1,2,0,-1,0,0,0,1,
  0,1,0,1,1,-1,-1,-1,0,1,-1,1,-1,1,-2,1,3,-2,-1,0,-1,1,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0],
[1,2,1,0,0,0,-1,2,2,-1,-4,-1,-1,-1,-2,2,1,-2,0,-4,-1,2,-3,3,1,-1,1,
  1,4,0,-2,1,0,-2,-2,1,0,0,0,1,-1,0,0,1,0,-1,-2,0,-1,1,1,1,-2,1,1,
  0,-2,-1,0,0,-1,0,0,-2,0,-2,2,-1,1,-1,1,1,-2,-2,0,-2,2,0,-1,-1,1,
  0,-2,0,0,0,-1,-1,-1,0,0],
[-7,-1,-5,2,0,3,2,2,5,5,-2,1,6,3,1,1,-1,3,1,4,-4,-2,-5,-2,-3,-1,-2,
  1,-4,-3,4,-2,1,0,2,1,2,5,7,4,3,-3,-1,3,0,-1,5,-2,0,4,-2,2,-4,0,-1,
  -2,-1,6,1,9,-2,-4,5,-2,-7,-1,-3,5,3,2,1,0,0,-2,2,2,1,3,-3,2,-2,-1,
  1,2,-1,-2,2,4,1,-2,-1],
[-4,-1,-3,-2,3,-4,-3,3,4,1,1,5,2,-4,2,3,1,6,2,0,-2,-1,-3,-3,3,5,2,
  2,-1,1,4,-1,1,4,3,3,-2,4,3,-2,2,-2,3,0,-3,-3,7,-7,-4,-1,5,0,-1,-2,
  -1,-5,-3,0,-3,0,1,-4,7,2,2,-2,-1,0,-2,6,-2,-3,-2,0,-1,3,-3,2,-1,
  -1,-2,-1,0,-1,-2,0,-2,1,-1,1,-1],
[-1,-2,4,-6,1,-5,-3,2,7,-4,-3,7,-4,-5,3,6,3,0,-2,-3,1,2,-6,0,1,0,2,
  3,6,1,1,-4,3,-1,4,1,-1,2,1,-5,-3,-3,5,-2,1,-3,2,0,-4,-3,6,3,0,3,
  4,4,-1,-3,-5,2,-6,1,2,-7,0,-2,2,0,-1,4,-2,-4,-3,-3,-2,1,-2,3,-1,
  -5,-1,-4,-3,1,-1,2,0,-1,0,2,-1],
[8,7,0,2,5,2,0,2,-1,1,-8,-5,-2,0,-7,1,3,-4,0,-8,2,7,1,8,3,0,3,1,7,
  -1,-5,3,-5,-4,-8,-1,-3,-1,-2,8,-4,1,-3,0,-1,0,-9,2,3,2,-1,4,-3,2,
  1,-1,1,-1,3,-5,-2,3,-3,-1,3,-2,5,-7,3,-5,-1,5,-5,-1,2,-6,5,-2,2,
  -1,5,0,-3,2,1,-1,-4,-2,-3,1,0],
[0,-1,1,-4,2,-4,-4,2,7,-1,-5,5,-1,-4,3,6,3,2,-1,1,3,2,-4,3,4,2,-1,
  5,4,0,4,-3,5,0,3,2,-2,2,0,0,-2,-2,6,-2,0,-2,3,-1,-2,-2,3,4,-2,2,
  3,2,-1,0,-3,3,-5,1,4,-8,-3,-1,3,0,1,2,-3,-4,-4,-2,-1,2,-1,4,-1,-4,
  -1,-3,-3,2,-3,0,1,-2,0,3,-1],
[4,0,2,-3,-1,1,-1,-4,-3,-3,2,1,-3,0,-1,-3,0,-2,-1,-2,1,1,1,-1,-3,-4,
  0,-3,0,2,-3,1,-1,2,-1,-2,0,-4,-2,-3,-5,0,-1,-3,2,1,-3,3,2,-2,-1,
  0,4,2,1,3,4,-4,-1,-4,1,2,-5,0,4,2,1,0,-2,0,0,0,0,2,0,0,0,-1,2,-1,
  -1,0,1,0,2,1,0,-1,1,0,2],
[-6,-3,-1,1,-2,1,0,0,3,3,2,2,3,1,4,2,-1,-1,1,5,-2,-2,0,-1,-2,0,-2,
  4,0,0,4,-8,7,-3,7,0,-1,1,4,2,1,-3,3,-2,0,-3,4,2,-1,1,-1,2,-3,0,3,
  3,-2,4,0,7,-5,0,1,-5,-7,-1,-4,4,0,3,-2,-3,1,-2,1,2,0,3,-3,1,-2,-2,
  0,2,-2,1,4,1,1,-3,0],
[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[-2,1,-7,1,-5,-9,13,3,2,-1,-9,7,6,-3,-2,10,8,4,10,1,-5,-12,-10,-10,
  -4,5,-7,3,-5,-7,9,1,-4,6,3,2,12,3,-1,-2,1,6,2,13,-3,3,13,0,-5,11,
  -3,-7,-4,1,2,3,-1,4,-6,11,-4,1,10,-1,-9,2,-5,9,8,-5,1,-5,9,-7,-6,
  2,-1,1,-3,0,-5,6,-4,3,2,-1,0,-1,0,-1,-7],
[4,-3,4,-1,0,2,-8,2,-2,0,7,-3,-4,1,1,-2,-3,-6,-5,-3,-1,8,5,8,5,-2,
  3,-3,3,3,-5,2,0,-2,-4,0,-2,-3,-2,-1,-1,-3,-2,-4,0,-1,-5,-2,0,-5,
  4,3,4,1,-4,-3,-1,-6,1,-9,4,2,-5,0,5,1,3,-5,-3,1,2,2,-3,4,2,-1,1,
  -3,1,1,3,-3,-1,-2,-1,1,-4,-2,1,2,2],
[-13,-4,-3,-1,8,9,-10,5,19,9,1,1,6,4,9,-4,-7,13,-8,9,0,5,-9,4,3,-2,
  4,2,-5,-2,6,-4,8,-1,2,6,-8,13,15,6,7,-11,5,-4,2,-11,5,-9,1,-2,4,
  11,-4,-3,-1,-11,-3,8,1,10,-3,-14,11,-5,-5,-9,1,3,-1,13,-2,2,-13,
  0,8,7,-1,8,-5,-1,-3,-9,4,-1,-9,-3,6,9,2,1,2],
[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[4,2,0,2,2,-1,3,-2,-6,-2,2,-3,-2,0,-3,-2,0,0,-1,-1,3,0,5,-2,0,3,0,
  -2,0,0,0,3,-4,0,-1,-1,0,-2,-3,-2,1,2,-3,0,-1,2,-3,0,2,-1,-3,-3,1,
  -3,-2,-2,3,-1,1,-5,4,2,-3,5,4,3,0,-3,-1,-2,0,2,2,3,-1,-1,-1,-2,3,
  1,3,2,2,-1,3,-1,-1,-1,-2,1,-1],
[-13,-4,-3,-1,8,9,-10,5,19,9,1,1,6,4,9,-4,-7,13,-8,9,0,6,-9,4,3,-2,
  4,2,-5,-2,6,-4,8,-1,2,6,-8,13,15,6,7,-11,5,-4,2,-11,5,-9,1,-2,4,
  11,-4,-3,-1,-11,-3,8,1,10,-3,-14,11,-5,-5,-9,1,3,-1,13,-2,2,-13,
  0,8,7,-1,8,-5,-1,-3,-9,4,-1,-9,-3,6,9,2,1,2],
[-2,0,-1,-3,5,-4,-3,0,2,-1,1,5,-3,-6,3,1,2,5,-1,1,2,-1,1,-3,3,5,1,
  4,3,1,3,-4,2,2,6,3,-5,1,1,-1,2,-1,3,-3,-1,-2,1,-4,-2,-2,5,0,-1,-1,
  0,-2,-2,0,-4,-4,1,0,4,2,2,-1,1,-1,-3,6,-4,-4,-2,2,-1,1,-3,3,1,-1,
  0,-1,-1,-1,-1,1,-1,1,-2,2,0],
[4,4,3,-1,9,-1,-4,1,8,-2,-6,2,-5,-4,-2,0,2,3,-4,-7,6,7,-3,3,3,2,7,
  2,8,2,-1,-1,-2,-4,0,2,-9,4,1,3,-2,-3,2,-5,1,-5,-5,-1,1,-3,3,5,-1,
  -1,5,-3,2,-1,-2,-2,-4,-2,1,-2,5,-6,6,-6,-1,4,-4,2,-10,0,1,-3,0,3,
  2,-5,2,-4,-1,0,-2,0,-1,1,-4,2,-1],
[-16,-7,-3,4,8,2,-9,5,19,8,6,7,1,-3,10,2,-5,7,-5,5,-3,3,-5,-2,0,6,
  10,9,4,1,10,-17,7,-10,16,9,-13,15,15,8,10,-12,6,-5,2,-17,5,-7,-6,
  1,7,9,-6,-5,5,-11,-8,8,-6,9,-6,-9,11,-5,-6,-14,-4,1,-4,20,-7,-4,
  -10,0,7,2,-2,9,-6,0,-2,-10,1,-2,-8,1,4,10,-2,-3,-4],
[-1,2,-8,6,-8,0,15,-3,-13,2,-1,-4,10,7,-5,-1,1,0,11,6,-4,-13,2,-9,
  -7,1,-9,-4,-13,-4,4,7,-5,8,-3,-3,13,-3,-4,-1,2,9,-5,10,-2,9,8,4,
  1,9,-13,-9,-1,-3,-3,3,3,5,5,7,5,1,0,6,-6,8,-9,8,5,-11,5,1,14,-2,
  -3,2,1,-4,0,5,-3,11,4,2,5,-3,2,-2,2,-4,-2],
[5,2,-5,3,-9,1,13,-7,-17,-2,1,-5,5,7,-5,-5,1,-2,7,6,-2,-11,3,-7,-6,
  -4,-13,-7,-14,-5,-2,12,-6,11,-8,-6,15,-9,-7,-5,-1,10,-8,9,-2,14,
  2,4,6,4,-12,-11,3,0,-9,6,6,1,5,-3,9,5,-5,9,-2,13,-4,7,5,-14,7,2,
  15,2,-4,2,1,-7,3,6,-1,11,3,2,7,-2,0,-3,3,0,2],
[-19,-10,-9,-2,0,-11,0,5,12,3,5,17,5,-7,11,14,3,9,5,8,-6,-11,-8,-13,
  -3,11,1,13,-1,-2,20,-16,7,4,21,12,-1,13,9,-4,7,-5,11,4,0,-11,20,
  -8,-16,6,4,2,-5,-3,6,-6,-9,5,-13,14,-4,-4,18,-9,-11,-5,-12,10,-2,
  17,-6,-15,3,-4,0,9,-6,10,-7,-2,-8,-2,-1,-1,-4,1,4,3,1,-2,-9],
[4,2,-2,7,-1,15,1,-6,-11,6,8,-14,4,13,-5,-18,-10,-2,-2,4,-3,3,7,2,
  -3,-9,-2,-14,-12,0,-11,12,-6,2,-13,-7,3,-6,1,5,2,1,-13,-1,0,7,-9,
  1,13,-1,-7,-3,6,-2,-12,-5,6,2,11,-9,11,-4,-10,15,5,4,1,0,0,-6,7,
  12,2,8,5,-2,4,-8,3,9,2,3,7,-1,2,-2,-1,5,2,-2,8],
[5,2,3,-4,-2,0,-3,-1,-9,-5,3,-3,-3,-1,-3,-3,-1,-3,-1,-5,-1,3,3,2,2,
  -4,0,-5,1,3,-8,7,-3,5,-8,-3,1,-7,-4,-8,-5,1,-3,-1,-2,4,-5,-3,0,-5,
  1,-3,4,1,-6,0,1,-7,3,-12,7,2,-6,4,8,6,2,-3,-3,-3,4,2,1,3,-1,0,0,
  -4,3,0,3,2,1,-2,4,1,-5,-4,0,2,4],
[-5,-12,1,-14,-9,-20,-4,12,10,-9,2,21,-2,-11,12,21,9,-1,4,-3,-8,-6,
  -15,-4,5,4,-3,9,4,-3,12,-3,5,13,7,9,13,5,-4,-21,-3,-2,13,9,-2,-5,
  21,-10,-21,1,12,0,2,6,1,2,-9,-10,-17,3,-4,4,14,-16,-5,4,-6,8,1,7,
  2,-16,6,-8,-7,11,-6,4,-6,-7,-7,-1,-10,-1,-2,5,-4,-9,5,6,-8],
[-18,-15,-2,-2,0,0,-10,4,18,6,15,11,3,0,18,-1,-8,9,-5,15,-5,-3,-6,
  -6,2,2,2,5,-6,0,12,-13,14,0,16,8,-4,12,13,-4,11,-12,8,-4,1,-13,14,
  -10,-6,-4,8,5,1,-4,-1,-8,-8,6,-8,9,-2,-8,12,-5,-8,-7,-7,9,-5,20,
  -3,-8,-3,1,4,11,-6,8,-7,2,-7,-9,2,-3,-10,3,7,8,4,0,-1],
[-6,-2,-6,1,0,-2,2,1,4,1,0,5,1,-3,3,2,1,6,2,4,-2,-6,-5,-6,-2,3,-2,
  5,-3,-4,7,-4,1,3,6,5,1,5,2,0,4,1,3,5,0,-4,5,-3,-4,6,0,-2,-2,-1,0,
  -4,-4,4,-6,3,0,-2,8,0,-4,-3,-4,5,1,5,-2,-4,2,-1,1,3,-1,3,-3,1,-3,
  2,-1,-1,-1,1,2,3,0,0,-3],
[-12,-4,-2,1,3,-1,0,5,18,5,-1,8,5,0,5,4,-2,9,0,2,-3,-2,-10,-6,-2,4,
  6,2,-2,-1,9,-8,4,-4,11,5,-2,13,11,3,7,-7,5,0,1,-9,11,-4,-4,3,5,5,
  -4,-2,7,-5,-2,7,-5,17,-8,-9,11,-4,-6,-10,-4,5,0,11,-3,-2,-5,-5,1,
  3,-3,7,-5,-2,-6,-6,1,0,-6,-1,5,7,0,-3,-5],
[-8,-5,1,-7,4,0,-9,7,19,3,0,9,3,-1,6,5,-1,7,-4,-1,-2,6,-12,2,3,-2,
  6,1,0,2,5,-4,5,-1,3,3,-4,10,12,-1,0,-12,7,-4,1,-10,10,-7,-4,-3,9,
  10,-1,1,5,-4,-1,0,-4,12,-8,-10,9,-9,-2,-7,1,2,-1,12,-2,-2,-11,-4,
  2,6,-3,7,-4,-5,-5,-11,0,0,-7,-1,2,4,2,0,-1],
[-8,-6,4,-6,4,-1,-7,3,17,1,3,10,-1,-1,7,2,-3,6,-4,-1,0,4,-9,-3,-1,
  -2,9,0,3,4,3,-8,6,-3,9,3,-7,9,10,-4,0,-11,7,-7,4,-11,7,-3,-5,-5,
  8,8,2,0,8,-2,0,-1,-5,10,-9,-9,5,-8,0,-9,-1,2,-4,14,-3,-3,-9,-3,2,
  4,-4,7,-3,-6,-5,-10,2,-1,-6,2,4,5,1,-2,-1],
[-4,-5,-2,-3,-4,-11,4,5,0,-3,5,9,2,-3,3,8,4,2,6,-1,-6,-7,-4,-9,1,6,
  0,-1,-3,-1,6,1,-2,7,5,3,9,2,-1,-10,5,1,1,6,-3,0,14,-6,-9,2,6,-5,
  2,-1,-1,-1,-3,-3,-7,3,2,0,7,3,0,2,-6,4,0,3,2,-6,8,-3,-6,4,-5,-1,
  -1,0,-4,2,-2,-2,0,1,-3,-2,1,0,-5],
[-29,-16,-4,9,2,14,-8,7,25,18,16,1,13,13,18,-4,-17,9,-9,19,-7,1,-5,
  -1,-5,-1,7,4,-9,-1,15,-20,16,-13,18,8,-10,21,25,10,17,-19,7,-6,5,
  -20,14,-6,-4,1,0,14,-6,-9,5,-14,-7,17,2,29,-9,-19,12,-11,-18,-15,
  -13,10,-3,22,-2,0,-9,-2,13,10,-2,12,-12,4,-7,-14,9,-2,-14,-2,15,
  15,5,-9,-3],
[23,15,2,8,1,5,9,-6,-20,-4,-11,-17,-7,3,-17,-8,4,-12,2,-11,6,4,12,
  8,0,-3,-4,-6,6,-2,-15,15,-14,-3,-18,-7,3,-14,-16,9,-7,14,-13,4,-1,
  14,-24,11,13,4,-11,-8,1,3,-5,5,7,-3,9,-19,7,12,-16,11,8,6,9,-10,
  6,-22,4,12,4,4,-1,-14,9,-11,8,4,10,11,-3,2,9,-1,-7,-6,-5,2,3],
[4,-3,1,-6,-7,-14,6,-1,-8,-8,0,9,-3,-7,0,13,10,-7,6,-3,0,-7,1,-6,-1,
  5,-6,4,4,0,6,-2,0,5,7,0,10,-7,-9,-11,-6,5,4,4,-1,5,8,4,-8,2,0,-5,
  2,4,4,11,1,-7,-8,0,-2,11,-1,-6,-2,9,-4,3,1,-4,-1,-10,11,-3,-8,2,
  -3,-1,1,-3,-2,4,-5,2,5,2,-2,-9,1,1,-5],
[-2,-3,0,5,-2,2,-1,3,5,4,2,-2,1,4,3,0,-2,-3,0,2,-2,0,0,3,1,0,1,1,0,
  -1,1,-3,3,-5,2,2,1,3,1,5,4,-1,1,1,1,-3,1,1,-1,3,0,2,-1,0,2,-1,-3,
  3,0,5,-3,-1,1,-3,-5,-4,-2,1,2,0,1,1,0,-2,2,-1,2,0,-3,2,-1,-1,-2,
  0,-4,1,2,1,1,-2,-2],
[2,0,2,-3,-6,-3,3,-5,-8,-4,-1,2,0,-1,0,2,2,-4,4,1,1,-4,3,-2,-2,-2,
  -5,0,0,3,-2,-1,3,1,3,-5,3,-7,-4,-4,-5,3,2,-1,0,6,2,6,0,-2,-2,-4,
  1,2,2,10,2,-2,2,1,-2,4,-5,-2,-1,6,-1,2,-1,-5,0,-4,6,-1,-4,0,-1,-1,
  1,-1,-1,2,0,2,3,1,1,-4,1,-2,2],
[8,3,3,0,7,-2,-3,3,5,0,-7,-1,-5,-3,-3,4,4,-1,-4,-6,6,9,0,10,8,3,3,
  4,9,-1,-1,1,-3,-6,-5,1,-4,1,-2,6,-1,-1,1,-1,0,-2,-7,0,2,0,3,5,-2,
  2,2,-2,1,-2,-1,-4,-4,3,0,-4,2,-3,8,-8,3,-2,-3,2,-7,0,1,-4,2,0,2,
  -3,5,-4,-5,1,-2,-1,-3,-2,-3,4,-2],
[2,0,2,-3,1,5,-6,-1,2,0,-1,-2,-1,2,1,-5,-2,1,-5,0,2,5,-2,5,1,-6,0,
  -4,-2,1,-5,5,1,2,-6,-1,-1,-1,1,0,-2,-2,-1,-3,2,1,-4,-1,4,-4,1,4,
  2,2,-3,0,2,-2,2,-3,2,-2,-2,-1,3,0,5,-1,-1,0,2,3,-5,2,2,1,1,0,1,-1,
  0,-2,1,0,-1,-1,0,1,2,3,4],
[14,11,1,2,-2,5,11,-11,-15,-6,-9,-8,-4,2,-12,-11,3,-3,3,-4,4,-4,4,
  -4,-7,-8,-6,-8,-3,-2,-13,11,-11,3,-12,-9,5,-12,-8,2,-7,11,-11,3,
  2,13,-15,10,13,3,-9,-10,4,4,-3,9,9,-1,5,-10,5,7,-12,12,7,6,6,-1,
  3,-15,3,7,6,3,-3,-8,4,-7,7,3,3,9,1,2,9,0,-2,0,-2,0,5]])>;

return result;

