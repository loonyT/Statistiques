* Encoding: UTF-8.
* Chargement de la base de données. Il faut modifier le chemin du fichier, selon votre ordinateur.
GET
  FILE='Z:\LPOLS1221\db\Eurobarometer_2017.sav'.
DATASET NAME DataSet1 WINDOW=FRONT.

* APPLICATION 1.

* Création d'une nouvelle variable d'âge (Transform -> Recode into Different Variables).
RECODE  d8
	(1 THRU 96 = COPY) (ELSE = SYSMIS) 
	INTO age_educ.
VARIABLE LABELS age_educ "Age fini éducation".
EXECUTE.

* Sélection de l'échantillon belge (Data -> Select Cases -> If condition is satisfied).
USE ALL.
COMPUTE filter_$=(country = 2).
VARIABLE LABELS filter_$ 'country = 2 (FILTER)'.
VALUE LABELS filter_$ 0 'Not Selected' 1 'Selected'.
FORMATS filter_$ (f1.0).
FILTER BY filter_$.
EXECUTE.

* Partager l'échantillon en deux groupes : hommes et femmes (Data -> Split File).
SORT CASES  BY d10.
SPLIT FILE SEPARATE BY d10.

* Le graphique (Graphs -> Legacy Dialogue -> Scatter/Dot).
GRAPH   
        /SCATTERPLOT = d11 WITH age_educ. 
* Au vue des graphiques, il semble y avoir une très, très légère tendance négative, mais on ne peut pas conclure qu'il y a une relation entre les deux variables. 
 
 * Le test de corrélation (Analyze -> Correlate -> Bivariate).
CORRELATION
	/VARIABLES =  d11 age_educ
	/PRINT = TWOTAIL SIG.
* Le test de correlation confirme qu'à un seuil de 0.05 (ou 0.01)  on peut rejeter H0.
* On peut donc conclure qu'il y a une association entre l'âge du répondant et l'âge quand il a terminé ses études.
* Cette association est négative (plus l'âge est élevé, plus le répondant a terminé ses études tôt) et de moyenne intensité.


* APPLICATION 2.
* annuler le Split File (Data -> Split File).
SPLIT FILE OFF.

* Partie 1.
* Recodage de la variable d70 en satisfaction (menu TRANSFORM -> Recode into different variables).
RECODE  d70
	(MISSING = SYSMIS) (5 = SYSMIS)(1 THRU 2 = 1) (3 THRU 4 = 2) 
	INTO satisfaction .
EXECUTE.

* Renseigner la nouvelle variable (satisfaction)  (Menu DATA -> Define Variable Properties).
* Define Variable Properties.
* satisfaction.
VARIABLE LEVEL  satisfaction(NOMINAL).
VARIABLE LABELS  satisfaction 'Satisfaction générale'.
VALUE LABELS satisfaction
  1.00 'satisfait'
  2.00 'pas satisfait'.
EXECUTE. 

* Sélection des pays de l'Union Européenne, sauf la Grande Bretagne et l'Irlande du Nord  (Data -> Select Cases -> If condition is satisfied).
USE ALL.
COMPUTE filter_$=((eu28 = 1) & (country  <> 9) & (country  <> 10)).
VARIABLE LABELS filter_$ '(eu28 = 1) & (country  <> 9) & (country  <> 10) (FILTER)'.
VALUE LABELS filter_$ 0 'Not Selected' 1 'Selected'.
FORMATS filter_$ (f1.0).
FILTER BY filter_$.
EXECUTE.

* Un graphique simple  (Graphs -> Legacy Dialogue -> Bar)..
GRAPH
  /BAR(SIMPLE)=COUNT BY satisfaction.
* La grande majorité des répondants sont plutôt satisfaits.

* Un graphique par sexe, avec des valeurs absolues  (Graphs -> Legacy Dialogue -> Bar).
GRAPH
  /BAR(SIMPLE)=COUNT BY satisfaction
  /PANEL ROWVAR=d10 ROWOP=CROSS.
* Chez les hommes et chez les femmes, la majorité est satisfaite.
* Pour mieux voir si les hommes/femmes sont plus souvent satisfaits de leur vie, on doit utiliser des pourcentages.
  
* Un graphique par sexe, avec des pourcentages   (Graphs -> Legacy Dialogue -> Bar).
 GRAPH
  /BAR(SIMPLE)=PCT BY satisfaction
  /PANEL ROWVAR=d10 ROWOP=CROSS.
* On voit que les femmes sont légèrement moins satisfaites. On pourrait tester cela avec un test de Chi-carré (Analyze -> Descriptives - > Crosstabs).
CROSSTABS
  /TABLES=d10 BY satisfaction
  /FORMAT=AVALUE TABLES
  /STATISTICS=CHISQ PHI 
  /CELLS=COUNT ROW 
  /COUNT ROUND CELL.
* En effet, il y a une relation significative, au seuil de 0.05, entre les deux variables, mais elle est de très, très faible intensité.


* Partie 2.
* Création de la nouvelle variable, qui compte le nombre de biens de longue durée detenus par le répondant (valeur cible 1) (Transform - > Count Values within Cases).
COUNT richesse=d46.1 d46.10 d46.11 d46.12 d46.13 d46.2 d46.3 d46.4 d46.5 d46.6 d46.7 d46.8 d46.9(1).    
EXECUTE.
* Elle aura un minimum possible de 0 et un maximum possible de 11 (le nombre de variables comptées).

* Paramétrage (Data -> Define Variable Properties).
* Define Variable Properties.
*richesse.
VARIABLE LEVEL  richesse(SCALE).
VARIABLE LABELS  richesse "Index sommatif de richesse".
EXECUTE.

* Exploration de la nouvelle variable (Analyze - > Descriptives -> Explore).
EXAMINE VARIABLES=richesse
  /PLOT BOXPLOT HISTOGRAM NPPLOT
  /COMPARE GROUPS
  /STATISTICS DESCRIPTIVES
  /CINTERVAL 95
  /MISSING LISTWISE
  /NOTOTAL.
* Les individus ont minimum un objet et maximum 11.
* En moyenne, ils ont 6.21 objets. La médiane est de 7, ce qui suggère quelques cas plus extrèmes vers le bas.
* Le skewness négatif confirme cela.
* La distribution est plus aplatie qu'une normale (kurtosis).
* Le test de K-S confirme que la distribution ne suit pas une loi normale.


* Partie 3.	
	
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
        
* Le graphique. On utilise des pourcentages, pour faciliter la comparaison (Graphs -> Legacy Dialogue -> Bar).
GRAPH
  /BAR(GROUPED)=PCT BY classe_soc BY satisfaction.
* Le graphique indique qu'au plus la classe sociale est basse, au plus la proportion de personnes insatisfaites est élevée (~60% vs ~30% vs ~5%)
	
* Partie 4.
* Analyse de la satisfaction en fonction de l'âge  (Graphs - > Legacy Dialogue -> Boxplot).
EXAMINE d11 BY satisfaction
        /PLOT = BOXPLOT
        /TOTAL.
* Les personnes pas satisfaites ont l'air d'être plus âgées que celles qui se déclarent satisfaites.

* Partie 5.
 * Le test de corrélation.
CORRELATIONS
  /VARIABLES=d11 richesse
  /PRINT=TWOTAIL NOSIG
  /MISSING=PAIRWISE.
* A un seuil de 0.01 on peut rejeter H0 de manque d'association.
* On conclut alors qu'il y a une association significative entre l'âge et l'index de richesse.
* Cette relation est négative (au plus on est âgé, au moins on a un score élevé sur l'index de richesse construit).
