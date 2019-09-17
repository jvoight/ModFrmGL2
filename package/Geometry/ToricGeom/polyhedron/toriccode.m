freeze;

/////////////////////////////////////////////////////////////////////////
// toriccode.m
/////////////////////////////////////////////////////////////////////////
// $Revision: 48810 $
// $Date: 2014-11-01 22:14:16 +1100 (Sat, 01 Nov 2014) $
// $LastChangedBy: kasprzyk $
/////////////////////////////////////////////////////////////////////////
// Authors: Gavin Brown and Alexander Kasprzyk
/////////////////////////////////////////////////////////////////////////
// Functions for creating the toric code associated to a polytope.
// For further details see:
//  "Small polygons and toric codes", G.Brown and A.M.Kasprzyk.
/////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////
// Local functions
/////////////////////////////////////////////////////////////////////////

// The bounding box of the sequence of lattice points S. The bottom-left and
// top-right corners are returned.
function bounding_box(S)
    cols:=RowSequence(Transpose(Matrix(S)));
    min:=Universe(S) ! [Integers() | Min(c) : c in cols];
    max:=Universe(S) ! [Integers() | Max(c) : c in cols];
    return min,max;
end function;

// Returns a set of m-tuples of the form [alpha^i1,...,alpha^im] for
// all 0 <= i <= q - 2, where alpha is the primitive element of F(q).
procedure build_points_recurse(pt,~pts,alpha,q,m)
    if #pt eq m then
        Append(~pts,pt);
    else
        for i in [0..q-2] do
            $$(Append(pt,alpha^i),~pts,alpha,q,m);
        end for;
    end if;
end procedure;

function build_points(alpha,q,m)
    pts:=[PowerSequence(Parent(alpha))|];
    build_points_recurse([Parent(alpha)|],~pts,alpha,q,m);
    return pts;
end function;

// Returns true followed by the linear code over FF_q generated by the sequence
// of lattice points S on success, false followed by an error message otherwise.
function generate_code(S,q)
    // Sanity checks
    if not IsPrimePower(q) then
        return false,"Argument 2 must be a prime power";
    end if;
    if #S eq 0 then
        return false,"Argument 1 must contain lattice points";
    end if;
    if not IsIntegral(S) then
        return false,"Argument 1 must be a sequence of lattice points";
    end if;
    // Get the bottom-left and top-right corners of the bounding box
    min,max:=bounding_box(S);
    // Check that the box is contained in [0..q - 2]^m
    m:=Dimension(Universe(S));
    if Max(Eltseq(max - min)) gt q - 2 then
        return false,Sprintf("The lattice points cannot be translated into the [0..%o]^%o box",q - 2,m);
    end if;
    // Get the points of the big torus
    FF:=FiniteField(q);
    pts:=build_points(PrimitiveElement(FF),q,m);
    // Build the Reimann-Roch basis
    R:=PolynomialRing(FF,m);
    RR:=[R | LatticeElementToMonomial(R,p - min) : p in S];
    // Return the code
    entries:=[PowerSequence(FF) | [FF | Evaluate(f,p) : p in pts] : f in RR];
    return true,LinearCode(Matrix(entries));
end function;

/////////////////////////////////////////////////////////////////////////
// Intrinsics
/////////////////////////////////////////////////////////////////////////

intrinsic SmallestPrimePower( q::RngIntElt ) -> RngIntElt
{The smallest prime power greater than or equal to q}
    if q le 2 then
        return 2;
    end if;
    while not IsPrimePower(q) do
        q +:= 1;
    end while;
    return q;
end intrinsic;

intrinsic ToricCode( P::TorPol, q::RngIntElt ) -> Code
{The toric code over the finite field GF(q) associated with the lattice points in the polytope P}
    // Sanity check
    require IsPolytope(P): "Argument 1 must be a polytope";
    // Extract the lattice points in P
    S:=SetToSequence(Points(P));
    // Build the linear code
    bool,C:=generate_code(S,q);
    require bool: C;
    return C;
end intrinsic;

intrinsic ToricCode( S::SetEnum[TorLatElt], q::RngIntElt ) -> Code
{}
    // Extract the lattice points in S
    S:=[Universe(S) | v : v in S | IsIntegral(v)];
    // Build the linear code
    bool,C:=generate_code(S,q);
    require bool: C;
    return C;
end intrinsic;

intrinsic ToricCode( S::SeqEnum[TorLatElt], q::RngIntElt ) -> Code
{The toric code over the finite field GF(q) associated with the lattice points in S}
    // Extract the lattice points in S
    S:=SetToSequence({Universe(S) | v : v in S | IsIntegral(v)});
    // Build the linear code
    bool,C:=generate_code(S,q);
    require bool: C;
    return C;
end intrinsic;
