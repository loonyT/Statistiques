* Encoding: UTF-8.
*Correctif TP 10. 

*Exercice 1.
*Toute valeur inférieure à 93 doit être égale à 1. Toutes les autres, qu'elles soient supérieures ou manquantes seront codées 0. 
    RECODE Date (Lowest thru 1993=1) (ELSE=0) INTO EU_92.
    VARIABLE LABELS  EU_92 "Fait parti de l'europe de 1992".
    EXECUTE.

    * Define Variable Properties.
    *EU_92.
    VALUE LABELS EU_92
      .00 'NON'
      1.00 'OUI'.
    EXECUTE.

*Exercice 2. 
*La variable EU_92 est une variable nominale dichotomique et la variable V2 est une variable quantitative ==> Test-t à échantillons indépendants.

    T-TEST GROUPS=EU_92(1 0)
      /MISSING=ANALYSIS
      /VARIABLES=V2
      /CRITERIA=CI(.95).

*Le pib par habitant des membres de l'union92 est de 27420 euros contre 12721 pour les autres! 
*Le test de Lévène est non-significatif: les variances sont homogènes. On regardera donc la première ligne du tableau du test-t.
*La p-valeur du test est largement inférieur au seuil. On n'a donc peu de chance de se tromper de dire que les pays de l'union 92 sont bien plus riches que les autres.
*On calcule la taille d'effet de cette différence via l'êta-carré: 4,1²/(4,1²+24+53-2) = 0.175 ==> L'effet est de grande ampleur. 
*On peut donc affirmer que les pays de l'union constituée en 1992 sont bien mieux lottis en moyenne que les membres plus tardifs de l'union et des pays encore non-membres. 

*Exercice 3.

*Les deux variables sont quantitatives, nous allons donc procéder à un test de corrélation.

    CORRELATIONS
      /VARIABLES=V29 V1
      /PRINT=TWOTAIL NOSIG
      /MISSING=PAIRWISE.

*Le coefficient de corrélation est de -0.278 et la p-valeur est de 0.014. On peut donc affirmer qu'il y a bel et bien une relation entre le taux de suicide et le PIB par habitant. 
*Cependant, cette relation est négative, sous entendant qu'au plus le PIB par habitant est élevé, au moins le taux de suicide est faible. L'intensité de cette relation est d'ampleur moyenne.
*Ce dicton a donc un certain fondement: l'argent ne fait sans doute pas le bonheur à lui seul mais il y contribue grandement.
*Pour représenter graphiquement cela, on utilisera un nuage de points:

    GRAPH
      /SCATTERPLOT(BIVAR)=V9 WITH V2 BY Continent
      /MISSING=LISTWISE.

*Exercice 4.
*Tester une variable quantitative + une variable nominale à plus de deux modalités ==> Test ANOVA.

    ONEWAY V9 BY Continent
      /STATISTICS DESCRIPTIVES EFFECTS HOMOGENEITY BROWNFORSYTHE 
      /MISSING ANALYSIS
      /POSTHOC=TUKEY T3 ALPHA(0.05).

*Les taux de suicides sont de 15, 21, 24 et 8 pour mille pour, respectivement, l'europe de l'Ouest, du Nord, de l'Est et du Sud. 
*Les variances du test de lévène ne sont pas Homogènes, il faudra donc lire le résultat du test de Welch. 
*Le résultat est significatif: il y a bien une relation entre le taux de suicide et les régions d'Europe. 
*Calcul du R²: Racine (3114/8626) = 0.6 ==> Effet de grande ampleur. 
*On peut ensuite observer les différences de moyennes deux à deux via le test post-hoc de Dunnett.
*Il appraît que la moyenne des pays du Sud est significativement différente de toutes les autres régions.
*Pour les autres régions, les différences ne sont pas marquées entre l'Ouest et le Nord, ainsi que pour le Nord et l'Est. 
*On peut s'étonner de ce résultat, surtout pour ce qui concerne le taux de suicide relativement élevé dans les pays du nord, réputés socialement développés. 
*Hypothèse conclusive: Le soleil serait-il la raison d'un taux de suicide plus bas?


*Exercice 5.
*Simple recodage.    
    RECODE V10 (Lowest thru 30=1) (30 thru 40=2) (40 thru Highest=3) INTO Fumeurs.
    VARIABLE LABELS  Fumeurs 'Catégories de pourcentage de fumeurs'.
    EXECUTE.
    
    * Define Variable Properties.
    *Fumeurs.
    VARIABLE LEVEL  Fumeurs(ORDINAL).
    VALUE LABELS Fumeurs
      1.00 '<30%'
     2.00 '30-40%'
      3.00 '>40%'.
    EXECUTE.

*Exercice 6. 
*Un simple recodage également. 
    RECODE V2 (17303 thru Highest=1) (ELSE=0) INTO Richesse.
    VARIABLE LABELS  Richesse 'Pays en dessous de la moyenne du PIb/Habitant'.
    EXECUTE.
    * Define Variable Properties.
    *Richesse.
    VARIABLE LEVEL  Richesse(ORDINAL).
    VALUE LABELS Richesse
      .00 'Pauvre'
      1.00 'Riche'.
    EXECUTE.

*Exercice 7.   
*Deux variables qualitatives: test du Khi-carré.

    CROSSTABS
      /TABLES=Richesse BY Fumeurs
      /FORMAT=AVALUE TABLES
      /STATISTICS=CHISQ PHI 
      /CELLS=COUNT ROW COLUMN 
      /COUNT ROUND CELL.

* A la lecture du tableau croisé, il semblerait y avoir une relation négative. Les pays qui sont en dessous de la moyenne du PIB par habitant ont des effectifs plus importants dans les tranches les plus élevées des fumeurs
*et inversémment pour les pays au dessus de la moyenne. 
* Ainsi, seuls 20% des pays au dessus de la moyenne on un taux de fumeurs supérieur à 40% contre 80 pour les pays en dessous de la moyenne. 
* A l'inverse, 62% des pays "riches" ont un taux de fumeurs inférieur à 30% contre 38% pour les pays "pauvres".

*La p-valeur du test du khi-carré est significative: la relation n'est pas hasardeuse. 
* Le V de Kramer est de 0.283: l'effet est de taille moyenne. 
* On peut donc affirmer qu'il y a une relation négative entre le taux de fumeurs dans la population et le niveau de richesse de celui-ci. 

*Exercice 8.
*Il s'agit d'un simple quotient ==> Compute variable.
    COMPUTE Migrants=V1 / V11.
    EXECUTE.

*Exercice 9.
*Une variable quantitative et une variable qualitative: la solution optimale est sans doute un BOXPLOT.

    EXAMINE VARIABLES=Migrants BY Continent
      /PLOT=BOXPLOT
      /STATISTICS=NONE
      /NOTOTAL.
*Les pays de l'Ouest de l'Europe semblent avoir des pourcentages de migrants plus élevés que dans les autres régions d'Europe. La région de L'est est celle la moins touchée par le phénomène migratoire. 
