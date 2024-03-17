* Encoding: UTF-8.
TITLE Statistischer Bericht.
SUBTITLE  3 Statistische Analysen für das Seminar "Einführung in die Datenaufbereitung mit SPSS".

GET FILE "C:\Users\Dieser PC\Desktop\Uni\allbus2016.sav".

*0. Verwendete Variablen: AV: ls01; UV: dh05+dh04 (Kombination beider Variablen).

FREQ ls01
/statistics mean median.

*->Kodierung von 0 bis 10. Sehr wenige Fälle in den Kategorien 0-5. Problem bei logistischer Regression?

FREQ dh04.
FREQ dh05.
FREQ dh07.

*->Kodierung einer Variable, die ausgibt wieviele Kinder im Haushalt leben:
*erster Schritt: leben Kinder im Haushalt, ja oder nein?
*wichtige Infos auf Seite 951 des Codebuchs
 
RECODE dh05 (MISSING = SYSMIS) (10 20 30 40 = 0) 
(51 52 61 64 71 81 91 93 101 102 111 112 121 122 132 140= 1) (ELSE = SYSMIS) INTO kinder.
VARIABLE LABELS kinder "Leben Kinder im Haushalt?".
VALUE LABELS kinder
0 "keine Kinder"
1 "Kinder im Haushalt".

*->Wenn Befragter = Kind oder Enkel => MISSING
*->Wenn Befragter = Eltern- oder Großelternteil => 1

FREQ kinder.
CROSSTABS dh05 BY kinder.


*->325 MISSINGS, 1094 Haushalte mit Kindern, 2071 Haushalte ohne Kinder

*1. Sind Eltern mit Kindern im Schnitt zufriedener als Leute ohne Kinder im Haushalt?

T-TEST Groups = kinder(0,1)
/variables ls01.

*2. Haben Eltern mit Kindern im Haushalt eine im Schnitt höhere Wahrscheinlichkeit, unzufrieden 
* zu sein als Leute ohne Kinder im Haushalt?

*Einfache lineare Regression:

REGRESSION
/MISSING LISTWISE
/STATISTICS = COEFF R
/DEPENDENT ls01
/METHOD = ENTER kinder.

*->signifikanter, aber sehr geringer Zusammenhang zwischen Kindern im Haushalt und Lebens-
* zufriedenheit
auf 5er-Skala:

RECODE ls01 (MISSING = SYSMIS) (0 THRU 5 = 0) (6 = 1) (7 = 2) (8=3) (9=4) (10=5) INTO zufrieden.
VARIABLE LABELS  zufrieden "Zufriedenheits-Skala".
VALUE LABELS zufrieden
0 "unzufrieden"
5 "zufrieden".

FREQ zufrieden.

REGRESSION
/MISSING LISTWISE
/STATISTICS = COEFF R
/DEPENDENT zufrieden
/METHOD = ENTER kinder.

*nicht signifikanter Zusammenhang ->mit dichotomer Zufrienheit probieren!

REGRESSION
/MISSING LISTWISE
/STATISTICS = COEFF R
/DEPENDENT zufriedendichotom2
/METHOD = ENTER kinder.

T-TEST Groups = kinder(0,1)
/variables zufriedendichotom2.

*->zwar signifikant, aber geringerer Zusammenhang, als bei nicht dichotomer Zufriedenheit

*Logistische Regression: Rekodieren der Lebenszufriedenheit 

RECODE ls01 (MISSING = SYSMIS) (0 THRU 7 = 0) (8 THRU 10 =1) INTO zufriedendichotom.
VARIABLE LABELS  zufriedendichotom "Zufriedenheits-Skala".
VALUE LABELS zufriedendichotom
0 "unzufrieden"
1 "zufrieden".

FREQ zufriedendichotom.

LOGISTIC REGRESSION VARIABLES zufriedendichotom
/METHOD = ENTER kinder
/CONTRAST (kinder) = INDICATOR (1).

*signifikanter Zusammenhang. Menschen in Haushalten mit Kindern sind mit höherer Wahrscheinlichkeit
* zufrieden als Menschen in Haushalten ohne Kinder (nur stark zufriedene Menschen; siehe Rekodierung)

RECODE ls01 (MISSING = SYSMIS) (0 THRU 5 = 0) (6 THRU 10 =1) INTO zufriedendichotom2.
VARIABLE LABELS zufriedendichotom2 "Zufriedenheits-Skala".
VALUE LABELS zufriedendichotom2
0 "unzufrieden"
1 "zufrieden".

T-TEST Groups = kinder(0,1)
/variables .


LOGISTIC REGRESSION VARIABLES zufriedendichotom2
/METHOD = ENTER kinder
/CONTRAST (kinder) = INDICATOR (1).

*bei einer Kodierung von 0-5 (unzufrieden) und 6-10(zufrieden) ergibt sich ein signifikanteres Ergebnis
* R² immernoch schlecht

***=> Antwort auf die Frage: Nein, Haushalte mit Kindern sind eher zufriedener

*3. Besteht der Zusammenhang immer noch, wenn man berücksichtigt, dass Elternschaft oft mit 
* weniger Wohlstand einhergeht, niedrig gebildete Menschen eher Kinder bekommen etc.
* (multiple, genestete Regressionen; Logit)?

FREQ hhinc.
FREQ educ.

RECODE educ (MISSING = SYSMIS) (6 7 =SYSMIS) (1=1) (ELSE = 0) INTO ohneabschluss.
RECODE educ (MISSING = SYSMIS) (6 7 =SYSMIS) (2=1) (ELSE = 0) INTO haupt.
RECODE educ (MISSING = SYSMIS) (6 7 =SYSMIS) (4 5=1) (ELSE = 0) INTO abi.

REGRESSION
/MISSING LISTWISE
/STATISTICS = COEFF R
/DEPENDENT ls01
/METHOD = ENTER kinder hhinc ohneabschluss haupt abi.

LOGISTIC REGRESSION VARIABLES zufriedendichotom2
/METHOD = ENTER kinder hhinc ohneabschluss haupt abi
/CONTRAST (kinder) = INDICATOR (1)
/CONTRAST (ohneabschluss) = INDICATOR (1)
/CONTRAST (haupt) = INDICATOR (1)
/CONTRAST (abi) = INDICATOR (1).

*3. Wie stark verändert sich der Effekt, Kinder im Haushalt zu haben bei sukzessiver Aufnahme
*  von Kontrollvariablen (multiple, genestete Regressionen; LPM)?

*Variablen: l014_1 von zuhause arbeiten
*l014_2 am wochenende arbeiten
*l013_2 wie oft stress ma arbeitsplatz?
*eastwest
