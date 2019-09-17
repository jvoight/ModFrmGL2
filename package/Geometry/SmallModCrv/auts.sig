174,1
S,AtkinLehnerInvolution,"The dth AtkinLehner involution of CN, a base change of the curve from the X0N small modular curve database of level N, for d|N, GCD(d,N/d)=1",0,3,0,0,0,0,0,0,0,148,,0,0,148,,0,0,371,,374,-38,-38,-38,-38,-38
S,SrAutomorphism,"CN should be a base change of the curve from the X0N small modular curve database of level N to a field extension K of Q that contains a primitive r-th root of unity, z. r should be a positive divisor of 24 with r^2|N. Function returns the automorphism Sr of C that corresponds to the transformation z->z+(1/r) on the complex upper halfplane",0,4,0,0,0,0,0,0,0,-45,,0,0,148,,0,0,148,,0,0,371,,374,-38,-38,-38,-38,-38
S,ExtraAutomorphism,"CN should be a base change of the curve from the X0N small modular curve database of level N to a field extension K of Q that contains a primitive r-th root of unity, z. N should be 37, 63 or 108 with r respectively 1,3,3. Returns an automorphism of C that is not given by the action of a matrix normalising GammaO(N)",0,3,0,0,0,0,0,0,0,-45,,0,0,148,,0,0,371,,374,-38,-38,-38,-38,-38
S,AutomorphismGroupOverQ,"CN should be base change of the curve from the X0N small modular curve database of level N to a field K of characteristic 0. Returns the modular automorphism group (i.e, the full automorphism group if the genus is > 1 and the group of automorphisms generated by the Wd and Sr automorphisms otherwise) of CN over Q. If the parameter Install is true (the default) then the return value is internally installed as the full automorphism group of CN, so all K-rational modular automorphisms should be defined over Q in this case",0,2,0,0,0,0,0,0,0,148,,0,0,371,,448,-38,-38,-38,-38,-38
S,AutomorphismGroupOverCyclotomicExtension,"CN should be the base change of the curve from the X0N small modular curve database of level N to the cyclotomic field extension K of Q generated by the n-th roots of unity. Returns the modular automorphism group (i.e, the full automorphism group if the genus is > 1 and the group of automorphisms generated by the Wd and Sr automorphisms otherwise) of CN over K. If the parameter Install is true (the default) then the return value is internally installed as the full automorphism group of CN",0,3,0,0,0,0,0,0,0,148,,0,0,148,,0,0,371,,448,-38,-38,-38,-38,-38
S,AutomorphismGroupOverExtension,"CN should be the base change of the curve from the X0N small modular curve database of level N to a field extension K of Q that contains the n-th roots of unity mu_n and z should be a primitive n-th root of unity in K. Returns the modular automorphism group (i.e, the full automorphism group if the genus is > 1 and the group of automorphisms generated by the Wd and Sr automorphisms otherwise) of CN over Q(mu_n). If the parameter Install is true (the default) then the return value is internally installed as the full automorphism group of CN, so n should be chosen appropriately for K",0,4,0,0,0,0,0,0,0,-45,,0,0,148,,0,0,148,,0,0,371,,448,-38,-38,-38,-38,-38
