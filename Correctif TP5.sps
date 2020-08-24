* Encoding: UTF-8.

* Chargement de la base de données. Il faut modifier le chemin du fichier, selon votre ordinateur.
GET
  FILE='Z:\EVS.sav'.
DATASET NAME DataSet1 WINDOW=FRONT.


* EXEMPLE.
* Sélection des ressortissants belges (menu DATA -> Select cases -> If condition is satisfied).
* Ensuite, on a deux options :

* a) Soit on sélectionne les individus pour lesquels la variable "country" a la valeur 56.
USE ALL.
COMPUTE filter_$=(country = 56).
VARIABLE LABELS filter_$ 'country = 56 (FILTER)'.
VALUE LABELS filter_$ 0 'Not Selected' 1 'Selected'.
FORMATS filter_$ (f1.0).
FILTER BY filter_$.
EXECUTE.

* b) Soit on sélectionne les individus pour lesquels la variable "c_abrv" (le code du pays) est "BE" (ne pas oublier de mettre la modalité entre guillemets).
USE ALL.
COMPUTE filter_$=(c_abrv = "BE").
VARIABLE LABELS filter_$ 'c_abrv = "BE" (FILTER)'.
VALUE LABELS filter_$ 0 'Not Selected' 1 'Selected'.
FORMATS filter_$ (f1.0).
FILTER BY filter_$.
EXECUTE.

* L'analyse de classification (Menu ANALYZE -> Classify -> Hierarchical Cluster.
* Dans l'onglet "Variables" on met les cinq variables d'intérêt.
* Dans "Statistics" on laisse l'option "Agglomeration Matrix" cochée.
* On demande une "Range of solutions", par exemple de 2 à 4 clusters.
* Dans "Plots" on sélectionne la Dendrogramme, mais on déselectionne le "Icicle Plot" (qui prend beaucoup de ressources et n'apporte pas plus d'informations que la "Agglomeration Matrix".
* Dans "Method" on sélectionne "Ward" comme "Cluster Method".
* Dans "Save" on demande la même "Range of solutions" que dans l'onglet "Statistics".
CLUSTER   v136 v138 v139 v145 v146
  /METHOD WARD
  /MEASURE=SEUCLID
  /PRINT SCHEDULE CLUSTER(2,4)
  /PLOT DENDROGRAM
  /SAVE CLUSTER(2,4).

* Lisant la Agglomeration Matrix, on observe que :
* A l'étape 1489 les individus ont été groupés en 4 groupes, avec un coefficient de Ward de 1658. Le rapport des coefficients de Ward par rapport à l'étape précédente est de 1658/1459 = 1.14.
* A l'étape 1490 les individus ont été groupés en 3 groupes, avec un coefficient de Ward de 1879. Le rapport des coefficients de Ward par rapport à l'étape précédente est de 1879/1658 = 1.13.
* A l'étape 1491 les individus ont été groupés en 2 groupes, avec un coefficient de Ward de 2221. Le rapport des coefficients de Ward par rapport à l'étape précédente est de 2221/1879 = 1.18.
* A l'étape 1492 les individus ont été groupés en 1 groupe, avec un coefficient de Ward de 2825. Le rapport des coefficients de Ward par rapport à l'étape précédente est de 2825/2221 = 1.27.
* Dans ces conditions, il semble que le "saut" du coefficient de Ward est plus grand après l'étape 1490 (1.18 à l'étape 1491, comparé à 1.13 et à 1.14 avant). On va donc s'arrêter à un regroupement des individus en 3 groupes (étape 1490).

* Lisant la Dendrogramme on observe la même chose : la solution la plus judicieuse (celle qui évite des lignes horizontales trop longues) est celle qui regroupe les individus en trois groupes.

* On va garder donc la solution à trois groupes (donc la nouvelle variable CLU3)

* L'analyse univariée de cette nouvelle variable, qui regroupe l'échantillon belge en trois groupes (Menu ANALYZE -> Descriptive Statistics -> Frequencies).
FREQUENCIES VARIABLES=CLU3_1
  /ORDER=ANALYSIS.
* On remarque que les effectifs des trois groupes (clusters) sont de 583, 630 et 280.


