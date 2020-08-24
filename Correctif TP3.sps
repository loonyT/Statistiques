* Encoding: UTF-8.
* Chargement de la base de donn�es. Il faut modifier le chemin du fichier, selon votre ordinateur.
GET
  FILE='Z:\Q1\LPOLS1221\db\Eurobarometer_2017.sav'.
DATASET NAME DataSet1 WINDOW=FRONT.

* EXERCICE 1.
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

* Tableau crois� entre la confiance dans le gouvernement national et l'opinion sur l'Union Europ�enne (menu ANALYZE -> Descriptive statistics -> Crosstabs).
CROSSTABS
  /TABLES=qa8a_7 BY opinion_ue
  /FORMAT=AVALUE TABLES
  /STATISTICS=CHISQ PHI 
  /CELLS=COUNT ROW 
  /COUNT ROUND CELL.
* Les conditions d'application du test sont remplies.  
* Regardant le tableau, on observe qu'une proportion plus �lev�e de ceux qui font confiance � leur gouvernement a une opinion favorable de l'UE, par rapport � ceux qui ne font pas confiance � leur gouvernement.
* Regardant le tableau Chi-carr�, on observe que la p-value est tr�s petite (plus petite que 0,001), donc le risque de se tromper en rejettant l'hypoth�se nulle (de manque d'association entre les deux variables) est tr�s faible.
* On peut donc rejetter l'hypoth�se nulle et conclure qu'il y a une association significative entre la confiance dans le gouvernement et l'opinion sur l'UE, pour la population europ�enne.
* Regardant le V de Cramer, on peut conclure que l'association est de moyenne intensit�.
  
  
 * EXERCICE 2.
  * S�lection des ressortissants belges (menu DATA -> Select cases -> If condition is satisfied).
USE ALL.
COMPUTE filter_$=(country = 2).
VARIABLE LABELS filter_$ 'country = 2 (FILTER)'.
VALUE LABELS filter_$ 0 'Not Selected' 1 'Selected'.
FORMATS filter_$ (f1.0).
FILTER BY filter_$.
EXECUTE.

* Tableau crois� entre la confiance dans le gouvernement national et l'opinion sur l'Union Europ�enne (menu ANALYZE -> Descriptive statistics -> Crosstabs).
 * On aurait pu tout simplement re-ex�cuter la commande de l'Exercice 1.
CROSSTABS
  /TABLES=qa8a_7 BY opinion_ue
  /FORMAT=AVALUE TABLES
  /STATISTICS=CHISQ PHI 
  /CELLS=COUNT ROW 
  /COUNT ROUND CELL.
 * Les conditions d'application du test sont remplies.   
  * Regardant le tableau, on observe que, compar� � ceux qui ne font pas confiance � leur gouvernement, chez ceux qui font confiance � leur gouvernement il y a une proportion plus que double qui a une opinion favorable de l'UE.
* Regardant le tableau Chi-carr�, on observe que la p-value est tr�s petite (plus petite que 0,001), donc le risque de se tromper en rejettant l'hypoth�se nulle (de manque d'association entre les deux variables) est tr�s faible.
* On peut donc rejetter l'hypoth�se nulle et conclure qu'il y a une association significative entre la confiance dans le gouvernement et l'opinion sur l'UE, pour la population belge.
* Regardant le V de Cramer, on peut conclure que l'association est de moyenne intensit�, mais l�g�rement plus forte que pour la population europ�enne dans son ensemble..

* EXERCICE 3.
  * S�lection sur l'�ge (menu DATA -> Select cases -> If condition is satisfied).
USE ALL.
COMPUTE filter_$=((d11 >= 15) & (d11 < 65)).
VARIABLE LABELS filter_$ '(d11 >= 15) & (d11 < 65) (FILTER)'.
VALUE LABELS filter_$ 0 'Not Selected' 1 'Selected'.
FORMATS filter_$ (f1.0).
FILTER BY filter_$.
EXECUTE.

 * Recodage de la variable d11 en age_cat (menu TRANSFORM -> Recode into different variables).
RECODE  d11
	(MISSING = SYSMIS) (15 THRU 24 = 1) (25 THRU 54 = 2) (55 THRU 64 = 3) 
	INTO age_cat .
EXECUTE.

* Renseigner la nouvelle variable (age_cat)  (Menu DATA -> Define Variable Properties).
* Define Variable Properties.
* age_cat.
VARIABLE LEVEL  age_cat(ORDINAL).
VARIABLE LABELS  age_cat 'Groupe �ges'.
VALUE LABELS age_cat
  1.00 '�tudiant'
  2.00 'travailleur adulte'
  3.00 'travailleur �g�'.
