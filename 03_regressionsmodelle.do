* Programname: 03_regressionsmodelle.do
* Projekt: BIBB/BAuA-Erwerbstaetigenbefragung 2024
* Thema: Diversitaet, Digitalisierung und Disparitaeten
* Programmaufgabe:
/*
Dieses Do-File schaetzt logistische Regressionsmodelle
zum Zusammenhang zwischen beruflicher Weiterbildung,
Behinderung und KI-Nutzung.

Grundlage ist der im Do-File
01_variablenaufbereitung.do erzeugte Analysedatensatz.
*/

* Autorin: Sabrina Weller, BIBB
* Erstellt: 26.06.2026
* Letzte Aktualisierung: 26.06.2026

*******************************************************
* Systemeinstellungen
*******************************************************

clear all
version 18.0
capture log close

set more off
set linesize 90
set maxvar 10000

//////////////////////////////////////////////////////////
//////////////////// 1. Projektpfade /////////////////////
//////////////////////////////////////////////////////////

global projekt ///
  "P:/2-Veröffentlichungen/2026/4-Sammelband Diversität_Digitalisierung_Disparitäten/2-Berechnungen"

global datenpfad "${projekt}/1-Daten"
global outputpfad "${projekt}/3-Output"

display as text "Outputpfad: ${outputpfad}"

capture cd "${outputpfad}"
if _rc != 0 {
  display as error "Outputpfad nicht erreichbar."
  exit 603
}

//////////////////////////////////////////////////////////
//////////////////// 2. Log-Datei starten ////////////////
//////////////////////////////////////////////////////////

capture log close

log using ///
  "${outputpfad}/03_regressionsmodelle.log", ///
  replace text

//////////////////////////////////////////////////////////
//////////////////// 3. Daten einlesen ///////////////////
//////////////////////////////////////////////////////////

use ///
  "${datenpfad}/etb2024_analyse_ki_weiterbildung_behinderung.dta", ///
  clear

//////////////////////////////////////////////////////////
//////////////////// 4. Kontrollvariablen ////////////////
//////////////////////////////////////////////////////////

global kontrollen ///
  i.S1 ///
  c.zpalter ///
  i.S3 ///
  i.B1202 ///
  i.F400 ///
  i.F515 ///
  i.F512 ///
  i.F301 ///
  i.F318 ///
  i.F331 ///
  i.F332 ///
  i.F333 ///
  i.F334

display as text "Kontrollvariablen: ${kontrollen}"

//////////////////////////////////////////////////////////
//////////////////// 5. Fallzahlpruefung ////////////////
//////////////////////////////////////////////////////////

* Sondercodes in Missing umwandeln.
mvdecode B1202 F515, mv(99)
mvdecode F400, mv(8 9)
mvdecode F512 F301 F318, mv(9)
mvdecode F331 F332 F333 F334, mv(9)

* Pruefung der Analyse- und Kontrollvariablen.
misstable summarize ///
  weiterbildung ///
  behinderung ///
  schwere_behinderung ///
  ki_nutzung ///
  ki_intensitaet ///
  neue_ki_nutzung ///
  S1 ///
  zpalter ///
  S3 ///
  B1202 ///
  F400 ///
  F515 ///
  F512 ///
  F301 ///
  F318 ///
  F331 ///
  F332 ///
  F333 ///
  F334

codebook F400 F512 F301 F318

//////////////////////////////////////////////////////////
//////////////////// 6. Hypothesentests //////////////////
//////////////////////////////////////////////////////////

/*
H1:
Erwerbstaetige mit amtlich anerkannter Behinderung nehmen
seltener an beruflicher Weiterbildung teil.
*/

logit weiterbildung ///
  i.behinderung ///
  ${kontrollen}, or

estimates store h1_weiterbildung
display as text "Analysefaelle H1: " e(N)

/*
H2:
Erwerbstaetige mit amtlich anerkannter Behinderung nutzen
KI-Technologien bei der Arbeit seltener.
*/

logit ki_nutzung ///
  i.behinderung ///
  ${kontrollen}, or

estimates store h2_ki_nutzung
display as text "Analysefaelle H2: " e(N)

/*
H3:
Erwerbstaetige mit KI-Nutzung nehmen haeufiger an
beruflicher Weiterbildung teil.
*/

logit weiterbildung ///
  i.ki_nutzung ///
  i.behinderung ///
  ${kontrollen}, or

estimates store h3_ki_weiterbildung
display as text "Analysefaelle H3: " e(N)

/*
H4:
Der Zusammenhang zwischen KI-Nutzung und Weiterbildung
unterscheidet sich zwischen Erwerbstaetigen mit und ohne
amtlich anerkannte Behinderung.
*/

logit weiterbildung ///
  i.behinderung##i.ki_nutzung ///
  ${kontrollen}, or

estimates store h4_interaktion
display as text "Analysefaelle H4: " e(N)

margins behinderung#ki_nutzung

/*
H5:
Erwerbstaetige, die KI erstmals in den letzten zwei Jahren
genutzt haben, nehmen haeufiger an beruflicher Weiterbildung
teil.

Dieses Modell bezieht sich nur auf Personen mit KI-Nutzung,
da neue_ki_nutzung nur fuer diese Gruppe definiert ist.
*/

logit weiterbildung ///
  i.neue_ki_nutzung ///
  i.behinderung ///
  ${kontrollen} ///
  if ki_nutzung == 1, or

estimates store h5_neue_ki
display as text "Analysefaelle H5: " e(N)

//////////////////////////////////////////////////////////
//////////////////// 7. Zusatzmodelle ////////////////////
//////////////////////////////////////////////////////////

/*
Zusatzmodell 1:
Statt der dichotomen KI-Nutzung wird die Intensitaet der
KI-Nutzung beruecksichtigt.
*/

logit weiterbildung ///
  i.behinderung##i.ki_intensitaet ///
  ${kontrollen}, or

estimates store z1_ki_intensitaet
display as text "Analysefaelle Z1: " e(N)

margins behinderung#ki_intensitaet

/*
Zusatzmodell 2:
Statt der amtlich anerkannten Behinderung wird
Schwerbehinderung verwendet.
*/

logit weiterbildung ///
  i.schwere_behinderung##i.ki_nutzung ///
  ${kontrollen}, or

estimates store z2_schwere_behinderung
display as text "Analysefaelle Z2: " e(N)

margins schwere_behinderung#ki_nutzung


//////////////////////////////////////////////////////////
//////////////////// 8. Tabelle ////////////////////
//////////////////////////////////////////////////////////


esttab h1_weiterbildung ///
       h2_ki_nutzung ///
       h3_ki_weiterbildung ///
       h4_interaktion ///
       h5_neue_ki ///
using "${outputpfad}/Regressionstabelle.rtf", ///
replace ///
eform ///
b(3) se(3) ///
star(* 0.05 ** 0.01 *** 0.001) ///
stats(N ll r2_p, ///
labels("N" "Log Likelihood" "Pseudo R²")) ///
label

//////////////////////////////////////////////////////////
//////////////////// 9. Modelle speichern ////////////////
//////////////////////////////////////////////////////////

estimates save ///
  "${outputpfad}/modelle_ki_weiterbildung_behinderung", ///
  replace

//////////////////////////////////////////////////////////
//////////////////// 9. Programmende /////////////////////
//////////////////////////////////////////////////////////

log close

display as text ///
  "Regressionsmodelle erfolgreich abgeschlossen."