* Des tableaux bivariés  (Menu ANALYZE -> Descriptive Statistics -> Crosstabs).
* On croise la nouvelle variable (qui regroupe l'échantillon belge en trois groupes) et les cinq variables de départ, auxquelles on rajoute une variable sur la religiosité (v114) et la variable "genre" (v302).
CROSSTABS
  /TABLES=CLU3_1 BY v136 v138 v139 v145 v146 v114 v302
  /FORMAT=AVALUE TABLES
  /STATISTICS=CHISQ 
  /CELLS=COUNT ROW 
  /COUNT ROUND CELL.
* Sauf pour l'association avec "discuss problems", les conditions du test de Chi-carré sont remplies, car la majorité (>= 75%) des fréquences théoriques des tableaux croisés sont supérieures ou égales à 5 et aucune occurrence attendue n'est inférieure à 1.
* On remarque que toutes les associations sont significatives à 95% CI (sig < 0.05). Regardant les tableaux, on peut conclure que :
* Les individus du cluster 1 sont les plus enclins à considérer le statut social et les opinions religieuses comme importants. Ils les plus nombreux à se déclarer religieux. La proportion des femmes est plus élevée dans le Cluster 1.
* Contrairement, ceux du cluster 3 sont moins nombreux à considérer le statut social et les opinions religieuses comme importants. Ils sont plus nombreux à se déclarer pas religieux et la proportion d'hommes est la plus importante.
* Les individus du cluster 2 sont les moins nombreux à accorder de l'importance à la fidélité, aux enfants et à la communication des problèmes dans le couple. Ce sont les plus enclins à se déclarer athées des trois groupes et la proportion d'hommes se situe entrre le Cluster 1 et le Cluster 3.


* L'analyse en composantes principales (Menu Analyze -> Dimension Reduction -> Factor).
* Les options sont celles expliquées lors du TP4 et reprises dans la Fiche hebdomadaire no. 4.
FACTOR
  /VARIABLES v136 v138 v139 v145 v146
  /MISSING LISTWISE 
  /ANALYSIS v136 v138 v139 v145 v146
  /PRINT UNIVARIATE INITIAL CORRELATION SIG KMO EXTRACTION ROTATION
  /PLOT EIGEN
  /CRITERIA MINEIGEN(1) ITERATE(25)
  /EXTRACTION PC
  /CRITERIA ITERATE(25)
  /ROTATION VARIMAX
  /SAVE REG(ALL)
  /METHOD=CORRELATION.
* Les corrélations sont plutôt faibles, la plupart sont significatives, à l'exception de celle entre "discuss problems" et "same social background".
* Le KMO (0.57) indique qu'une ACP est possible à faire, mais sans que les données soient vraiment adaptées.
* La variable la mieux extraite est "faithfulness" (57,9% de sa variabilité est expliquée) et la moins bien expliquée est "children" (31,6%).
* Deux facteurs ont des valeurs propres d'au moins 1 et ensemble, ils expliquent 53% de la variabilité de départ.
* Le premier facteur est fortement et positivement (faire attention à la façon dont les variables ont été codées) associé aux variables "faithfulness" et "shared religious beliefs" et - dans une moindre mesure, à "children".
* Le deuxième facteur est fortement et positivement  associé aux variables "faithfulness" et "discuss problems" et - dans une moindre mesure, à "children".
* On pourrait appeler le premier facteur "socio-culturel" et le deuxième "de relation au sein de la famille".


* L'analyse de classification (Menu ANALYZE -> Classify -> Hierarchical Cluster.
* Cette fois-ci, dans l'onglet "Variables", on rajoute les deux composantes retenues lors de l'ACP.
CLUSTER   FAC1_1 FAC2_1
  /METHOD WARD
  /MEASURE=SEUCLID
  /PRINT SCHEDULE CLUSTER(2,4)
  /PLOT DENDROGRAM
  /SAVE CLUSTER(2,4).
* Les sauts des coefficients de Ward entre l'étape 1487 et 1492 sont de 1.40 (5 groupes), 1.35 (4 groupes), 1.27 (3 groupes), 1.65 (2 groupes), 1.60 (1 groupe).
* On va donc s'arrêter à 3 groupes. Le dendrogramme le confirme.


* L'analyse univariée de cette nouvelle variable, qui regroupe l'échantillon belge en 3 groupes (Menu ANALYZE -> Descriptive Statistics -> Frequencies).
* On remarque que les effectifs des trois groupes (clusters) sont relativement équitablement distribués.
FREQUENCIES VARIABLES=CLU3_2
  /ORDER=ANALYSIS.

* On croise la variable de classification uniquement avec les variables la plus fortement associée à chaque facteur ("social background" pour le facteur 1 et "faithfulness" pour le facteur 2). On rajoute deux variables socio-démographiques.
* Des tableaux bivariés  (Menu ANALYZE -> Descriptive Statistics -> Crosstabs).
CROSSTABS
  /TABLES=CLU3_2 BY v136 v138 v114 v302
  /FORMAT=AVALUE TABLES
  /STATISTICS=CHISQ 
  /CELLS=COUNT ROW 
  /COUNT ROUND CELL.
* Les conditions d'application du test sont remplies.
* Toutes les associations sont significatives.
* Le groupe 1 est celui qui accorde le plus d'importance au statut social. C'est le groupe avec la plus grande proportion de personnes religieuses et de femmes.
* Le groupe 2 est celui qui accorde le moins d'importance à la fidélité. C'est le groupe avec la moindre proportion de femmes.
* Le groupe 3 est celui qui accorde le moins d'importance au statut social. C'est le groupe le moins religieux et la proportion de femmes se situe entre les deux autres groupes.

*Application A.

* Sélection des ressortissants belges (menu DATA -> Select cases -> If condition is satisfied).
* On rajoute deux conditions, connectées par l'opérateur logique "&".
USE ALL.
COMPUTE filter_$=((country = 56) & (age <  25)).
VARIABLE LABELS filter_$ '(country = 56) & (age <  25) (FILTER)'.
VALUE LABELS filter_$ 0 'Not Selected' 1 'Selected'.
FORMATS filter_$ (f1.0).
FILTER BY filter_$.
EXECUTE.

* L'analyse de classification (Menu ANALYZE -> Classify -> Hierarchical Cluster.
CLUSTER   v268 v269 v270 v271 v272 v273
  /METHOD WARD
  /MEASURE=SEUCLID
  /PRINT SCHEDULE CLUSTER(2,4)
  /PLOT DENDROGRAM
  /SAVE CLUSTER(2,4).
* Le "saut" du coefficient de Ward est plus élevé à l'étape 168, on va donc s'arrêter avant, à l'étape 167. Celle-ci regroupe les individus en 3 groupes.
* Cela est corroboré par le dendrogramme.

* L'analyse univariée de cette nouvelle variable, qui regroupe l'échantillon belge âgé de moins de 25 ans en 3 groupes (Menu ANALYZE -> Descriptive Statistics -> Frequencies).
* On remarque que les effectifs des trois groupes (clusters) sont de 30, 84 et 56.
FREQUENCIES VARIABLES=CLU3_3
  /ORDER=ANALYSIS.

* Des tableaux bivariés  (Menu ANALYZE -> Descriptive Statistics -> Crosstabs).
* On peut aussi rajouter des variables susceptibles d'expliquer le positionnement des individus dans les clusters. Ici, on a choisi le sexe et le niveau d'éducation (codé en "bas", "moyen" et "haut").
CROSSTABS
  /TABLES=CLU3_3 BY v268 v269 v270 v271 v272 v273 v302 v336_r
  /FORMAT=AVALUE TABLES
  /STATISTICS=CHISQ 
  /CELLS=COUNT ROW 
  /COUNT ROUND CELL.
* Les conditions d'application des tests ne sont pas remplies. Il faudrait procéder à un regroupement des variables v268 v269 v270 v271 v272 v273, afin d'augmenter les effectifs théoriques.
* Le groupe 1 est le plus enclin à avoir une opinion favorable aux imigrés. La proportion d'hommes est égale à celle des femmes. C'est le groupe où il y a la plus grande proportion de personnes avec une éducation supérieure.
* Le groupe 3 est le plus enclin à avoir une opinion défavorable aux immigrés. La proportion d'hommes est égale à celle des femmes.
* Le groupe 2 se situe entre les deux autres groupes. La proportion d'hommes est plus élevée que celle des femmes. C'est le groupe où il y a la moindre proportion de personnes avec une éducation supérieure.


