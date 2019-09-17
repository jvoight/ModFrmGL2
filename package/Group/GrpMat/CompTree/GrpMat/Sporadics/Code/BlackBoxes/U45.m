freeze;

/* black box recognition procedure for U4(5) */

import "../Presentations/U45.m":PresentationU45;
 
StandardGeneratorsU45 := function (G : Projective := false, Limit := 500)

   Fct := Projective select CentralOrder else Order;
   
   P := RandomProcessWithWords (G); 
   g, w := ElementOfOrder (P, {8,24,60}, Limit: Fct := Fct);
   if Type (g) eq BoolElt then return false, _; end if;

   o := Fct(g);
   x := g^(o div 2);
   xw := w^(o div 2);
   
   b := g^(o div 4); bw := w^(o div 4);
         
   nmr := Limit;
   repeat 
      nmr -:= 1;
      c, cw := Random (P);
      a := x^c;
   until Fct (a * b) eq 9 or nmr eq 0;

   if nmr eq 0 then return false, _; end if;

   aw := xw^cw; 
   
   return [a, b], [aw, bw];

end function;
