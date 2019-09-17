freeze;

G29 := func< | MatrixGroup<7, GF(3, 2) |
    Matrix(GF(3, 2), 7, 7, [ W^7, 0, 1, W^7, W^5, 1, W^5, W, W^3, 2, W^2, W^3, 
    0, 2, 1, W^5, 2, W^7, 2, W^7, W^5, W^6, W^5, W, 1, W^7, W^6, W^7, W^6, 2, 
    W^7, W, 2, 1, 1, W^2, W, 1, W, W, W^3, 0, W, W^6, W^6, W^6, 1, W^5, W^7 ] 
    where W := GF(3, 2).1),
    Matrix(GF(3, 2), 7, 7, [ 2, 0, W^6, W^2, W^2, W^7, 2, 0, W, W^3, W^7, W^3, 
    0, W^7, W^5, W^6, 1, W^5, W^6, W^3, W^7, W^2, W^2, 1, 0, 0, W^7, W^5, 2, 
    W^7, 2, 1, W^2, W^3, W, W^7, W^2, W^6, 1, 0, W^6, W^5, W^2, W^2, W, W, W^2, 
    0, W^3 ] where W := GF(3, 2).1),
    Matrix(GF(3, 2), 7, 7, [ W^2, W^7, W^6, W^5, 1, 2, W^7, W, W, W^5, W^5, W^3,
    0, 1, W^6, 0, W^5, W^3, 0, W^7, 1, W^6, W^2, W^6, W, W^3, W, W^5, W^3, W^2, 
    2, W^6, W^5, W, W^6, W, 0, W^6, W^6, 0, W, W^3, 0, W^5, W^3, W^6, W^6, W^5, 
    W^2 ] where W := GF(3, 2).1),
    Matrix(GF(3, 2), 7, 7, [ W^7, W^5, 1, W, W^5, W^7, W^6, 2, 0, W^2, W^5, 2, 
    W^6, W^2, W^6, W, 1, W^7, 1, W^7, 1, 1, 0, 0, W^7, 1, W^7, W^3, 2, W^2, W^2,
    W^6, W^2, 0, 0, 2, W^6, 0, W^6, W^5, W^3, W^3, 2, W^2, W^6, W^5, 0, W^5, W ]
    where W := GF(3, 2).1) > >;
