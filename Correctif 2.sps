* Encoding: UTF-8.
*Séance 2. 

*Exercice 1. 
*Cet exercice est optionnel. Vous n'avez pas besoin de le réaliser pour compléter l'exercice.
*Cependant, cela va vous permettre d'alléger l'affichage des variables dans les différents menus des procédures.
*Allez dans le menu Utilities \ Define variable sets. Créer un nouveau groupe, nommez le comme vous voulez.
*Ajouter les variables mentionnées. 
*Allez dans la fonction Utilities \ Use variables sets. Sélecitonnez le set que vous venez de créer. 
*Déselectionner "ALL VARIABLES". 
*Il n'existe pas de syntaxe pour les jeux de variables malheureusement.

*Exercice 2. 
* La procédure Select cases permet de sélectionner un sous échantillon selon une condition.
    COMPUTE filter_$=(country =56).
    VARIABLE LABELS filter_$ 'country =56 (FILTER)'.
    VALUE LABELS filter_$ 0 'Not Selected' 1 'Selected'.
    FORMATS filter_$ (f1.0).
    FILTER BY filter_$.
    EXECUTE.

*Exercice 3. 
*Il faut paramétrer la variable "Year" car elle est en chaîne de caractères.
*Tout d'abord, vérifiez qu'il n'y a pas de chaînes de caractères avant de faire la transformation.
    FREQUENCIES VARIABLES=year
      /ORDER=ANALYSIS.
*C'est bon, il n'y a que des chiffres. On va changer le paramètre via DEFINE VARIABLES PROPERTIES.
*On change le type de string vers numeric.
    * Define Variable Properties.
    *year.
    ALTER TYPE  year(F4.0).
    *year.
    FORMATS  year(F4.0).
    EXECUTE.
*Une fois que c'est fait, on crée la variable via la fonction compute en faisant la soustraction entre l'année d'enquête et l'année de naissance.
    COMPUTE Age_rep=year-v303.
    EXECUTE.
*Paramétrage de la variable via Define variable properties.
* Define Variable Properties.
*Age_rep.
    VARIABLE LABELS  Age_rep 'Age'.
    EXECUTE.
*Analyse univariée.
    DESCRIPTIVES VARIABLES=Age_rep
      /STATISTICS=MEAN STDDEV VARIANCE MIN MAX.
*En moyenne les répondants ont 48 ans. Toutes les strates de la population majeure sont représentées puisque l'écart-type est de 17 ans
Le moins âgé à 18 ans et le plus âgé 100. 

*Exercice 4. 
*Il s'agit d'une variable de comptage ==> COUNT VALUES WIHTIN CASES.
    COUNT intolerance=v46 v47 v48 v49 v50 v51 v52 v53 v54 v55 v56 v57 v58 v59 v60(1).
    EXECUTE.
*Paramétrage.
    * Define Variable Properties.
    *intolerance.
    VARIABLE LEVEL  intolerance(SCALE).
    VARIABLE LABELS  intolerance 'Nombre de caractéristiques du voisin irritant le répondant'.
    EXECUTE.
*Analyse univariée. 
    DESCRIPTIVES VARIABLES=intolerance
      /STATISTICS=MEAN STDDEV VARIANCE MIN MAX.
* En moyenne, les répondants n'aiment pas leurs voisins sur base de 2,5 critères. La variance est relativement modérée
au vu que certains répondant ne semblent pas détester leurs voisins sur bases de critères spécifiques alors que d'autres, tout les énerve
(Minimum de 0 et maximum de 14, ET de 2.5 sur une échelle de 15). 

*Exercice 5. 
*Il faut recoder ici. 
    RECODE v264_LR (1 thru 4=1) (5 thru 6=2) (7 thru 10=3) INTO couleur.
    EXECUTE.
*Paramétrage.
    * Define Variable Properties.
    *couleur.
    VARIABLE LEVEL  couleur(NOMINAL).
    VARIABLE LABELS  couleur 'Couleur politique'.
    VALUE LABELS couleur
      1.00 'Gauche'
      2.00 'Centre'
      3.00 'Droite'.
    EXECUTE.
