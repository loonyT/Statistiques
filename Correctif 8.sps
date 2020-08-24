* Encoding: UTF-8.
*Correctif TP 8. 

*Exercice 1. 

*Sélectionnez la population belge. 
    COMPUTE filter_$=(country =56).
    VARIABLE LABELS filter_$ 'country =56 (FILTER)'.
    VALUE LABELS filter_$ 0 'Not Selected' 1 'Selected'.
    FORMATS filter_$ (f1.0).
    FILTER BY filter_$.
    EXECUTE.

*Test-t à échantillons indépendants .
    
    T-TEST GROUPS=v355_r(2 3)
      /MISSING=ANALYSIS
      /VARIABLES=v353M_ppp
      /CRITERIA=CI(.95).
    
*Les individus dont le père a un niveau d'éducation moyen ont en moyenne un revenu de 2280 euros et les individus dont le père a
un niveau d'éducation élevé ont en moyenne un revenu de 2530 euros. A priori, on pourrait penser que l'origine sociale a un impact
sur le revenu des individus. 

* Le test de Lévène est non significatif, ce qui signifie que les variances sont égales. On regarde dès lors le résultat du test-t paramétrique
qui sous-entend une hypothèse de variances égales. La p-valeur est de 0.039. On peut donc accepter H1 et dire que cette différence de moyenne
n'est pas dûe au hasard. 

* On peut calculer la force de l'association. 2.073² / (2.073² + 300 +198-2) = 0.0086 
* S'il y a une différence significative, elle est cependant de petite ampleur. 
* Le diplôme du père a donc bien un effet sur le revenu des répondants de manière linéaire et positive. Cependant, cet effet reste marginal.

*Exercice 2.
* Afin de réaliser les deux groupes, on peut utiliser l'option cutpoint en renseignant la valeur 3. Autre possibilité: créez une variable dichotomique.
    T-TEST GROUPS=v355_r(3)
      /MISSING=ANALYSIS
      /VARIABLES=v353M_ppp
      /CRITERIA=CI(.95).
*Les individus dont le père a un niveau d'éducation faible ou moyen ont en moyenne un revenu de 1881 euros et les individus dont le père a
un niveau d'éducation élevé ont en moyenne un revenu de 2530 euros. L'effet semble plus fort dans ce cas de figure. 

*Le test de lévène est significatif: les variances sont inégales, on lit les résultats de la deuxième ligne du test-t. 

*Le test est très significatif: il y a très peu de chance pour que cette différence soit le fruit du hasard. 

* Calcul de l'éta-carré: 6.3²/(6.3²+1043+198-2) = 0,03 
* Si l'écart des moyennes est plus creusé et si l'éta-carré a augmenté, l'effet reste de faible ampleur. 

*Exercice 3. 

*Il s'agit de comparer les données de l'échantillon avec des données de références ==> Test-t à échantillon unique. 
*On compare tout d'abord avec la moyenne de 1986.
    T-TEST
      /TESTVAL=2.01
      /MISSING=ANALYSIS
      /VARIABLES=v324b
      /CRITERIA=CI(.95).
*La p-valeur est de 0.009, les moyennes sont différentes. 
*On réalise ensuite le test avec la moyenne de 1995.
    T-TEST
      /TESTVAL=1.98
      /MISSING=ANALYSIS
      /VARIABLES=v324b
      /CRITERIA=CI(.95).
*La p-valeur est de 0.059, les moyennes ne sont pas significativement différentes. 
*On peut observer un déclin progressif du nombre d'enfant par foyer. Si le nombre d'enfant par foyer n'est pas significativement différent
de celui de 1995, il l'est par contre par rapport à 1986. 

*Exercice 4.

*Il faut tout d'abord créer une variable qui compte le nombre d'institutions envers lesquelles les citoyens accordent une grande confiance.
*Pour cela, on utilise la procédure count values within cases et on renseigne la valeur 1. 
    COUNT confiance=v205 v206 v207 v208 v209 v210 v211 v212 v213 v214 v215 v216 v217 v218 v219 v220 
        v221 v222(1).
    EXECUTE.
*Ensuite on éxécute un test-t à échantillons indépendants avec un point de césure pour le niveau d'éducation à 2.
    T-TEST GROUPS=v336_r(2)
      /MISSING=ANALYSIS
      /VARIABLES=confiance
      /CRITERIA=CI(.95).
