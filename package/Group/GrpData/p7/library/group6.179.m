freeze;

import "misc.m": ProcessPresentation; 

Group6_179 := function (p: Process:=true, Select:=func<x|true>, Limit:=0)

if p lt 5 then "6.179 valid only for p>3"; return false; end if;

class:=4;
limited := not Process and Limit ge 1;

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

L:=[]; Nmr := 0;

count:=0;

for x in [0..p-1] do
for y in [0..((p-1) div 2)] do
for z in [0..p-1] do
for t in [0..p-1] do
  if y eq 0 and t gt ((p-1) div 2) then continue; end if;
  count:=count+1;
  GR:=Group<a,b,c,d,e,f | d=(b,a,a),e=(b,a,b),f=(d,a),(c,a)=e, 
                      (c,b)=d^w*f^(x-w), a^p=f^y, b^p=f^z, c^p=e*f^t>;
  ProcessPresentation (~L, GR, p, class, ~Nmr: Process := Process, Select := Select);
  if limited and Nmr ge Limit then return L; end if; 
end for;
end for;
end for;
end for;

vprint Orderp7, 1: "Group 6.179 has",count,"descendants of order p^7 and p-class 4";

vprint Orderp7, 2: "Total number of groups is (p^4+p^2)/2 =",
(p^4+p^2)/2;

if Process then return Nmr; else return L; end if;

end function;
