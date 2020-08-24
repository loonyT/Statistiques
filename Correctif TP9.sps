* Encoding: UTF-8.

* Ouvrir la base de données. Le chemin du fichier sera différent, d'un ordinateur à l'autre.
GET
  FILE='Z:\Q1\LPOLS1221\db\Eurobarometer_2017.sav'.
DATASET NAME DataSet1 WINDOW=FRONT.

* Sélection des pays fondateurs de l'UE (Menu DATA -> Select cases -> If condition is satisfied).
USE ALL.
COMPUTE filter_$=(eu6 = 1).
VARIABLE LABELS filter_$ 'eu6 = 1 (FILTER)'.
VALUE LABELS filter_$ 0 'Not Selected' 1 'Selected'.
FORMATS filter_$ (f1.0).
FILTER BY filter_$.
EXECUTE.


* Exercice 1.
* Création de la nouvelle variable qui mesure la taille du ménage (Menu TRANSFORM -> Recode into Different Variables)
RECODE d40abc (1 thru 98=Copy) (ELSE=SYSMIS) INTO taille_menage.
VARIABLE LABELS  taille_menage 'Taille du ménage'.
EXECUTE.


* Exercice 2.
* Un graphique de type "boîte à moustaches", pour visualiser la relation entre la taille du ménage et le milieu de résidence (Menu GRAPHS -> Legacy Dialogs -> Boxplot).
EXAMINE VARIABLES=taille_menage BY d25
  /PLOT=BOXPLOT
  /STATISTICS=NONE
  /NOTOTAL.
* A première vue, on n'observe pas de tendance d'association entre les deux variables.
* Il y a beaucoup de cas extrèmes (outliers) dans chacune des modalités de la variable qualitative.
  
* ANOVA sur la taille du ménage et le milieu de résidence (Menu ANALYZE -> Compare Means -> One-Way ANOVA).

  ONEWAY taille_menage BY d25
  /STATISTICS DESCRIPTIVES HOMOGENEITY BROWNFORSYTHE WELCH 
  /PLOT MEANS
  /MISSING ANALYSIS
  /POSTHOC=TUKEY BONFERRONI T3 ALPHA(0.05).
* Regardant le tableau descriptif, les différences de tailles des ménages sont vraiment très faibles, variant de 2.47 (petites villes) à 2.54 (grandes villes).
* Le test de Levene a un niveau de signification plus petit que le seuil de 0.05, donc il permet de rejeter H0 à un seuil de 0.05 et de conclure que la variance de la variable taille_menage est différente des autres dans au moins un des trois groupes.
* Cela signifie que l'on a un cas de hétéroscédasticité et donc on est obligés à regarder les résultats d'un test robuste, tels que Welch ou Brown-Forsythe.
* Le niveau de signification chez ces deux tests est plus élevé que le seuil qu'on peut accepter, donc on ne peut pas rejeter H0 d'égalité des moyennes.
* Cela signifie que nous ne pouvons pas conclure qu'il y a une association entre le milieu de résidence et la taille du ménage dans les pays fondateurs de l'UE.
* De ce fait, on ne regarde pas les résultats des tests post-hoc.


* Exercice 3.
* Recodage de la variable d63 en classe_soc (menu TRANSFORM -> Recode into different variables).
RECODE  d63
	(MISSING = SYSMIS) (6 THRU 9 = SYSMIS)(1 THRU 2 = 1) (3 = 2) (4 THRU 5 = 3) 
	INTO classe_soc .
EXECUTE.

* Renseigner la nouvelle variable (classe_soc)  (Menu DATA -> Define Variable Properties).
* Define Variable Properties.
* classe_soc.
VARIABLE LEVEL  classe_soc(ORDINAL).
VARIABLE LABELS  classe_soc 'Classe sociale'.
VALUE LABELS classe_soc
  1.00 'ouvrière'
  2.00 'moyenne'
  3.00 'haute'.
EXECUTE.

* Un graphique de type "boîte à moustaches", pour visualiser la relation entre la taille du ménage et la classe sociale (Menu GRAPHS -> Legacy Dialogs -> Boxplot).
EXAMINE VARIABLES=taille_menage BY classe_soc
  /PLOT=BOXPLOT
  /STATISTICS=NONE
  /NOTOTAL.