EXECUTE.
	
CROSSTABS
  /TABLES=age_cat BY opinion_ue
  /FORMAT=AVALUE TABLES
  /STATISTICS=CHISQ PHI 
  /CELLS=COUNT ROW 
  /COUNT ROUND CELL.
* Les conditions d'application du test sont remplies.  
* Dans le tableau, on observe que les r�pondants plus jeunes sont en plus grande proportion favorables � l'UE et qu'une proportion plus �lev�e des personnes matures a une opinion d�favorable de l'UE, compar� aux deux autres cat�gories d'�ge.
* La p-value du test Chi-carr� confirme que cette association est significative pour la population adulte en �ge de travailler.
* Regardant le V de Cramer, on peut conclure que l'association est, pourtant, faible.

* EXERCICE 4.
CROSSTABS
  /TABLES=d1r1 BY opinion_ue 
  /FORMAT=AVALUE TABLES
  /STATISTICS=CHISQ PHI 
  /CELLS=COUNT ROW 
  /COUNT ROUND CELL.
* Les conditions d'application du test sont remplies.
* Dans le tableau, on observe que les r�pondants "de gauche" en plus grande proportion favorables � l'UE, compar� aux deux autres cat�gories d'orientation politique.
* On remarque aussi que la plus grande proportion d'opinions n�gatives se trouve chez les personnes "de droite".
* La p-value du test Chi-carr� confirme que cette association est significative pour la population adulte en �ge de travailler.
* Regardant le V de Cramer, on peut conclure que l'association est, aussi, faible.


* EXERCICE 5.
  * S�lection des ressortissants fran�ais (menu DATA -> Select cases -> If condition is satisfied).
USE ALL.
COMPUTE filter_$=(country = 1).
VARIABLE LABELS filter_$ 'country = 1 (FILTER)'.
VALUE LABELS filter_$ 0 'Not Selected' 1 'Selected'.
FORMATS filter_$ (f1.0).
FILTER BY filter_$.
EXECUTE.
 
 CROSSTABS 
	/TABLES= d25 BY d1r1
	/FORMAT=AVALUE TABLES
	/STATISTICS=CHISQ PHI
	/CELLS=COUNT ROW.
* Les conditions d'application du test sont remplies.
* Regardant le tableau crois�, on observe que les r�pondants du milieu urbain sont plus souvent "de gauche" que les r�pondants du milieu rural. La cat�gorie la plus "de droite" sont les habitants des petites et moyennes villes.
* Regardant le tableau Chi-carr�, on observe que la p-valeur est plus basse que 0.05, donc le risque de se tromper en rejettant l'hypoth�se nulle (de manque d'association entre les deux variables) est plus faible que le risque maximal que l'on est dispos�s � accepter.
* On peut donc rejetter l'hypoth�se nulle et conclure qu'il y a une association significative entre le milieu de r�sidence et l'orientation politique, pour la population fran�aise.
* Regardant le V de Cramer, on peut conclure que l'association est de faible intensit�.

  * S�lection des ressortissants italiens (menu DATA -> Select cases -> If condition is satisfied).
USE ALL.
COMPUTE filter_$=(country = 5).
VARIABLE LABELS filter_$ 'country = 5 (FILTER)'.
VALUE LABELS filter_$ 0 'Not Selected' 1 'Selected'.
FORMATS filter_$ (f1.0).
FILTER BY filter_$.
EXECUTE.


* On peut tout simplement re-ex�cuter la commande CROSSTABS pr�c�dente, pour avoir le même test pour la population italienne.
CROSSTABS 
	/TABLES= d25	BY	 d1r1
	/FORMAT=AVALUE TABLES
	/STATISTICS=CHISQ PHI
	/CELLS=COUNT ROW.
* Les conditions d'application du test sont remplies.
* Regardant le tableau crois�, on observe que, compar� � l'�chantillon fran�ais, dans l'�chantillon italien ce sont les habitants du milieu rural qui sont plus souvent "de gauche" que les habitants du milieu urbain. La cat�gorie la plus "de droite" sont toujours les habitants des petites et moyennes villes.
* Regardant le tableau Chi-carr�, on observe que la p-value est plus basse que 0.05, donc le risque de se tromper en rejettant l'hypoth�se nulle (de manque d'association entre les deux variables) est plus faible que le risque maximal que l'on est dispos�s � accepter.
* On peut donc rejetter l'hypoth�se nulle et conclure qu'il y a une association significative entre le milieu de r�sidence et l'orientation politique, pour la population italienne.
* Regardant le V de Cramer, on peut conclure que l'association est aussi de faible intensit�.
	
	




