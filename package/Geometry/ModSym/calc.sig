174,1
S,HeckeAlgebraZBasis,A sequence of matrices that form a Z-basis for the Hecke algebra attached to M,0,1,0,0,0,0,0,0,0,ModSym,,82,-38,-38,-38,-38,-38
S,HeckeAlgebra,"The Hecke algebra associated to M. If the optional integer parameter Bound is set, then the algebra generated only by those T_n, with n <= Bound, is computed. This is a Q-algebra T such that Generators(T) is guaranteed to be a Z-generator set for the module generated over Z by all Hecke operators. To get a Q-algebra whose generators have no special integral structure, use the HeckeAlgebraTensorQ command, which is much faster",0,1,0,0,0,0,0,0,0,ModSym,,176,-38,-38,-38,-38,-38
S,DiscriminantOfHeckeAlgebra,"The discriminant of the Hecke algebra associated to M. If the optional parameter Bound is set, then the discriminant of the algebra generated by only those T_n, with n <= Bound, is computed instead",0,1,0,0,0,0,0,0,0,ModSym,,148,-38,-38,-38,-38,-38
S,CharpolyOfFrobenius,"The characteristic polynomial of Frob_p acting on the dimension 2g Q_ell-adic representation attached to the newform class associated to M. We assume that M corresponds to a single Gal(Qbar/Q)-conjugacy class of newforms. This function returns the charpoly, over Q, of Frobenius acting on any of corresponding ell-adic representations",0,2,0,0,0,0,0,0,0,148,,0,0,ModSym,,312,-38,-38,-38,-38,-38
S,TorsionBound,A bound on the size of the rational torsion subgroup of the associated abelian variety A_f obtained by looking at the first n good odd primes,0,2,0,0,0,0,0,0,0,148,,0,0,ModSym,,148,-38,-38,-38,-38,-38
S,SubgroupOfTorus,The cyclic subgroup of the complex torus attached to M that is generated by the image under the period map of the point x,0,2,0,0,0,0,0,0,0,ModSymElt,,0,0,ModSym,,148,-38,-38,-38,-38,-38
S,SubgroupOfTorus,"An abelian group G that is isomorphic to the finite group generated by the sequence of images pi(s[i]) in the complex torus attached to M, where pi is PeriodMapping(M). This intrinsic also returns a map from AmbientSpace(M) to G, which is defined only on the subgroup generated by the s (i.e., there is an error if you evaluate it elsewhere), and a set-theoretic section from G to AmbientSpace(M)",1,1,1,82,0,ModSymElt,2,0,0,0,0,0,0,0,82,,0,0,ModSym,,107,175,175,-38,-38,-38
S,CuspidalSubgroup,"The subgroup C of the abelian variety attached to M generated by the cusps on X_0(N), along with a map sending the rational number alpha to the image of (alpha)-(oo) in C",0,1,0,0,0,0,0,0,0,ModSym,,107,175,-38,-38,-38,-38
S,RationalCuspidalSubgroup,"The subgroup C of the abelian variety quotient of J_0(N) attached to M generated by the rational cusps on X_0(N). (To compute the map that sends a rational number to its image in C, see CuspidalSubgroup.)",0,1,0,0,0,0,0,0,0,ModSym,,107,-38,-38,-38,-38,-38
S,ModularKernel,The kernel of the modular isogeny. Let T be the complex torus attached to M. Then the modular isogeny is the natural map from the dual of T into T induced by autoduality of CuspidalSubspace(AmbientSpace(M)),0,1,0,0,0,0,0,0,0,ModSym,,107,-38,-38,-38,-38,-38
S,ModularDegree,"This is Sqrt(#ModularKernel(M)). If A_M is an elliptic curve E, then this degree of the map of algebraic curves X_0(N) --> E",0,1,0,0,0,0,0,0,0,ModSym,,148,-38,-38,-38,-38,-38
S,pNewModularDegree,"The p-new modular degree of M. Assume that M has trivial character, is p-new, and for notational simplicity the weight of $M$ is $2$. Let r be the (rational) period map. The p-new modular degree of M is the order of the finite quotient r(H_{p-new}) / r(M), where H_{p-new} is the p-new subspace of H = H_1(X_0(N),Z) and N is the level of M. WARNING: This number need not be a square, so we do not take the square root as we would for the usual modular degree",0,2,0,0,0,0,0,0,0,148,,0,0,ModSym,,148,-38,-38,-38,-38,-38
S,CongruenceModulus,"The congruence number r of M. This is the index in S=S_k(Gamma_0(N),Z) of the sum L+W of the lattice of cusp form L corresponding to M and the lattice of cusp forms corresponding to the complement of L in S",0,1,0,0,0,0,0,0,0,ModSym,,148,-38,-38,-38,-38,-38
S,CongruenceGroup,"The congruence group of space of cusp forms corresponding to the space of cuspidal modular symbols M. Let S=S_k(Gamma_0(N),Z), let V be the sub Z-module corresponding to M, and W be its orthogonal complement. Then the congruence group is S/(V+W). This group encodes information about congruences between forms in V and forms in the complement of V. The optional parameter Bound is a bound on the number of Hecke operators used in the computation; if it is too small, then Congruence group will give only an upper bound on the correct answer. The default is HeckeBound(M) + 1, which gives a provably correct answer",0,1,0,0,0,0,0,0,0,ModSym,,107,-38,-38,-38,-38,-38
S,IntersectionGroup,"An abelian group G that encodes information about the intersection of the complex tori corresponding to M1 and M2. When the intersection group is finite, it is isomorphic to this intersection",0,2,0,0,0,0,0,0,0,ModSym,,0,0,ModSym,,107,-38,-38,-38,-38,-38
S,IntersectionGroup,"An abelian group G that encodes information about the intersection of the collection of complex tori corresponding to the sequence S of spaces of modular symbols. When G is finite, G is isomorphic to this intersection",0,1,0,0,0,0,0,0,0,82,,107,-38,-38,-38,-38,-38
S,HeckeEigenvalueRing,"The order generated by the Fourier coefficients of one of the q-expansions of a newform corresponding to the irreducible cuspidal space M of modular symbols, along with a map from the ring containing the coefficients of qExpansion(M) to this order. If the optional integer parameter Bound is set, then the order generated by at least those T_n, with n <= Bound, is computed",0,1,0,0,0,0,0,0,0,ModSym,,-44,175,-38,-38,-38,-38
S,HeckeEigenvalueField,"The number field generated by the Fourier coefficients of one of the q-expansions of a newform corresponding to the irreducible cuspidal space M, along with a map from the ring containing the coefficients of qExpansion(M) to the field",0,1,0,0,0,0,0,0,0,ModSym,,-24,175,-38,-38,-38,-38
S,TwistedWindingElement,"The element sum_{a in (Z/mZ)^*} <eps(a)*X^(i-1)*Y^(k-2-i-1)*{0,a/m}>",0,3,0,0,0,0,0,0,0,GrpDrchElt,,0,0,148,,0,0,ModSym,,ModSymElt,-38,-38,-38,-38,-38
S,WindingElement,"The winding element {0,oo}",0,1,0,0,0,0,0,0,0,ModSym,,ModSymElt,-38,-38,-38,-38,-38
S,WindingElement,"The winding element X^(i-1)*Y^(k-2-(i-1))*{0,oo}",0,2,0,0,0,0,0,0,0,148,,0,0,ModSym,,ModSymElt,-38,-38,-38,-38,-38
S,WindingElementProjection,"The image under RationalMapping(M) of {0,oo}",0,1,0,0,0,0,0,0,0,ModSym,,159,-38,-38,-38,-38,-38
S,WindingElementProjection,"The image under RationalMapping(M) of the ith winding element X^(i-1)*Y^(k-2-(i-1))*{0,oo}",0,2,0,0,0,0,0,0,0,148,,0,0,ModSym,,159,-38,-38,-38,-38,-38
S,WindingLattice,"The image under RationalMapping(M) of the lattice generated by the images of the jth winding element under all Hecke operators T_n. If M is the ambient space, then the image under RationalMapping(M) is not taken",0,2,0,0,0,0,0,0,0,148,,0,0,ModSym,,164,-38,-38,-38,-38,-38
S,WindingSubmodule,"The projection onto M of the vector space generated by all images of WindingElement(AmbientSpace(M),j), under all Hecke operators T_n. (If not given, j=1)",0,1,0,0,0,0,0,0,0,ModSym,,159,-38,-38,-38,-38,-38
S,WindingSubmodule,"The projection onto M of the vector space generated by all images of WindingElement(AmbientSpace(M),j), under all Hecke operators T_n. (If not given, j=1)",0,2,0,0,0,0,0,0,0,148,,0,0,ModSym,,159,-38,-38,-38,-38,-38
S,TwistedWindingSubmodule,"The Hecke submodule of the vector space Phi(M) generated by the image of the jth eps-twisted modular winding element, where Phi is RationalMapping(M). Some care is needed when using a modular symbol space in a +1 or -1 quotient",0,3,0,0,0,0,0,0,0,GrpDrchElt,,0,0,148,,0,0,ModSym,,159,-38,-38,-38,-38,-38
S,LRatio,"The rational number L(A,j)*(j-1)! / ((2pi)^(j-1)*Omega), where j is a ""critical integer"", so 1<=j<=k-1, and Omega is the volume of A(R) when j is odd, and the volume of the -1 eigenspace for conjugation when j is even. The volume is computed with respect to a saturated basis of cusp forms that have integral Fourier coefficients at infinity. If the optional parameter Bound is set, then the result is a divisibility upper bound on the above rational number. If Sign(A) is not 0, then the answer is only correct up to a power of 2",0,2,0,0,0,0,0,0,0,148,,0,0,ModSym,,267,-38,-38,-38,-38,-38
S,LRatioOddPart,"The odd part of the rational number LRatio(M,j). The algorithm used by LRatioOddPart may be more efficient than the one used by LRatio",0,2,0,0,0,0,0,0,0,148,,0,0,ModSym,,267,-38,-38,-38,-38,-38
S,HeckeAlgebraFields,"A sequence of fields K_i such that the quotient of the Hecke algebra of M tensor Q is isomorphic to the product of the K_i. We assume that M is cuspidal, defined over Q, and that the level of M is square free. The fields are in the order of SortDecomposition(NewformDecomposition(M))",0,1,0,0,0,0,0,0,0,ModSym,,82,-38,-38,-38,-38,-38