* Ici, on observe que, si les médianes sont similaires (autour de 2), les étendues de la taille du ménage sont différentes entre les trois groupes. On commence à suspecter que les classes sociales plus hautes ont des ménages de taille légèrement supérieure. 

* ANOVA sur taille du ménage et la classe sociale.
  ONEWAY taille_menage BY classe_soc
  /STATISTICS DESCRIPTIVES HOMOGENEITY BROWNFORSYTHE WELCH 
  /PLOT MEANS
  /MISSING ANALYSIS
  /POSTHOC=TUKEY BONFERRONI T3 ALPHA(0.05).
* Le tableau descriptif confirme la suspicion qu'on avait, en regardant les boxplots. La taille moyenne des ménages des répondants de classe ouvrière était de 2.35 membres, comparé à 2.71 pour la classe supérieure.
* Le niveau de signification du test de Levene est plus petit que le seuil de 0.05, donc on rejette l'hypothèse d'égalité des variances (au moins une est différente).
* On regarde alors les résultats des tests robustes de Welch et Brown-Forsythe. Ici, le niveau de signification est très petit, beaucoup plus petit que le seuil de 0.05, donc à 95% intervalle de confiance on peut rejeter H0 d'égalité des moyennes.
* On va conclure donc qu'il y a au moins une des trois classes sociales a une taille moyenne de ménage différente des autres.
 * Il y a donc il y a une relation entre la classe sociale et la taille du ménage, dans la population des six pays concernés.
 * Pour voir laquelle (ou lesquelles) des classes sociales ont des ménages de taille différente aux autres groupes, dans les tableaux de comparaison des groupes (Multiple Comparisons), on va regarder Dunnet's T3.
* Les comparaisons montrent qu'il y a une différence significative (à un IC de 95%) entre chacune des catégories et les deux autres catégories..
 * Le graphique "Means Plots" permettent de visualiser cela.
 

* Exercice 4.
* Création de la nouvelle variable qui mesure la satisfaction de vie.
RECODE d70 (1 thru 4=Copy) (ELSE=SYSMIS) INTO satisfaction.
VARIABLE LABELS  satisfaction 'Satisfaction de vie'.
EXECUTE.

* Define Variable Properties.
*satisfaction.
VARIABLE LEVEL  satisfaction(ORDINAL).
VALUE LABELS satisfaction
  1.00 'très satisfait'
  2.00 'plutôt satisfait'
  3.00 'plutôt insatisfait'
  4.00 'très insatisfait'.
EXECUTE.

* Un graphique de type "boîte à moustaches", pour visualiser la relation entre la taille du ménage et le niveau de satisfaction (Menu GRAPHS -> Legacy Dialogs -> Boxplot).
EXAMINE VARIABLES=taille_menage BY satisfaction
  /PLOT=BOXPLOT
  /STATISTICS=NONE
  /NOTOTAL.
* Dans le graphique, le groupe "très satisfait" semble appartenir à des ménages de taille supérieure qe les autres groupes.

* ANOVA sur taille du ménage et la satisfaction de vie.
 ONEWAY taille_menage BY satisfaction
  /STATISTICS DESCRIPTIVES HOMOGENEITY BROWNFORSYTHE WELCH 
  /PLOT MEANS
  /MISSING ANALYSIS
  /POSTHOC=TUKEY BONFERRONI T3 ALPHA(0.05).
