freeze;
// BestKnownLinearCodes DataBase for GF(7)
// insert useful info here

q    := 7;
MAXN := 100;
Div1 := 20;
Div2 := 30;
ConstructionEnum := [
"trivial",// 1
"dual-all-1",// 2
"shorten",// 3
"residue",// 4
"ConstaCyclic",// 5
"constructionB",// 6
"subcode",// 7
"puncture",// 8
"AG_divisor",// 9
"gen",// 10
"quasicyclic",// 11
"concatenation",// 12
"cyclic",// 13
"extend",// 14
"QR",// 15
"X",// 16
"quasicyclic_stack",// 17
"quasitwistedcyclic",// 18
"XL",// 19
"Dual",// 20
"lengthening",// 21
"constructionB2",// 22
"add_column",// 23
"ToricCode",// 24
"XX",// 25
"BCH",// 26
"Hamming",// 27
"ExtendedGoppa_nested",// 28
"PG",// 29
"ExtendedGoppa",// 30
"SubfieldSubcode",// 31
"sum",// 32
"SubcodeBetweenCode",// 33
"BZ",// 34
"Curve",// 35
"AGDivDeg1",// 36
"MDS"//37
];

GF7ConstructionEnum := ConstructionEnum;
GF7MAXN := MAXN;



GF7Index := [
\[0],
\[57,114],
\[171,228,285],
\[342,399,474,531],
\[588,645,720,795,852],
\[909,966,1041,1116,1191,1248],
\[1305,1362,1437,4399,4474,4549,4606],
\[4663,4720,4795,4870,4963,5038,5113,5170],
\[5227,5284,5359,5434,5509,5584,5659,5734,5791
],
\[5848,5905,5980,6055,6130,6205,6280,6355,6430
,6487],
\[6544,6601,6676,6751,6826,6901,6976,7051,7126
,7201,7258],
\[7315,7372,7447,7522,7597,7672,7747,7822,7897
,7972,8047,8104],
\[8161,8218,8293,8368,8443,8825,8900,8975,9050
,9125,9200,9275,9332],
\[9389,9446,9521,9596,9924,9999,10074,10209,10284
,10359,10434,10509,10584,10641],
\[10698,10755,10830,11109,11184,11259,11334,11409,11484
,11951,12026,12101,12176,12251,12308],
\[12365,12422,12515,12590,12665,12740,12815,12890,12965
,13040,13115,13190,13265,13340,13415,13472],
\[13529,13586,13661,13736,13811,13886,13961,14036,14111
,14186,14261,14336,14411,14486,14561,14636,14693],
\[14750,14807,14882,14957,15032,15183,15336,15411,15486
,15561,15636,15711,15786,16270,16345,16420,16495,16552
],
\[16609,16666,16741,16816,16891,16966,17096,17171,17246
,17321,17425,18171,18246,18321,18396,18471,18546,18621
,18678],
\[18735,18792,18867,18942,19113,19411,19486,19709,19936
,20011,20088,20163,20238,20313,20388,20463,20538,20613
,20688,20745],
\[20802,20859,20934,21009,21084,21159,21320,21575,21693
,21768,21843,21918,21993,22136,22211,22286,22361,22436
,22511,22586,22643],
\[22700,22757,22832,23214,23289,23364,23439,23557,23632
,23707,23782,23857,23932,24007,24082,24157,24232,24307
,24382,24457,24532,24589],
\[24646,24703,24778,24853,24928,25003,25078,25153,25228
,25303,25378,25453,25528,25603,25678,25753,25828,25903
,25978,26053,26128,26203,26260],
\[26317,26374,26467,26542,26617,26955,27147,27314,27469
,27544,27619,27694,27866,27941,28089,28163,28238,28313
,28388,28463,28538,28613,28688,28745],
\[28802,28859,28934,29009,29204,29279,29354,29429,29547
,29622,29697,29772,29847,29922,29997,30072,30147,30222
,30297,30372,30447,30522,30597,30672,30729],
\[30786,30843,30918,30993,31266,31341,31416,31491,31566
,31641,31716,31791,31866,31941,32016,32091,32166,32241
,32316,32391,32466,32541,32616,32691,32766,32823],
\[32880,32937,33012,33087,33401,33476,33551,33724,34123
,34531,34606,34681,34756,34831,34906,34981,35056,35131
,35214,35289,35364,35439,35514,35589,35664,35739,35796
],
\[35853,35910,35985,36060,36135,36480,36555,36630,36748
,36866,37534,37609,37684,37759,37834,37909,37984,38059
,38134,38209,38284,38359,38434,38509,38584,38659,38734
,38791],
\[38848,38905,38980,39465,39540,39930,40005,40179,40254
,40329,40404,40479,40554,40629,40704,40779,40854,40929
,41004,41079,41154,41229,41304,41379,41454,41529,41604
,41679,41736],
\[41793,41850,41925,42000,42075,42473,42548,42623,42767
,42906,42981,43056,43131,43206,43281,43356,43431,43506
,43581,43669,43744,43819,43894,43969,44044,44119,44194
,44269,44344,44401],
\[44458,44515,44590,44665,44740,44815,44890,44965,45040
,45115,45190,45265,45340,45415,45490,45565,45669,45744
,45819,45894,45969,46044,46119,46194,46269,46344,46419
,46494,46569,46644,46701],
\[46758,46815,46908,46983,47206,47281,47504,47781,48212
,48433,48570,48891,49116,49191,49266,49341,49418,49493
,49568,49643,49718,49795,49870,49945,50020,50095,50170
,50245,50320,50395,50470,50527],
\[50584,50641,50716,50791,50960,51035,51529,51604,51722
,51797,51942,52017,52092,52167,52242,52317,52392,52467
,52542,52617,52692,52767,52842,52917,52992,53067,53142
,53217,53292,53367,53442,53517,53574],
\[53631,53688,53763,53838,53913,53988,54063,54138,54213
,54288,54363,54438,54513,54588,54663,54738,54813,55046
,55121,55196,55271,55346,55421,55496,55571,55646,55721
,55796,55871,55946,56021,56096,56171,56228],
\[56285,56342,56417,56492,56567,58321,58396,61341,61416
,61491,61566,61641,61716,61791,61866,61941,64521,64596
,64671,64746,64821,64896,64971,65046,65121,65196,65271
,65346,66567,66642,66717,66792,66867,66942,66999],
\[67056,67113,67188,67774,67849,68307,68382,68738,68932
,69007,69689,70371,70762,71444,71818,72209,72891,73570
,75158,76807,76882,76957,77032,77107,77182,77257,77332
,77407,77482,77557,77632,77707,77782,77857,77932,77989
],
\[78046,78103,78178,78253,78328,78403,78478,78553,78628
,78703,78778,78853,78928,79003,79078,80308,80383,80458
,80533,80608,80683,80758,80833,80908,80983,81058,81133
,81256,81331,81406,81481,81556,81631,81706,81781,81856
,81913],
\[81970,82027,82102,82177,82252,82327,82577,82652,82806
,83170,83652,83727,83979,84054,84129,84204,84279,84354
,84429,84504,84579,84654,84729,84804,84879,84954,85029
,85104,85181,85256,85331,85406,85481,85556,85631,85706
,85781,85838],
\[85895,85952,86027,86102,86177,86252,86327,86402,86477
,86552,86667,86742,87001,87153,87228,87303,87378,87453
,87528,87603,87678,87753,87828,87903,87978,88053,88128
,88203,88278,89148,89223,89298,89373,89448,89523,89598
,89673,89748,89805],
\[89862,89919,90012,90087,90296,90669,90744,90819,90894
,90969,91128,91283,91358,91433,91598,91673,91748,91823
,91898,91973,92148,92223,92298,92373,92448,92523,92598
,92673,92748,92823,93713,93788,93863,93938,94013,94088
,94163,94238,94313,94370],
\[94427,94484,94559,94634,94709,94827,94902,94977,95052
,95127,95202,95277,95352,95427,95502,95577,95652,95727
,95802,95877,95952,96027,96102,96177,96252,96327,96402
,96477,96552,96627,96702,97612,97687,97762,97837,97912
,97987,98062,98137,98212,98269],
\[98326,98383,98458,98533,98754,99274,99495,99570,99645
,99720,99795,99870,99945,100020,100095,100170,100245,100320
,100395,100470,100545,100620,100695,100770,100845,100920,100995
,101070,101145,101220,101295,101370,101445,101520,101595,101670
,101792,101867,101989,102064,102139,102196],
\[102253,102310,102385,102460,102535,102610,103224,103470,103545
,103620,103695,103770,103845,103920,103995,104070,104145,104220
,104295,104370,104445,104520,104595,104670,104745,104820,104895
,104970,105045,105120,105195,105270,105345,105420,105495,105570
,105726,105801,105876,105951,106026,106101,106158],
\[106215,106272,106347,106422,106497,106572,106647,106722,106797
,106872,106947,107022,107097,107172,107247,107322,107397,107472
,107547,107622,107697,107772,107847,107922,107997,108072,108147
,108222,108297,108372,108447,108522,108597,108672,108747,108822
,108897,108972,109087,109162,109237,109312,109387,109444],
\[109501,109558,109633,109708,109783,110065,110140,110215,110290
,110365,110440,110515,110590,110665,110740,110815,110890,110965
,111040,111115,111190,111265,111340,111415,111490,111565,111640
,111715,111790,111865,111940,112015,112090,112165,112240,112315
,112390,112465,112540,112615,112690,112765,112840,112915,112972
],
\[113029,113086,113161,113236,113311,113871,113946,114021,114096
,114171,114246,114321,114396,114471,114546,114621,114696,114771
,114846,114921,114996,115071,115146,115221,115296,115371,115446
,115521,115596,115671,115746,115821,115896,115971,116046,116121
,116196,116271,116346,116421,116496,116571,116646,116721,116796
,116853],
\[116910,116967,117042,117117,117192,117760,117835,117910,117985
,118060,118135,118210,118285,118360,118435,118510,118585,118660
,118735,118810,118885,118960,119035,119110,119185,119260,119335
,119410,119485,119560,119635,119710,119785,119860,119935,120010
,120085,120160,120235,120310,120385,120460,120535,120610,120685
,120760,120817],
\[120874,120931,121006,121081,121528,122153,123240,123598,124253
,124670,124953,125470,126127,126520,126951,127536,128211,129080
,129347,130030,130381,131130,131557,131934,132305,132544,132823
,132898,133412,133487,134117,134262,134857,135130,135505,135890
,136085,136368,136499,136762,136837,137104,137179,137377,137452
,137527,137602,137659],
\[137716,137773,137848,138215,138290,138365,138559,138634,138709
,138784,138859,138934,139049,139124,139199,139274,139349,139464
,139539,139614,139689,139764,139839,139914,139989,140064,140139
,140214,140289,140364,140439,140514,140589,140664,140739,140814
,140889,140964,141039,141114,141189,141264,141339,141414,141489
,141564,141639,141714,141771],
\[141828,141924,142056,142170,143337,143787,143936,144087,144201
,144433,144796,146043,146479,146670,146820,146934,147348,147462
,147576,147726,147840,148048,148162,148313,148427,148627,148778
,148892,149109,149223,149374,149488,149685,149799,149950,150064
,150243,150357,150630,150781,150895,151063,152044,152195,152309
,152423,152682,152799,152913,153009],
\[153105,153162,153431,153799,153874,153949,154024,154099,154251
,154326,154401,154476,154551,154626,154701,154853,154928,155080
,155155,155230,155305,155380,155532,155607,155759,155834,155909
,155984,156059,156134,156209,156284,156359,156434,156509,156661
,156736,156851,156926,157001,157076,157151,157263,157338,157413
,157488,157563,157638,157713,157788,157845],
\[157902,157959,158034,158109,158184,158802,158877,158952,159027
,159102,159177,159252,159327,159402,159517,159592,159667,159742
,159817,159969,160044,160196,160271,160423,160538,160613,160688
,160763,160915,160990,161142,161217,161369,161444,161596,161711
,161786,161861,162013,162088,162163,162315,162390,162465,162540
,162615,162690,162765,162840,162915,162990,163047],
\[163104,163161,163236,163311,163386,164581,165285,165360,166328
,166480,166555,166630,166705,168203,168278,168430,168582,168697
,168812,168887,168962,169077,171501,171576,171651,171803,172011
,172215,172290,172365,172440,172515,172630,174842,174957,175032
,175184,175259,175334,175409,175484,175559,175634,175709,176749
,176824,176899,176974,177049,177124,177199,177274,177331],
\[177388,177445,177520,177595,177670,178308,179056,179131,179206
,179281,179356,179431,179506,179581,179656,179731,179806,179881
,180033,180108,180183,182543,182695,182770,182845,182920,182995
,183109,183184,183259,183334,183409,185877,185952,186027,186243
,186380,186455,186530,186605,186680,186755,186830,186905,186980
,187055,187130,187205,187280,187355,187430,187505,187580,187637
],
\[187694,187751,187826,187901,187976,188051,188126,188201,188276
,188351,188550,188625,188700,188775,188850,188925,189037,189112
,189187,189262,189337,189412,189487,189639,189714,189826,189901
,189976,190051,190126,190201,190276,190351,190426,190578,190653
,190773,190848,190923,190998,191073,191148,191223,191298,192600
,192675,192750,192825,192900,192975,193050,193125,193200,193275
,193332],
\[193389,193446,193516,193591,194107,194766,195536,195611,195686
,195761,195968,196043,196118,196193,196268,196343,196418,196493
,196568,196643,196718,196793,196868,196943,197053,197128,197203
,197278,197353,197428,197503,197578,197653,197728,197803,197878
,197953,198028,198103,198178,198253,198328,198403,198478,198553
,198628,198703,198778,198853,198928,199003,199078,199153,199228
,199303,199360],
\[199417,199474,199549,199624,199841,199916,200102,200541,200693
,201262,201683,201835,202789,202988,203063,203913,204298,204373
,204896,205727,206102,206499,206998,207448,207834,208009,208084
,208159,208234,208493,208721,208928,209217,209717,209994,210268
,210615,210722,210901,211004,211079,211154,211251,211326,211419
,211510,211585,211728,211803,211878,212059,212134,212209,212328
,212504,212579,212636],
\[212693,212750,212825,212900,213429,213504,214298,214683,215021
,215096,215171,215285,215360,215435,215714,215911,215986,216061
,216136,216211,216286,216361,216608,216829,216904,217019,217094
,217169,217244,217319,217394,217469,217544,217619,217694,217769
,217844,217919,217994,218069,218144,218219,218386,218549,218624
,218699,218774,218849,218924,218999,219074,219151,219226,219301
,219376,219451,219526,219583],
\[219640,219697,219772,219847,219922,220612,221418,222344,222459
,222534,222609,222684,222759,222834,222909,222984,223099,223174
,223249,223324,223399,223474,223549,223624,223699,223774,223849
,223924,223999,224225,224445,224520,224595,224670,224745,224857
,224932,225007,225082,225157,227491,227566,227641,227753,227828
,227903,227978,228053,228128,228203,228278,228353,228428,228503
,228578,228653,228728,228803,228860],
\[228917,228974,229049,229124,229702,230400,231218,231293,231679
,231883,232267,232461,232671,232871,232946,233021,233231,233423
,233615,233690,233765,233840,233915,234184,234694,235045,235396
,235630,235705,235780,235894,236046,236158,236273,236385,236460
,236575,236650,236725,236800,236875,236950,237025,237100,237175
,237250,237325,237400,237475,237550,237662,237737,237812,237887
,237962,238037,238112,238187,238262,238319],
\[238376,238433,238508,238583,239169,239244,239319,239394,239469
,239584,239659,239734,239809,239884,241712,241824,241899,241974
,242049,242164,242239,242314,242429,242504,242619,242694,242769
,242884,242959,243034,243109,243184,243296,243371,243446,243544
,243619,243694,243809,243884,243959,244034,244109,244184,244259
,244334,244409,244484,244559,244634,244709,244784,244859,244971
,245046,245121,245196,245271,245346,245421,245478],
\[245535,245592,245667,245742,246016,246735,247578,247653,247728
,247880,247995,248070,248185,248297,248372,248565,248921,248996
,249111,249226,249301,249416,249491,249603,249718,249833,249908
,249983,250058,250133,250208,250337,250412,250487,250562,250637
,250712,250787,250862,250937,251012,251087,251162,251237,251312
,251387,251462,251537,251612,251687,251762,251837,251912,251987
,252062,252137,252212,252287,252362,252437,252512,252569],
\[252626,252683,252758,252833,252908,252983,253058,253170,253245
,253320,253395,253470,253545,253754,255806,256433,257018,257093
,257793,258325,258568,258643,258758,258833,262035,265421,265496
,265629,265704,265779,265854,269996,270071,274145,274290,274597
,274788,274989,278501,278702,278903,278978,279179,279254,279455
,279656,279857,280058,280259,280460,280535,280610,280685,280760
,280835,280910,280985,281060,281135,281210,281285,281360,281417
],
\[281474,281531,281601,281676,281926,282682,283244,284366,284915
,285454,285664,286376,286758,287187,287742,287937,288049,288580
,288777,289144,289504,290844,292881,294332,297270,300686,303312
,305055,305413,306772,308397,308472,313018,313093,313168,313243
,317005,317080,317155,317230,317305,317380,317455,317530,317605
,317680,317954,318029,318303,318378,318453,318528,318603,318678
,318753,318828,318903,318978,319053,319128,319203,319278,319353
,319410],
\[319467,319524,319599,319674,319749,319867,320745,320863,320938
,321013,321125,321200,321412,321626,321738,321850,321925,324198
,324310,324422,324534,324609,324724,324799,325035,325150,325265
,325380,325455,325530,325645,329737,329812,329924,329999,330111
,330186,330261,330373,330448,330523,330598,330673,330748,330823
,330898,330973,331048,331123,331198,331273,331348,331423,331498
,331573,331648,331723,331798,332798,332873,332948,333023,333098
,333173,333230],
\[333287,333344,333419,333877,334123,334881,334956,335031,335185
,335299,335520,335632,335707,337543,339511,339625,339700,339775
,339887,340002,340387,340944,341352,344544,344659,344734,344886
,344998,345073,345188,345263,346364,346905,347355,347430,347505
,347580,347655,347730,347805,347880,347955,348030,348105,348180
,348255,348330,348405,348480,348555,348630,348705,348780,348855
,348930,349005,349080,349155,349230,350249,350324,350399,350474
,350549,350624,350681],
\[350738,350795,350870,350945,351020,351095,351998,352113,352237
,352356,352431,352506,352658,352767,352916,352991,353066,353141
,353216,353291,353366,353481,353596,353711,353826,353938,354053
,354168,354243,354318,354393,354468,354581,354656,354768,354843
,354955,355030,355142,355217,355292,355367,355442,355517,355592
,355667,355742,355817,355892,355967,356042,356117,356192,356267
,356342,356417,356492,356567,357859,357934,358009,358084,358159
,358234,358309,358384,358441],
\[358498,358555,358630,358705,359347,360126,360201,360353,360428
,360503,360578,360702,360821,360940,361015,361167,361378,361563
,361784,361859,361934,362009,362084,362199,362348,362463,362615
,362764,362839,362914,363029,363104,363436,363551,363944,364056
,364131,364206,364281,364356,364431,364506,364581,364656,364731
,364806,364881,364956,365031,365106,365181,365256,365331,365406
,365481,365556,365631,365706,365781,365856,365931,366006,366081
,366156,366231,366306,366381,366438],
\[366495,366552,366627,366702,366777,366852,366927,367991,368066
,368141,368216,368328,368403,368478,370530,370605,370680,370755
,370830,370905,370980,371055,371268,371343,371458,371610,371725
,371840,371955,372030,372105,372180,372255,372330,372405,372480
,372592,372667,372742,372817,372892,372967,373042,373117,373192
,373267,373342,373417,373492,373567,373642,373717,373792,373867
,373942,374017,374092,374167,374242,374317,374392,374467,374542
,374617,374692,374767,374842,374917,374974],
\[375031,375088,375163,375238,375313,375388,376543,377007,377082
,377157,377232,377307,377525,377747,377822,377897,377972,378047
,378122,378197,378272,378347,378422,378497,378572,378647,378799
,378951,379029,379144,379219,379294,379369,379521,379596,379655
,379730,379805,379880,379955,380030,380105,380180,380255,380330
,380405,380480,380555,380630,380705,380780,380855,380930,381005
,381080,381155,381230,381305,381380,381455,381530,381605,381680
,382724,382799,382874,382949,383024,383099,383156],
\[383213,383270,383345,383420,383495,383570,384520,384635,384710
,384785,384860,384935,385010,385085,385160,385235,385310,385385
,385460,385535,385610,385725,385800,385875,385950,386025,386140
,386255,386330,386405,386557,386632,386707,386782,386897,386972
,387047,387122,387197,387272,387347,387422,387497,387572,387647
,387722,387797,387872,387947,388022,388097,388172,388247,388322
,388397,388472,388547,388622,388697,388772,388847,388922,388997
,389072,389147,389222,389297,389372,389447,389522,389579],
\[389636,389693,389765,390028,390434,390702,391146,391588,392035
,392445,392663,392879,393106,393519,393923,394699,395126,395201
,395276,395351,395426,395501,395576,395651,395726,395801,395953
,396028,396103,396255,396370,396579,396790,396865,396940,397015
,397090,397165,397240,397315,397390,397465,397540,397615,397690
,397765,397840,397915,397990,398065,398140,398215,398290,398365
,398440,398515,398590,398665,398740,398815,398890,398965,399040
,399115,399190,399265,399340,399415,399490,399565,399640,399697
],
\[399754,399811,399886,399961,400073,400148,401123,401238,401313
,401388,401463,401538,401613,401688,401763,401875,401950,402025
,402100,402175,402250,402325,402400,402475,402774,403069,403218
,403293,403368,403443,403595,403670,403745,403820,403895,403970
,404029,404104,404179,404254,404329,404404,404479,404554,404629
,404704,404779,404854,404929,405004,405079,405154,405229,405304
,405379,405454,405529,405604,405679,405754,405829,405904,405979
,406054,406129,406204,406279,406354,406429,406504,406579,406654
,406711],
\[406768,406825,406900,407406,407481,407556,407631,407706,407781
,408372,408776,408851,408926,409001,409076,409151,409263,409338
,409555,409878,410197,410272,410347,410422,410497,410609,410684
,410759,410834,410986,411061,411136,411211,411286,411345,411420
,411495,411570,411645,411720,411795,411870,411945,412020,412095
,412170,412245,412320,412395,412470,412545,412620,412695,412770
,412845,412920,412995,413070,413145,413220,413295,413370,413445
,413520,413595,413670,413745,413820,413895,413970,414045,414120
,414195,414252],
\[414309,414366,414441,414516,414932,415348,415423,415498,415917
,415992,416067,416142,416556,417141,417578,417653,417728,417950
,418025,418100,418175,418353,418428,418503,418578,418653,418728
,418803,418878,418953,419028,419103,419178,419253,419328,419403
,419478,419553,419628,419703,419778,419853,419928,420003,420078
,420153,420228,420303,420378,420453,420528,420603,420678,420753
,420862,420937,421012,421087,421162,421237,421312,421387,421462
,421537,421612,421687,421762,421837,421912,421987,422062,422137
,422212,422287,422344],
\[422401,422458,422533,422608,422837,422912,423524,424885,425109
,425524,425636,426072,426299,426523,426755,427183,427609,427841
,429589,430577,430878,433189,435124,437205,439854,443686,445772
,447715,449651,451403,452187,452262,452337,452396,452471,452546
,452621,452696,452771,452846,452921,452996,453071,453146,453221
,453296,453371,453446,453521,453596,453671,453746,453821,453896
,453971,454046,454121,454196,454271,454346,454421,454496,454571
,454646,454721,454796,454871,454946,455021,455096,455171,455246
,455321,455396,455471,455528],
\[455585,455642,455717,455792,456507,456622,457645,458821,458896
,458971,459046,459121,459196,461317,461432,461507,461582,461657
,461732,461807,461882,461957,462072,462187,462302,462417,462532
,462607,462722,462837,462912,462971,463046,463121,463196,463271
,463346,463421,463480,463555,463630,463705,463780,463855,463930
,464005,464080,464155,464230,464305,464380,464455,464530,464605
,464680,464755,464830,464905,464980,465055,465130,465205,465280
,465355,465430,465505,465580,465655,465730,465805,465880,465955
,466030,466105,466180,466255,466312],
\[466369,466426,466501,466576,466651,467559,468560,468635,468710
,468785,468860,468935,469176,471324,471570,471811,471923,471998
,472073,472148,472223,472298,472413,472528,472803,472878,472993
,473421,473499,473614,473689,473764,473839,473914,473989,474064
,474123,474198,474273,474348,474423,474498,474573,474648,474723
,474798,474873,474948,475023,475098,475173,475248,475323,475398
,475473,475548,475623,475698,475773,475848,475923,475998,476073
,476148,476223,476298,476373,476448,476523,476598,476673,476748
,476823,476898,476973,477048,477123,477180],
\[477237,477294,477369,477444,477519,478407,478482,478557,478632
,478707,478782,478857,478932,479007,479082,479157,479232,479307
,479382,479457,479532,479607,479682,479757,479832,479907,479982
,480057,480132,480207,480282,480357,480432,480507,480566,480641
,480716,480791,480866,480941,481016,481091,481166,481241,481316
,481391,481466,481541,481616,481691,481766,481841,481916,481991
,482066,482141,482216,482291,482366,482441,482516,482591,482666
,482741,482816,482891,482966,483041,483116,483191,483266,483341
,483416,483491,483566,483641,483716,483791,483848],
\[483905,483962,484034,484109,484374,485272,486939,487402,488260
,488888,489319,490121,490727,490971,491216,491448,492076,492316
,493151,493582,494009,494838,495265,495694,495926,496001,496233
,496348,496423,496538,496613,496672,496747,496822,496897,496972
,497047,497122,497197,497256,497331,497406,497481,497556,497631
,497706,497781,497856,497931,498006,498081,498156,498231,498306
,498381,498456,498531,498606,498681,498756,498831,498906,498981
,499056,499131,499206,499281,499356,499431,499520,499595,499670
,499745,499820,499895,499970,500045,500120,500195,500252],
\[500309,500366,500441,500516,500591,500666,501766,501884,501998
,502116,502191,502266,502381,502456,502531,502606,502681,502756
,502831,502906,502981,503510,503744,503819,504138,504253,504328
,504403,504518,504670,504781,504856,504931,504990,505065,505140
,505215,505274,505349,505424,505499,505574,505649,505724,505799
,505874,505949,506024,506099,506174,506249,506324,506399,506474
,506549,506624,506699,506774,506849,506924,506999,507074,507149
,507224,507299,507374,507449,507524,507599,507674,507749,507824
,507899,507974,508049,508124,508199,508274,508349,508424,508481
],
\[508538,508595,508670,509224,509299,510247,511329,511404,511519
,511594,511709,511824,511899,514151,514226,516806,516881,516956
,517068,517180,517255,517370,517522,517637,517712,517787,517902
,517977,518092,518167,518282,518357,518432,518507,518582,518657
,518732,518807,518882,518957,519032,519107,519182,519257,519332
,519407,519482,519557,519632,519707,519782,519857,519932,520007
,520082,520157,520232,520307,520382,520457,520532,520607,520682
,520757,520832,520907,520982,521057,521132,521207,521282,521357
,521432,521507,521582,521657,521732,521807,521882,521957,522032
,522089],
\[522146,522203,522278,522353,522428,522503,523597,523672,523747
,523862,523937,524012,524087,524162,526606,526681,526756,526831
,526906,526981,527056,527131,527246,527361,527476,527591,527743
,527858,527933,528048,528123,528198,528257,528332,528407,528482
,528541,528616,528691,528766,528841,528916,528991,529066,529141
,529216,529291,529366,529441,529516,529591,529666,529741,529816
,529891,529966,530041,530116,530191,530266,530341,530416,530491
,530566,530641,530716,530791,530866,530941,531016,531091,531166
,531241,531316,531391,531466,531541,531616,531691,531766,531841
,531916,531973],
\[532030,532087,532162,532237,533018,533958,534033,534108,534612
,534876,535376,535451,535526,535601,536072,536756,537014,537089
,537975,538220,538904,539056,539171,539246,539398,539473,539548
,539623,539698,539773,539848,539923,539998,540073,540148,540223
,540298,540373,540448,540523,540598,540657,540732,540807,540882
,540957,541032,541107,541182,541257,541332,541407,541482,541557
,541632,541707,541782,541857,541932,542007,542082,542157,542232
,542307,542382,542457,542532,542607,542682,542757,542832,542907
,542982,543057,543132,543207,543282,543357,543432,543507,543582
,543657,543732,543789],
\[543846,543903,543978,544053,544128,545365,545440,545515,545590
,545665,547433,547508,547583,547658,547733,547845,548224,548599
,548674,548749,548824,548976,549091,549166,549241,549316,549468
,549543,549695,549770,549845,549904,549979,550054,550129,550188
,550263,550338,550413,550472,550547,550622,550697,550772,550847
,550922,550997,551072,551147,551222,551297,551372,551447,551522
,551597,551672,551747,551822,551897,551972,552047,552122,552197
,552272,552347,552422,552497,552572,552647,552722,552797,552872
,552947,553022,553097,553172,553247,553322,553397,553472,553547
,553622,553697,553772,553829],
\[553886,553943,554018,554093,554168,554243,554702,555150,555225
,555300,555415,555490,555729,555981,556056,556131,556206,556318
,556770,557225,557340,557415,557490,557565,558104,558559,558634
,558786,558861,558936,559088,559163,559238,559313,559388,559463
,559538,559597,559672,559747,559822,559897,559972,560047,560122
,560197,560272,560347,560422,560497,560572,560647,560722,560797
,560872,560947,561022,561097,561172,561247,561322,561397,561472
,561547,561622,561697,561772,561847,561922,561997,562072,562147
,562222,562297,562372,562447,562522,562597,562672,562747,562822
,562897,562972,563047,563122,563179],
\[563236,563293,563368,563443,563518,563593,564735,566271,566737
,566812,566941,567016,567091,567166,567641,568105,568219,568294
,568369,568444,568556,569025,569494,569569,569644,569759,569834
,569909,570061,570213,570288,570363,570438,570513,570572,570647
,570722,570797,570872,570947,571022,571097,571172,571247,571322
,571397,571472,571547,571622,571697,571772,571847,571922,571997
,572072,572147,572222,572297,572372,572447,572522,572597,572672
,572747,572822,572897,572972,573047,573122,573197,573272,573347
,573422,573497,573572,573647,573722,573797,573872,573947,574022
,574097,574172,574247,574322,574397,574454],
\[574511,574568,574640,574715,574790,575076,576492,576874,577150
,577225,577300,577575,579807,579882,579957,580032,580107,580182
,580257,580369,581065,581626,583011,588147,588262,588337,588412
,588527,588602,588713,588788,588847,588922,588997,589072,589147
,589206,589281,589356,589431,589506,589581,589656,589715,589790
,589865,589940,590015,590090,590165,590240,590315,590390,590465
,590540,590615,590690,590765,590840,590915,590990,591065,591140
,591215,591290,591365,591440,591515,591590,591665,591740,591815
,591890,591965,592040,592115,592190,592265,592340,592415,592490
,592565,592640,592715,592790,592865,592940,592997],
\[593054,593111,593186,593261,593336,593411,594577,595951,596070
,596145,596220,596295,596370,596445,596520,596632,596707,596782
,596894,596969,597044,597119,597234,597309,597384,597459,597518
,597577,597729,597804,597879,597954,598029,598088,598163,598238
,598313,598388,598463,598538,598613,598672,598747,598822,598897
,598972,599047,599122,599197,599272,599347,599422,599497,599572
,599647,599722,599797,599872,599947,600022,600097,600172,600247
,600322,600397,600472,600547,600622,600697,600772,600847,600922
,600997,601072,601147,601222,601297,601372,601447,601522,601597
,601672,601747,601822,601897,601972,602047,602122,602179],
\[602236,602293,602368,603536,604124,604687,604762,606142,606256
,606522,607508,608004,608735,609464,610425,611154,612132,614022
,614565,619385,619647,619762,620248,620363,620859,620970,621045
,621120,621195,621347,621406,621481,621556,621631,621706,621765
,621840,621915,621990,622068,622143,622218,622293,622368,622443
,622518,622593,622668,622743,622818,622893,622968,623043,623118
,623193,623268,623343,623418,623493,623568,623643,623718,623793
,623868,623943,624018,624093,624168,624243,624318,624393,624468
,624543,624618,624693,624768,624843,624918,624993,625068,625143
,625218,625293,625368,625443,625518,625593,625668,625743,625800
],
\[625857,625914,625989,626064,626139,627147,628367,628669,628744
,628819,628894,628969,629245,629357,629469,629581,629693,629805
,633149,633224,633299,633374,633449,633601,633676,633751,633826
,633901,633976,634051,634126,634201,634260,634335,634410,634485
,634560,634635,634710,634785,642170,642245,642320,642395,642454
,642529,642604,642679,642754,642829,642904,642979,643054,643129
,643204,643279,643354,643429,643504,643579,643654,643729,643804
,643879,643954,644029,644104,644179,644254,644329,644404,644479
,644554,644629,644704,644779,644854,644929,645004,645079,645154
,645229,645304,645379,645454,645529,645604,645679,645754,645829
,645886],
\[645943,646000,646075,646150,646302,646377,646452,646527,646602
,646677,646752,646901,649228,649303,649378,649453,649528,649640
,649752,649864,649988,650063,650178,650253,650328,650387,650446
,650505,650580,650655,650730,650805,650880,650955,651014,651089
,651164,651239,651298,651373,651448,659054,659113,659188,659263
,659338,659413,659488,659563,659638,659713,659788,659863,659938
,660013,660088,660163,660238,660313,660388,660463,660538,660613
,660688,660763,660838,660913,660988,661063,661138,661213,661288
,661363,661438,661513,661588,661663,661738,661813,661888,661963
,662038,662113,662188,662263,662338,662413,662488,662563,662638
,662713,662770],
\[662827,662884,662959,663034,663109,664137,664212,664287,664362
,664437,664512,664587,664662,664737,664849,665109,665591,665666
,665815,665930,666005,666080,666155,666230,666305,666457,666532
,666607,666682,666741,666800,666875,666950,667025,667100,667175
,667250,667325,667400,667475,674980,675055,675130,675205,675280
,675355,675430,675505,675580,675655,675730,675805,675880,675955
,676030,676105,676180,676255,676330,676405,676480,676555,676630
,676705,676780,676855,676930,677005,677080,677155,677230,677305
,677380,677455,677530,677605,677680,677755,677830,677905,677980
,678055,678130,678205,678280,678355,678430,678505,678580,678655
,678730,678805,678862],
\[678919,678976,679051,679126,679201,680269,680344,680419,680494
,680569,680644,680719,680794,680869,680944,681019,681094,681169
,681244,681319,681394,681469,681544,681619,681734,681809,681884
,681959,682034,682109,682184,682259,682318,682393,682468,682543
,682618,682677,682752,682827,682902,682977,683052,683127,683202
,683277,683352,683427,683502,683577,683652,683727,683802,683877
,683952,684027,684102,684177,684252,684327,684402,684477,684552
,684627,684702,684777,684852,684927,685002,685077,685152,685227
,685302,685377,685452,685527,685602,685677,685752,685827,685902
,685977,686052,686127,686202,686277,686352,686427,686502,686577
,686652,686727,686802,686859],
\[686916,686973,687048,687123,687198,687273,687348,687628,687703
,687983,688058,688133,688403,688478,688553,688628,688703,688778
,689295,689751,689826,689901,689976,690051,690126,690185,690244
,690303,690362,690437,690512,690587,690662,690737,690796,690871
,690946,691021,691096,691155,691230,691305,691380,691455,691530
,691605,691664,691739,691814,691889,691964,692039,692114,692189
,692264,692339,692414,692489,692564,692639,692714,692789,692864
,692939,693014,693089,693164,693239,693314,693389,693464,693539
,693614,693689,693764,693839,693914,693989,694064,694139,694214
,694289,694364,694439,694514,694589,694664,694739,694814,694889
,694964,695039,695114,695189,695246],
\[695303,695360,695432,695507,695582,697112,697863,698622,699368
,699634,700350,701079,701385,702112,702845,703574,703856,704116
,704191,704546,704621,705858,706373,707852,707927,708002,708077
,708152,708227,708302,708361,708436,708511,708586,708661,708736
,708795,708870,708945,709020,709095,709170,709245,709320,709379
,709454,709529,709604,709679,709754,709829,709904,709979,710054
,710129,710204,710279,710354,710429,710504,710579,710654,710729
,710804,710879,710954,711029,711104,711179,711254,711329,711404
,711479,711554,711629,711704,711779,711854,711929,712004,712079
,712154,712229,712304,712379,712454,712529,712604,712679,712754
,712829,712904,712979,713054,713129,713186],
\[713243,713300,713375,713450,713525,713600,713675,713790,713865
,713940,714015,714090,714205,714280,714395,714510,714585,714660
,714735,714810,714885,714960,715035,715150,715225,715300,715375
,715450,715525,715600,715675,715750,715809,715868,715943,716018
,716093,716168,716227,716302,716377,716452,716511,716586,716661
,716736,716811,716886,716961,717036,717111,717186,717261,717336
,717411,717486,717561,717636,717711,717786,717861,717936,718011
,718086,718161,718236,718311,718386,718461,718536,718611,718686
,718761,718836,718911,718986,719061,719136,719211,719286,719361
,719436,719511,719586,719661,719736,719811,719886,719961,720036
,720111,720186,720261,720336,720411,720486,720543],
\[720600,720657,720732,720814,721425,722052,722170,723642,723717
,723792,723867,723942,724017,724305,724380,724455,724530,724605
,724680,724755,724830,724905,724980,725095,725154,725213,725272
,725331,725390,725465,725540,725615,725690,725765,725840,725899
,725974,726049,726124,726199,726274,726349,726424,726499,726574
,726649,726724,726783,726858,726933,727008,727083,727158,727233
,727308,727383,727458,727533,727608,727683,727758,727833,727908
,727983,728058,728133,728208,728283,728358,728433,728508,728583
,728658,728733,728808,728883,728958,729033,729108,729183,729258
,729333,729408,729483,729558,729633,729708,729783,729858,729933
,730008,730083,730158,730233,730308,730383,730458,730515],
\[730572,730629,730704,730779,730854,730929,731004,731079,731154
,731229,731304,731419,731494,731569,731644,731759,731834,731909
,731984,732059,732134,732209,732284,732399,732474,732549,732624
,732699,732774,732849,732908,732967,733042,733117,733192,733267
,733342,733401,733476,733551,733626,733685,733760,733835,733910
,733969,734044,734119,734194,734269,734344,734419,734494,734569
,734644,734719,734794,734869,734944,735019,735094,735169,735244
,735319,735394,735469,735544,735619,735694,735769,735844,735919
,735994,736069,736144,736219,736294,736369,736444,736519,736594
,736669,736744,736819,736894,736969,737044,737119,737194,737269
,737344,737419,737494,737569,737644,737719,737794,737869,737926
],
\[737983,738040,738115,738190,738674,739021,739577,739692,739976
,740250,740524,740813,741338,741830,742361,742641,743160,743440
,744206,744493,745252,745532,745802,745917,745976,746035,746094
,746153,746212,746271,746330,746389,746464,746523,746582,746641
,746700,746759,746834,746893,746952,747011,747086,747145,747204
,747263,747338,747397,747498,747573,747674,747749,747850,747925
,748026,748101,748202,748277,748378,748453,748554,748629,748730
,748805,748906,748981,749082,749157,749258,749333,749434,749509
,749610,749685,749786,749861,749962,750037,750138,750213,750314
,750389,750490,750565,750666,750741,750842,750917,751018,751093
,751194,751279,751380,751461,751536,751613,751690,751765,751840
,751897],
\[751954]];