* En moyenne, les citoyens avec un faible niveau d'éducation accordent une grande confiance envers 1.85 institutions contre 1.51 pour
les individus avec un niveau d'éducation moyen ou élevé. A priori, la différence ne paraît pas élevée et les citoyens ont l'air plutôt peu confiants.

*Test de Lévène non significatif (p=0.003) ==> Ligne inférieure du tableau car variances hétérogènes
*Test-t Significatif (p=0.012). La différence de moyenne n'est pas due au hasard, il y a bel et bien un effet du niveau d'éducation sur 
le nombre d'insitutions envers lesquelles les répondants accordent une grande confiance. 

*Eta-carré: -2.5²/(-2.5²+485+1043-2) = 0.04 
*Effet de faible ampleur. 

*Exercice 5.

*Création de la variable. 
    RECODE v66 (1 thru 5=1) (6 thru 10=2) INTO satisfaction_rec.
    EXECUTE.

    * Define Variable Properties.
    *satisfaction_rec.
    VARIABLE LEVEL  satisfaction_rec(ORDINAL).
    VALUE LABELS satisfaction_rec
      1.00 'Insatisfait'
      2.00 'Satisfait'.
    EXECUTE.

* Il faut ensuite modifier le filtre: l'on va retenir que les ressortissants des trois pays mentionnés. Utilisation du | ("ou" logique) dans le filtre. 
    USE ALL.
    COMPUTE filter_$=(country =56 | country = 250 | country = 826).
    VARIABLE LABELS filter_$ 'country =56 | country = 250 | country = 826 (FILTER)'.
    VALUE LABELS filter_$ 0 'Not Selected' 1 'Selected'.
    FORMATS filter_$ (f1.0).
    FILTER BY filter_$.
    EXECUTE.

*Le test à appliquer est ici un Khi-carré: la nouvelle variable de satisfaction est dichotomique et la variable country est nominale. 
    CROSSTABS
      /TABLES=country BY satisfaction_rec
      /FORMAT=AVALUE TABLES
      /STATISTICS=CHISQ PHI 
      /CELLS=COUNT ROW 
      /COUNT ROUND CELL.
*Les conditions du test sont respectées: aucun ET inférieur à 5.
*On peut remarquer une certaine tendance de bonheur: les belges sont plus heureux que les ressortissants de deux autres pays.
*Les kosovars sont un peu plus heureux que les hongrois mais cette différence n'est pas aussi marquée
qu'avec les belges. Peut-être est-ce dû à l'indépendance déclarée en 2008? 

* Le test du khi-carré est significatif et le V de Kramer annonce un effet de petite taille.
* Il semblerait donc qu'il existe bel et bien des différences de bonheur en fonction des pays où l'on réside, La belgique semblant être 
* un endroit plus paisible que les deux autres pays. Cependant, vu le coefficient du V de KRamer, on peut émettre l'hypothèse que si le contexte social, politique et culturel d'un pays 
impacte le niveau de bonheur, d'autres facteurs contribuent au niveau de bonheur.
 
    

*Exercice 6. 

*Tout d'abord il faut enlever le filtre précédent 

    FILTER OFF.
    USE ALL.
    EXECUTE.

*Ensuite on applique un test-t à échantillons indépendants en utilisant comme variable dépendante la variable "country" et on renseigne les valeurs des pays dans les groupes. 

    T-TEST GROUPS=country(442 915)
      /MISSING=ANALYSIS
      /VARIABLES=v353M_ppp
      /CRITERIA=CI(.95).

* Les luxembourgeois ont un revenu moyen de 3020 euros par mois contre 429 pour les Kosovars.
* La différence, même descriptive, nous paraît énorme. 
* Le test de Lévène nous indique des variances inégales. Cela fait sens, on peut s'attendre à ce que les écarts des salaires des luxembrougeois
soient plus dispersés de par la moyenne plus haute que celle des kosovars.
* On lit donc la deuxième ligne du tableau du test. 
* La différence est significative. 
* calcul de l'eta-carré: 56.7²/(56.7²+1226+1486-2) = 0.585! 
* C'est peu dire que l'effet est de grande taille. La différence est significative et le fait d'habiter le luxembourg ou le kosovo a un impact
saillant sur le revenu. Bien entendu, le revenu est proportionnel au coût de la vie dans le pays. Cependant, il y a fort à parier
qu'il fait meilleur d'être luxembourgeois que Kosovar si l'on veut obtenir un salaire élevé.




