Get File = "C:\Users\Dieser PC\Desktop\Uni\allbus2016.sav".
DATASET NAME DataSet1 Window=Front.
DATASET ACTIVATE DataSet1.

Set PRINTBACK = Listing.
Set TVARS = Both.
Set TNUMBERS = Both.
Set OLANG = GERMAN.

*Autor: Gruß
*Datum: 31.12.2018

fre eastwest.

*Gewichtung*

Weight By wghtpew.

*Häufigkeitstabelle*

fre sex.

*Deskriptive Statistiken*

FREQUENCIES inc
/STATISTICS mean median.

Examine inc.

*Säulendiagramm*

GRAPH
/BAR=PCT BY educ
/INTERVAL CI (95.0)
/TITLE="Allgemeiner Schulabschluss".

*Kuchendiagramm*

GRAPH
/PIE=pa02a
/TITLE="Politisches Interesse".

*Histogramm*

GRAPH
/HISTOGRAM=pa01
/TITLE="LinksRechts Selbsteinstufung".

*Boxplot*

EXAMINE mp14
/PLOT=Boxplot
/Statistics=NONE.

*Boxplot für mehrere Variablen*

EXAMINE mp13 mp14
/COMPARE Variables
/PLOT=Boxplot
/Statistics=None.

*Säulendiagramm für Mittelwerte*

GRAPH
/BAR=MEAN(mp13) MEAN(mp14)
/INTERVAL CI(95).

*Kreuztabellen für nominale Zusammenhänge*

CROSSTABS mc09 BY mc01
/CELLS ROW
/STATISTICS PHI CC LAMBDA.

*Kreuztabelle für nominalen Zusammenhang*

CROSSTABS mc09 BY mc10
/STATISTICS  BTAU CTAU D GAMMA CORR.

*Gruppierte Säulendiagramme*

GRAPH
/BAR(GROUPED)= PCT BY mc09 BY mc01.

*Korrelationsmatrix*

CORRELATIONS mp01 mp12.
CORRELATIONS mp01 TO mp12.

*Streudiagramm*

GRAPH
/SCATTERPLOT=mp13 with mp14.

*Gewichtung ausschalten*

WEIGHT OFF.

