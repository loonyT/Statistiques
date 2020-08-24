* Encoding: UTF-8.
*Importation des données, peut se faire également via un copié-collé en omettant de copier les numéros de lignes et les titres de colonnes.
        GET DATA /TYPE=XLSX
          /FILE='Z:\Charges assistanat\POLS1221 - Analyse quantitative\2016-2017\exo-TP1.xlsx'
          /SHEET=name 'Feuil1'
          /CELLRANGE=range 'B1:K21'
          /READNAMES=on
          /ASSUMEDSTRWIDTH=32767.
        EXECUTE.
        DATASET NAME DataSet2 WINDOW=FRONT.
*Documenter les variables soit manuellement, soit via l'option define variable properties. 
        * Define Variable Properties.
        *age.
        VARIABLE LABELS  age 'Âge des individus (mois) au moment de l’enquête'.
        *sexe.
        VARIABLE LEVEL  sexe(NOMINAL).
        VARIABLE LABELS  sexe 'Sexe des individus '.
        VALUE LABELS sexe
          1.0 'Homme'
          2.0 'Femme'.
        *taille.
        VARIABLE LEVEL  taille(SCALE).
        VARIABLE LABELS  taille 'Taille des individus (cm) au moment de l’enquête'.
        *poids.
        VARIABLE LABELS  poids 'Poids des individus (kg) au moment de l’enquête'.
        *option.
        VARIABLE LABELS  option 'Option choisie par les étudiants'.
        VALUE LABELS option
          'Eco' 'Economie'
          'LG ' 'Latin-Grec'
          'SS ' 'Sciences Sociales'
          'Sc ' 'Sciences'.
        *note_frcs.
        VARIABLE LABELS  note_frcs 'Note finale (sur 100) obtenue en cours de Français'.
        VALUE LABELS note_frcs.
        *note_math.
        VARIABLE LABELS  note_math 'Note finale (sur 100) obtenue en cours de Mathématique'.
        *note_gh.
        VARIABLE LABELS  note_gh 'Note finale (sur 100) obtenue en cours de Géographie-Histoire'.
        *note_option.
        VARIABLE LABELS  note_option 'Note finale (sur 100) obtenue en cours à option'.
        *instr_père.
        VARIABLE LEVEL  instr_père(ORDINAL).
        VARIABLE LABELS  instr_père 'Niveau d’instruction le plus élevé obtenu par le père du répondant '.
        VALUE LABELS instr_père
          1.0 'Primaire'
          2.0 'Secondaire'
          3.0 'Supérieur'.
        EXECUTE.
*Création de la variable BMI. 
        COMPUTE BMI=poids / ((taille / 100) ** 2).
        EXECUTE.
*Création d'une variable catégorielle BMI. 
        RECODE BMI (Lowest thru 18.5=1) (18.5 thru 24.9=2) (25 thru 29.9=3) (29.9 thru Highest=4) INTO 
            BMI_cat.
        VARIABLE LABELS  BMI_cat 'Catégories de BMI'.
        EXECUTE.
*Renommer les catégories. 
        * Define Variable Properties.
        *BMI_cat.
        VARIABLE LEVEL  BMI_cat(ORDINAL).
        VALUE LABELS BMI_cat
          1.00 'Insuffisance pondérale'
          2.00 'Corpulence normale'
          3.00 'Surpoids'
          4.00 'Obésité'.
        EXECUTE.
*Dichotomisation: deux possibilités: recode OU count. 
       COUNT corpulence=BMI_cat(2).
        VARIABLE LABELS  corpulence 'Type de corpulence'.
        EXECUTE.
        * Define Variable Properties.
        *corpulence.
        VALUE LABELS corpulence
          .00 'Corpulence anormale'
          1.00 'Corpulence normale'.
        EXECUTE.
*Calcul d'une moyenne pondérée: compute. 
        COMPUTE Moyenne=(note_frcs * 5 + note_math * 5 + note_gh * 2 + note_option * 4) / 16.
        EXECUTE.
        COMPUTE Moyenne_20=Moyenne / 5.
        EXECUTE.
*Création de la variable de grade: recode.  
        RECODE Moyenne_20 (Lowest thru 9.9999=1) (10 thru 13.9=2) (14 thru 15.99=3) (16 thru 17.99=4) (18 
            thru Highest=5) INTO Grade.
        VARIABLE LABELS  Grade 'Grade obtenu'.
        EXECUTE.
        * Define Variable Properties.
        *Grade.
        VARIABLE LEVEL  Grade(ORDINAL).
        VALUE LABELS Grade
          1.00 'Ajournement'
          2.00 'Satisfaction'
          3.00 'Distinction'
          4.00 'Grande distinction'
          5.00 'Félicitations du jury'.
        EXECUTE.
*Création variable réussite: recode ou count. 
        COUNT Réussite=Moyenne_20(10 thru Highest).
        EXECUTE.
        * Define Variable Properties.
        *Réussite.
        VALUE LABELS Réussite
          .00 'échec'
          1.00 'Réussite'.
        EXECUTE.
*Pour cela, il faut aller dans count et renseigner plusieurs variables.
        COUNT Dispenses=note_frcs note_math note_gh note_option(50 thru Highest).
        EXECUTE.