* Le tableau Descriptives montre une diminution progressive dans la taille moyenne du ménage, du groupe "très satisfait" aux deux groupes les moins satisfaits.
* Le deuxième tableau est le test de Levène. Le niveau de signification est beaucoup plus grand que le seuil qu'on admet couramment.
* Donc à 95% intervalle de confiance on ne peut pas rejeter H0 d'égalité des variances. On reste donc dans le scénario par défaut, celui de l'hypothèse nulle.
* Ceci signifie qu'on regarde les résultats de l'ANOVA.
* Le niveau de signification de l'ANOVA (0.002) est beaucoup plus petit que le seuil de 0.05, donc à 95% intervalle de confiance on peut rejeter H0 d'égalité des moyennes.
* On va conclure donc qu'il y a au moins un des trois groupes d'âge a l'opinion moyenne (l'accord moyen) différente des autres.
* Il y a donc il y a une relation entre la taille du ménage et le niveau de satisfaction, dans la population des six pays.
* Le calcul du r2, nous indique la force de cette relation : r2 = BSS/TSS = 0,0027 (27.99/10335.479) => r = 0,05. Donc la relation entre les deux variables est de faible intensité.
* Puisqu'on n'a pas pu conclure que les variances sont différentes, on ne va pas regarder les tests de Welch et Brown-Forsythe.
* Dans les tableaux de comparaison des groupes (Multiple Comparisons), on va regarder soit Bonferroni, soit Tukey.
* Les comparaisons de Bonferroni montrent qu'il y a une différence significative (à un IC de 95%) entre la catégorie "très satisfait" et les catégories "plutôt satisfait" et "plutôt insatisfait". La différence par rapport au groupe "très insatisfait" n'est pas significative, au seuil de 0.05. Les autres comparaisons, quant à elles, ne sont pas significatives non plus.
* Le graphique "Means Plots" permettent de visualiser cela.


* Exercice 5.
* Recodage de la variable qa9 en opinion_ue (menu TRANSFORM -> Recode into different variables).
RECODE  qa9
	(MISSING = SYSMIS) (6 = SYSMIS) (1 THRU 2 = 1) (3 = 2) (4 THRU 5 = 3) 
	INTO opinion_ue .
EXECUTE.

* Renseigner la nouvelle variable (opinion_ue)  (Menu DATA -> Define Variable Properties).
* Define Variable Properties.
*opinion_ue.
VARIABLE LEVEL  opinion_ue(ORDINAL).
VARIABLE LABELS  opinion_ue 'Opinion sur UE'.
VALUE LABELS opinion_ue
  1.00 'positive'
  2.00 'neutre'
  3.00 'négative'.
EXECUTE.

* Un graphique de type "boîte à moustaches", pour visualiser la relation entre la taille du ménage et la opinion sur l'Union Européenne (Menu GRAPHS -> Legacy Dialogs -> Boxplot).
EXAMINE VARIABLES=taille_menage BY opinion_ue
  /PLOT=BOXPLOT
  /STATISTICS=NONE
  /NOTOTAL.
* On observe une plus grande étendue vers le haut (tailles plus élevées) du groupe qui a opinion positive, en ce qui concerne la taille du ménage. Le graphique ne permet pas de formuler d'autres hypothèses quant à l'existance d'une relation entre les deux variables.


* ANOVA sur la taille du ménage et l'opinion sur l'Union Européenne.
  ONEWAY taille_menage BY opinion_ue
  /STATISTICS DESCRIPTIVES HOMOGENEITY BROWNFORSYTHE WELCH 
  /PLOT MEANS
  /MISSING ANALYSIS
  /POSTHOC=TUKEY BONFERRONI T3 ALPHA(0.05).
* Regardant le tableau descriptif, les différences de tailles des ménages sont vraiment très faibles, variant de 2.54 (opinion positive) à 2.46 (opinion négative).
* Le deuxième tableau est le test de Levène. Le niveau de signification est légèrement plus grand que le seuil qu'on admet couramment.
* Donc à 95% intervalle de confiance on ne peut pas rejeter H0 d'égalité des variances. On reste donc dans le scénario par défaut, celui de l'hypothèse nulle.
* Ceci signifie qu'on regarde les résultats de l'ANOVA.
* Le niveau de signification de l'ANOVA est beaucoup plus grand que le seuil de 0.05, donc à 95% intervalle de confiance on ne peut pas rejeter H0 d'égalité des moyennes.
* Cela signifie que nous ne pouvons pas affirmer qu'il y a une relation entre la taille du ménage et l'opinion sur l'Union Européenne, en Belgique, Allemagne, France, Italie, Pays-Bas et Luxembourg.
* Puisqu'il n'y a pas une relation significative entre les deux variables, nous ne regardons pas les tests post-hoc et il est inutile de calculer le r/r2.