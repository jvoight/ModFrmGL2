freeze;

import "misc.m": ProcessPresentation; 

Group6_151 := function (p: Process:=true, Select:=func<x|true>)

if p lt 5 then "6.151 valid only for p>3"; return false; end if;

class:=4;

w:=0;
F:=FiniteField(p);
for i in [2..p-1] do
a:=F!i;
S:={a};
for j in [2..p-1] do
  Include(~S,a^j);
end for;
if #S eq p-1 then
  w:=i;
  break;
end if;
end for;
vprint Orderp7, 2:"p equals",p;
vprint Orderp7, 2:"w equals",w;

w2:=w^2 mod p;

L:=[]; Nmr := 0;

GR:=Group<a,b,c,d|d=(b,a,a),(c,a)=d, (c,b), a^p=d, b^p, c^p>;
ProcessPresentation (~L, GR, p, class, ~Nmr: Process := Process, Select := Select);
GR:=Group<a,b,c,d,e|d=(b,a,a),e=(b,a,b,b),(c,a)=d, (c,b), a^p=d*e, b^p, c^p>;
ProcessPresentation (~L, GR, p, class, ~Nmr: Process := Process, Select := Select);
count:=2;
if p mod 3 eq 1 then
  GR:=Group<a,b,c,d,e|d=(b,a,a),e=(b,a,b,b),(c,a)=d, (c,b), a^p=d*e^w, b^p, c^p>;
  ProcessPresentation (~L, GR, p, class, ~Nmr: Process := Process, Select := Select);
  GR:=Group<a,b,c,d,e|d=(b,a,a),e=(b,a,b,b),(c,a)=d, (c,b), a^p=d*e^w2, b^p, c^p>;
  ProcessPresentation (~L, GR, p, class, ~Nmr: Process := Process, Select := Select);
  count:=count+2;
end if;
for x in [0..p-1] do
  count:=count+1;
  GR:=Group<a,b,c,d,e|d=(b,a,a),e=(b,a,b,b),(c,a)=d*e, (c,b), a^p=d*e^x, b^p, c^p>;
  ProcessPresentation (~L, GR, p, class, ~Nmr: Process := Process, Select := Select);
  if p mod 3 eq 1 then
    GR:=Group<a,b,c,d,e|d=(b,a,a),e=(b,a,b,b),(c,a)=d*e^w, (c,b), a^p=d*e^x, b^p, c^p>;
    ProcessPresentation (~L, GR, p, class, ~Nmr: Process := Process, Select := Select);
    GR:=Group<a,b,c,d,e|d=(b,a,a),e=(b,a,b,b),(c,a)=d*e^w2, (c,b), a^p=d*e^x, b^p, c^p>;
    ProcessPresentation (~L, GR, p, class, ~Nmr: Process := Process, Select := Select);
    count:=count+2;
  end if;
end for;
for x in [0..p-1] do
for y in [0..p-1] do
  count:=count+1;
  GR:=Group<a,b,c,d,e|d=(b,a,a),e=(b,a,b,b),(c,a)=d*e^x, (c,b), a^p=d*e^y, b^p=e, c^p>;
  ProcessPresentation (~L, GR, p, class, ~Nmr: Process := Process, Select := Select);
end for;
end for;
for x in [0..((p-1) div 2)] do
  GR:=Group<a,b,c,d,e|d=(b,a,a),e=(b,a,b,b),(c,a)=d*e^x, (c,b), a^p=d, b^p, c^p=e>;
  ProcessPresentation (~L, GR, p, class, ~Nmr: Process := Process, Select := Select);
  GR:=Group<a,b,c,d,e|d=(b,a,a),e=(b,a,b,b),(c,a)=d*e^x, (c,b), a^p=d, b^p, c^p=e^w>;
  ProcessPresentation (~L, GR, p, class, ~Nmr: Process := Process, Select := Select);
  count:=count+2;
end for;

vprint Orderp7, 1: "Group 6.151 has",count,"descendants of order p^7 and p-class 4";

vprint Orderp7, 2: "Total number of groups is p^2+p+2+(p+1)gcd(p-1,3) =",
p^2+p+2+(p+1)*Gcd(p-1,3);

if Process then return Nmr; else return L; end if;

end function;
