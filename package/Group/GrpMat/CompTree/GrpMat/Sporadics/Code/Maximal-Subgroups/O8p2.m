freeze;


import "../recformat.m":SporadicRF;

GeneratorsO8p2Max1 := function (a, b)

  w1 := b * a; w2 := w1 * a; w3 := b * w1; w4 := w1 * b; w5 := w4 * 
    b; w6 := w3 * w5; w7 := w2 * w6; w8 := w7 * b; w9 := b * w8; w139 := 
    w7 * w9; w16 := w5 * a; w25 := w4 * w2; w26 := a * b; w27 := b * 
    w26; w28 := w26 * w27; w29 := w25 * w28; w69 := a * w29; w31 := w27 * a;
    w32 := w4 * w31; w70 := w69 * w32; w71 := w16 * w70; w140 := w139 * w71; w17
    := b^-1; w18 := w17 * a; w120 := w18^2; w10 := b^-4; w11 := a * w10;
    w12 := b^-2; w13 := a * w12; w14 := w11 * w13; w15 := w9 * w14; w54 := 
    w15^-2; w141 := w17 * w54; w142 := w18 * w141; w143 := w120 * w142; w19 := 
    w12 * a; w20 := w18 * w19; w21 := w16 * w20; w45 := w21^-1; w144 := w45 * 
    w54; w22 := w15^-6; w23 := w20 * w22; w24 := w8 * w23; w62 := w24^-1; w145 
    := w144 * w62; w33 := w16 * w32; w42 := w25 * w5; w30 := w5 * w29; w34 := 
    w30 * w33; w35 := w34 * w16; w43 := w42 * w35; w81 := w43 * w33; w82 := w33 
    * w81; w83 := w18 * w10; w84 := w21^-3; w85 := w54 * w84; w86 := w83 * w85; 
    w87 := w15^-4; w65 := w24^-3; w88 := w87 * w65; w36 := b^-3; w37 := a * 
    w36; w38 := w15^-1; w39 := a * w38; w40 := w37 * w39; w41 := w35 * w40; 
    w50 := w41^-1; w89 := w50 * w62; w90 := w89^2; w91 := w88 * w90; w92 := w86 
    * w91; w93 := w82 * w92; w44 := w19 * w36; w46 := a * w45; w47 := w44 * 
    w46; w48 := w38 * w45; w49 := w48 * w22; w51 := w49 * w50; w52 := w47 * w51;
    w53 := w43 * w52; w77 := w53^-1; w146 := w93 * w77; w117 := w6 * w71; w118 
    := w5 * w117; w72 := w71 * w5; w73 := w72 * w8; w119 := w118 * w73; w121 := 
    w120 * w10; w122 := w121 * w54; w123 := w45 * w87; w100 := w24^-2; w55 := 
    w45 * w38; w56 := w54 * w55; w57 := w13 * w56; w58 := w21^-2; w59 := w15^-5;
    w60 := w58 * w59; w61 := w57 * w60; w63 := w62 * w50; w64 := w50 * w63; w66 
    := w64 * w65; w67 := w61 * w66; w68 := w33 * w67; w103 := w68^-1; w124 := 
    w100 * w103; w125 := w123 * w124; w126 := w122 * w125; w127 := w119 * w126; 
    w94 := a * w17; w95 := w17 * w94; w96 := w19 * w95; w97 := a * w18; w98 
    := w97 * w10; w99 := w96 * w98; w101 := w50 * w100; w102 := w54 * w101; w104
    := w93 * w103; w105 := w50 * w104; w106 := w89 * w105; w107 := w102 * w106; 
    w108 := w99 * w107; w109 := w81 * w108; w128 := w36 * w94; w129 := w11 * 
    a; w130 := w128 * w129; w131 := w17 * w48; w132 := w131 * w101; w74 := w54
    * w45; w75 := w12 * w74; w76 := w24^-4; w78 := w76 * w77; w79 := w75 * w78; 
    w80 := w73 * w79; w133 := w93 * w80; w134 := w50 * w133; w135 := w89 * w134;
    w136 := w132 * w135; w137 := w130 * w136; w138 := w118 * w137; w147 := w109 
    * w138; w148 := w127 * w147; w149 := w146 * w148; w150 := w145 * w149; w151 
    := w143 * w150; w152 := w140 * w151; w153 := w152 * w109; w154 := w153 * 
    w53; w155 := w154 * w68; w156 := w155 * w41; w157 := w156 * w24; w158 := 
    w157 * w41; w159 := w158 * w24; w160 := w159 * w24; w161 := w160 * w41; w162
    := w161 * w21; w163 := w162 * w21; w164 := w163 * w15; w165 := w164 * b; 
    w166 := w165 * a; w167 := w166 * b; w168 := w167 * a; w169 := w168 * 
    b; w170 := w169 * b; w171 := w170 * a; w172 := w171 * b; w173 := 
    w172 * a; c := w173;

  w1 := b * a; w4 := w1 * b; w2 := w1 * a; w25 := w4 * w2; w5 := w4 * 
    b; w42 := w25 * w5; w17 := b^-1; w18 := w17 * a; w10 := b^-4; w83 :=
    w18 * w10; w3 := b * w1; w6 := w3 * w5; w7 := w2 * w6; w8 := w7 * b; w9 
    := b * w8; w11 := a * w10; w12 := b^-2; w13 := a * w12; w14 := w11 *
    w13; w15 := w9 * w14; w38 := w15^-1; w16 := w5 * a; w19 := w12 * a; w20 
    := w18 * w19; w21 := w16 * w20; w45 := w21^-1; w48 := w38 * w45; w110 := 
    w48^2; w111 := w83 * w110; w87 := w15^-4; w22 := w15^-6; w23 := w20 * w22; 
    w24 := w8 * w23; w65 := w24^-3; w88 := w87 * w65; w26 := a * b; w27 := 
    b * w26; w31 := w27 * a; w32 := w4 * w31; w33 := w16 * w32; w28 := w26 *
    w27; w29 := w25 * w28; w30 := w5 * w29; w34 := w30 * w33; w35 := w34 * w16; 
    w43 := w42 * w35; w81 := w43 * w33; w82 := w33 * w81; w54 := w15^-2; w84 := 
    w21^-3; w85 := w54 * w84; w86 := w83 * w85; w36 := b^-3; w37 := a * w36;
    w39 := a * w38; w40 := w37 * w39; w41 := w35 * w40; w50 := w41^-1; w62 := 
    w24^-1; w89 := w50 * w62; w90 := w89^2; w91 := w88 * w90; w92 := w86 * w91; 
    w93 := w82 * w92; w44 := w19 * w36; w46 := a * w45; w47 := w44 * w46; w49 
    := w48 * w22; w51 := w49 * w50; w52 := w47 * w51; w53 := w43 * w52; w77 := 
    w53^-1; w94 := a * w17; w95 := w17 * w94; w96 := w19 * w95; w97 := a * 
    w18; w98 := w97 * w10; w99 := w96 * w98; w100 := w24^-2; w101 := w50 * w100;
    w102 := w54 * w101; w55 := w45 * w38; w56 := w54 * w55; w57 := w13 * w56; 
    w58 := w21^-2; w59 := w15^-5; w60 := w58 * w59; w61 := w57 * w60; w63 := w62
    * w50; w64 := w50 * w63; w66 := w64 * w65; w67 := w61 * w66; w68 := w33 * 
    w67; w103 := w68^-1; w104 := w93 * w103; w105 := w50 * w104; w106 := w89 * 
    w105; w107 := w102 * w106; w108 := w99 * w107; w109 := w81 * w108; w112 := 
    w77 * w109; w113 := w93 * w112; w114 := w88 * w113; w115 := w111 * w114; 
    w116 := w42 * w115; w174 := w116 * w53; w175 := w174 * w93; w176 := w175 * 
    w24; w177 := w176 * w41; w178 := w177 * w24; w179 := w178 * w24; w180 := 
    w179 * w41; w181 := w180 * w24; w182 := w181 * w41; w183 := w182 * w15; w184
    := w183 * w15; w185 := w184 * w15; w186 := w185 * w15; w187 := w186 * w15; 
    w188 := w187 * w21; w189 := w188 * w21; w190 := w189 * w15; w191 := w190 * 
    b; w192 := w191 * a; w193 := w192 * b; d := w193;

   return [c, d];

end function;
  
/* list of subgroups of O8p2 */

DataO8p2 := function ()

   F<a, b> := SLPGroup (2);
   
   L := [
   rec <SporadicRF | name := "O8p2", generators := [a, b], 
       order := 4952179814400>,
   rec <SporadicRF | name := "2^6:A8", parent := "O8p2", generators := 
        GeneratorsO8p2Max1(a,b), order := 1290240, index := 135>
   ];
   return L;
   
end function;
