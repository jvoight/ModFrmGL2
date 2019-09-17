freeze;

import "../l3.m": R, x1, xm1, x2, xm2, x12, xm12, xm21, xm2m1, xcom, zeta;

h36presentations := [
<
    PermutationGroup< 21 | (6, 7)(8, 9)(10, 11)(12, 13)(14, 15)(16, 17)(18, 19)(20, 21), (1, 6, 13, 17)(2, 14, 8, 5)(3, 18)(4, 10, 19, 11)(7, 20, 21, 16)(9, 15) >,
    Group< a,b | [a^2, b^4, b^-2 * a * b^2 * a * b^2 * a, (b^-1 * a)^4 ] >,
    ideal< R | [xcom,x12 - zeta,xm12 - zeta,xm21 + zeta + 1,xm2m1 + zeta + 1,x1 + 1,xm1 + 1,x2 - 1,xm2 - 1,zeta^2 + zeta + 1] >
>,
<
    PermutationGroup< 21 | (2, 5)(3, 4)(6, 16, 7, 17)(8, 14, 9, 15)(10, 19, 11, 18)(12, 21, 13, 20), (1, 6)(3, 10)(4, 18)(5, 14)(8, 9)(12, 21)(13, 16)(17, 20) >,
    Group< a,b | [ a^4,b^2, a^-2 * b * a^2 * b * a^2 * b, (a^-1 * b)^4 ] >,
    ideal< R | [xcom,x12 + zeta + 1,xm12 - zeta,xm21 + zeta + 1,xm2m1 - zeta,x1 - zeta,xm1 + zeta + 1,x2 + 1,xm2 + 1,zeta^2 + zeta + 1] >
>,
<
    PermutationGroup< 21 | (2, 5)(3, 4)(6, 16, 7, 17)(8, 14, 9, 15)(10, 19, 11, 18)(12, 21, 13, 20), (1, 6, 7)(3, 10, 11)(4, 18, 19)(5, 14, 15)(12, 16, 20)(13, 21, 17) >,
    Group< a,b| [ a^4, b^3, a^-1 * b^-1 * a^2 * b^-1 * a^-1, a^-1 * b^-1 * a^-1 * b^-1 * a * b * a * b^-1 ] >,
    ideal< R | [xcom,x12 - 1,xm12 - 1,xm21 - 1,xm2m1 - 1,x1 - zeta,xm1 + zeta + 1,x2,xm2,zeta^2 + zeta + 1] >
>,
<
    PermutationGroup< 21 | (2, 5)(3, 4)(6, 16, 7, 17)(8, 14, 9, 15)(10, 19, 11, 18)(12, 21, 13, 20), (1, 6, 13, 17)(2, 14, 8, 5)(3, 18)(4, 10, 19, 11)(7, 20, 21, 16)(9, 15) >,
    Group<a,b | [ a^4, b^4, (a * b^-1)^2, (b^-1 * a^-1)^3 ] >,
    ideal< R | [xcom,x12,xm12 + zeta,xm21 - zeta - 1,xm2m1,x1 - zeta,xm1 + zeta + 1,x2 - 1,xm2 - 1,zeta^2 + zeta + 1] >
>,
<
    PermutationGroup< 21 | (2, 5)(3, 4)(6, 16, 7, 17)(8, 14, 9, 15)(10, 19, 11, 18)(12, 21, 13, 20), (1, 6, 20, 16)(2, 14, 9, 5)(3, 18, 11, 19)(4, 10)(7, 13, 12, 17)(8, 15) >,
    Group<a,b | [ a^4, b^4, (a^-1 * b^-1)^2, (b^-1 * a)^3 ] >,
    ideal< R | [xcom,x12 + 1,xm12,xm21,xm2m1 + 1,x1 - zeta,xm1 + zeta + 1,x2 - zeta,xm2 + zeta + 1,zeta^2 + zeta + 1] >
>,
<
    PermutationGroup< 21 | (1, 6, 7)(3, 10, 11)(4, 18, 19)(5, 14, 15)(12, 16, 20)(13, 21, 17), (2, 5)(3, 4)(6, 16, 7, 17)(8, 14, 9, 15)(10, 19, 11, 18)(12, 21, 13, 20) >,
    Group< a,b| [ a^3, b^4, b^-2 * a^-1 * b^2 * a^-1, a^-1 * b^-1 * a^-1 * b^-1 * a^-1 * b * a * b ] >,
    ideal< R | [xcom,x12 - 1,xm12 - 1,xm21 - 1,xm2m1 - 1,x1,xm1,x2 - zeta,xm2 + zeta + 1,zeta^2 + zeta + 1] >
>
];