*Analyse univariée.
    FREQUENCIES VARIABLES=couleur
      /ORDER=ANALYSIS.
*306 données manquantes (20%) ==> Sujet sensible?.
*Sur les données valides: plus de votants à gauche et à droite qu'au centre. 

*Exercice 6. 
*Analyse descriptive bivariée: variable quanti et variable quali ==> COMPARE MEANS. 
    MEANS TABLES=intolerance BY couleur
      /CELLS=MEAN COUNT STDDEV MEDIAN MIN MAX.


*Graphique ==> Boxplot. 
    EXAMINE VARIABLES=intolerance BY couleur
      /PLOT=BOXPLOT
      /STATISTICS=NONE
      /NOTOTAL.

* Il semble y avoir une tendance linéaire ==> au plus les individus votent vers la droite, au plus le nombre
moyen de caractéristiques augmente. Les personnes de gauche semblent être les plus indulgentes.

*Exercie 7. 
*Changer le filtre et faire la même procédure.
    USE ALL.
    COMPUTE filter_$=(country =300).
    VARIABLE LABELS filter_$ 'country =300 (FILTER)'.
    VALUE LABELS filter_$ 0 'Not Selected' 1 'Selected'.
    FORMATS filter_$ (f1.0).
    FILTER BY filter_$.
    EXECUTE.
*Analyse descriptive bivariée: variable quanti et variable quali ==> COMPARE MEANS. 
    MEANS TABLES=intolerance BY couleur
      /CELLS=MEAN COUNT STDDEV MEDIAN MIN MAX.


*Graphique ==> Boxplot. 
    EXAMINE VARIABLES=intolerance BY couleur
      /PLOT=BOXPLOT
      /STATISTICS=NONE
      /NOTOTAL.
*Relation exacerbée. Les votants de droite sont beaucoup plus intolérants qu'en Belgique.

*Exercice 8.
*On sélectionne les belges à nouveau.
    USE ALL.
    COMPUTE filter_$=(country =56).
    VARIABLE LABELS filter_$ 'country =56 (FILTER)'.
    VALUE LABELS filter_$ 0 'Not Selected' 1 'Selected'.
    FORMATS filter_$ (f1.0).
    FILTER BY filter_$.
    EXECUTE.
*Graphique en barres groupées.
    GRAPH
      /BAR(GROUPED)=COUNT BY v355_r BY v336_r.
*Le phénomène de reproduction sociale semble bel et bien présent. Les individus ayant un diplôme faible
ont en majorité un père qui a eu le même diplôme et inversémment pour les individus aux diplômes élevés. 
*On peut cependant observer certains transclasses au niveau des diplômes moyens du père avec une proportion 
relativement importantes d'individus ayant un diplôme élevé.

*Exercice 9.
*Analyse descriptive bivariée: variable quanti et variable quali ==> COMPARE MEANS. 
    MEANS TABLES=age_rep BY couleur
      /CELLS=MEAN COUNT STDDEV MEDIAN MIN MAX.
    
    *Graphique ==> Boxplot. 
        EXAMINE VARIABLES=age_rep BY couleur
          /PLOT=BOXPLOT
          /STATISTICS=NONE
          /NOTOTAL.
    
    *Les belges votant au centre sont en moyenne plus âgés que les autres. C'est aussi la seule catégorie dont la moyenne
    est supérieure à la moyenne d'âge de l'échantillon. 

*Exercice 10. 
*On utilise l'option Splitfile et on utilise la variable V302.
    SORT CASES  BY v302.
    SPLIT FILE LAYERED BY v302.
*On réitère ensuite la procédure.
*Graphique ==> Boxplot. 
        EXAMINE VARIABLES=age_rep BY couleur
          /PLOT=BOXPLOT
          /STATISTICS=NONE
          /NOTOTAL.
* Les tendance ne semblent pas fondamentalement différentes en fonction du sexe des répondants.
