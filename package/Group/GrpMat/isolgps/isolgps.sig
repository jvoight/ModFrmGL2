174,1
S,IsolMinBlockSize,"The minimum block size of IsolGroup(n, p, i)",0,3,0,0,0,0,0,0,0,148,,0,0,148,,0,0,148,,148,-38,-38,-38,-38,-38
S,IsolIsPrimitive,"True if and only if IsolGroup(n, p, i) is primitive",0,3,0,0,0,0,0,0,0,148,,0,0,148,,0,0,148,,36,-38,-38,-38,-38,-38
S,IsolOrder,"The order of IsolGroup(n, p, i)",0,3,0,0,0,0,0,0,0,148,,0,0,148,,0,0,148,,148,-38,-38,-38,-38,-38
S,IsolGuardian,"The maximal IsolGroup containing IsolGroup(n, p, i)",0,3,0,0,0,0,0,0,0,148,,0,0,148,,0,0,148,,178,-38,-38,-38,-38,-38
S,IsolInfo,"Information string about IsolGroup(n, p, i)",0,3,0,0,0,0,0,0,0,148,,0,0,148,,0,0,148,,298,-38,-38,-38,-38,-38
S,IsolNumberOfDegreeField,The number of Isol groups of degree n over GF(p) in the database,0,2,0,0,0,0,0,0,0,148,,0,0,148,,148,-38,-38,-38,-38,-38
S,IsolGroup,Group number i of degree n over GF(p) in the IsolGroup database,0,3,0,0,0,0,0,0,0,148,,0,0,148,,0,0,148,,178,-38,-38,-38,-38,-38
S,Getvecs,"Vectors of the underlying vector space for G, in sequence suitable for use by Semidir",0,1,0,0,0,0,0,0,0,178,,151,-38,-38,-38,-38,-38
S,Semidir,"Given: An irreducible matrix group G, and A specially ordered sequence Q of the vectors in RSpace(G). Return: The image H of the natural permutation representation of the 	semidirect product of G with its natural submodule generated by 	the vector (0, ..., 0, 1)",0,2,0,0,0,0,0,0,0,82,,0,0,178,,224,-38,-38,-38,-38,-38
S,Semidir,"Given: An irreducible matrix group G, and A specially ordered indexed set Q of the vectors in RSpace(G). Return: The image H of the natural permutation representation of the 	semidirect product of G with its natural submodule generated by 	the vector (0, ..., 0, 1)",0,2,0,0,0,0,0,0,0,151,,0,0,178,,224,-38,-38,-38,-38,-38
S,IsolGroupSatisfying,A group from the Isol Group database satisfying the predicate f,0,1,0,0,0,0,0,0,0,-1,,178,-38,-38,-38,-38,-38
S,IsolGroupsSatisfying,The groups in the Isol Group database satisfying the predicate f,0,1,0,0,0,0,0,0,0,-1,,82,-38,-38,-38,-38,-38
S,IsolGroupOfDegreeSatisfying,A group of degree n from the Isol Group database satisfying the predicate f,0,2,0,0,0,0,0,0,0,-1,,0,0,148,,178,-38,-38,-38,-38,-38
S,IsolGroupsOfDegreeSatisfying,The groups of degree n in the Isol Group database satisfying the predicate f,0,2,0,0,0,0,0,0,0,-1,,0,0,148,,82,-38,-38,-38,-38,-38
S,IsolGroupOfDegreeFieldSatisfying,A group of degree n over GF(p) from the Isol Group database satisfying the predicate f,0,3,0,0,0,0,0,0,0,-1,,0,0,148,,0,0,148,,178,-38,-38,-38,-38,-38
S,IsolGroupsOfDegreeFieldSatisfying,The groups of degree n over GF(p) from the Isol Group database satisfying the predicate f,0,3,0,0,0,0,0,0,0,-1,,0,0,148,,0,0,148,,82,-38,-38,-38,-38,-38
S,IsolProcess,Process to search through all Isol Groups in the database,0,0,0,0,0,0,0,255,-38,-38,-38,-38,-38
S,IsolProcessOfDegree,Process to search through all Isol Groups in the database with either degree equal to n,0,1,0,0,0,0,0,0,0,148,,255,-38,-38,-38,-38,-38
S,IsolProcessOfDegree,Process to search through all Isol Groups in the database with degree in the range specified,0,1,0,0,0,0,0,0,0,303,,255,-38,-38,-38,-38,-38
S,IsolProcessOfField,Process to search through all Isol Groups in the database with field as specified,0,1,0,0,0,0,0,0,0,-1,,255,-38,-38,-38,-38,-38
S,IsolProcessOfDegreeField,Process to search through all Isol Groups in the database with degree and field as specified,0,2,0,0,0,0,0,0,0,-1,,0,0,-1,,255,-38,-38,-38,-38,-38
S,IsolProcessIsEmpty,Returns true if the Isol Group process tuple has passed its last group,0,1,0,0,0,0,0,0,0,303,,36,-38,-38,-38,-38,-38
S,IsolProcessGroup,Extract current group from Isol process,0,1,0,0,0,0,0,0,0,303,,178,-38,-38,-38,-38,-38
S,IsolProcessLabel,Label of current group from Isol process,0,1,0,0,0,0,0,0,0,303,,148,148,148,-38,-38,-38
S,IsolProcessInfo,Info string of current group of Isol process,0,1,0,0,0,0,0,0,0,303,,298,-38,-38,-38,-38,-38
S,IsolProcessNext,Advance Isol process to next group,0,1,0,0,1,0,0,1,1,303,,-38,-38,-38,-38,-38,-38
