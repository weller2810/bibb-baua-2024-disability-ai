* Programname: 04_abbildungen.do
* Projekt: BIBB/BAuA-Erwerbstaetigenbefragung 2024
* Thema: Diversitaet, Digitalisierung und Disparitaeten
* Autorin: Sabrina Weller, BIBB
* Datum: 15.06.2026

/*
Dieses Do-File erstellt Abbildungen auf Basis der
multivariaten Modelle.
*/

clear all
set more off

//////////////////////////////////////////////////////////
//////////////////// 1. Projektpfad //////////////////////
//////////////////////////////////////////////////////////

global projekt ///
"P:/2-Veröffentlichungen/2026/4-Sammelband Diversität_Digitalisierung_Disparitäten/2-Berechnungen"

capture log close

log using ///
"${projekt}/3-Output/04_abbildungen.log", ///
replace text

//////////////////////////////////////////////////////////
//////////////////// 2. Daten einlesen ///////////////////
//////////////////////////////////////////////////////////

use ///
"${projekt}/1-Daten/etb2024_analyse_ki_weiterbildung_behinderung.dta", ///
clear

//////////////////////////////////////////////////////////
//////////////////// 3. Kontrollvariablen ////////////////
//////////////////////////////////////////////////////////

local kontrollen_sozio ///
i.S1 ///
c.zpalter ///
i.S3 ///
i.B1202

local kontrollen_arbeit ///
i.F400 ///
i.F515 ///
i.F512 ///
i.F301

local kontrollen_digital ///
i.F318 ///
i.F331 ///
i.F332 ///
i.F333 ///
i.F334

local kontrollen ///
`kontrollen_sozio' ///
`kontrollen_arbeit' ///
`kontrollen_digital'

//////////////////////////////////////////////////////////
//////////////////// 4. Abbildung H4 /////////////////////
//////////////////////////////////////////////////////////

* Modell zur Interaktion von Behinderung und KI-Nutzung.
logit weiterbildung ///
i.behinderung##i.ki_nutzung ///
`kontrollen'

margins behinderung#ki_nutzung

marginsplot, ///
ytitle("Vorhergesagte Wahrscheinlichkeit") ///
xtitle("Behinderung und KI-Nutzung") ///
title("Weiterbildungsbeteiligung nach Behinderung und KI") ///
name(abbildung_h4, replace)

graph export ///
"${projekt}/3-Output/abbildung_h4_weiterbildung_behinderung_ki.png", ///
replace width(2000)

//////////////////////////////////////////////////////////
//////////////////// 5. Abbildung Zusatzmodell ///////////
//////////////////////////////////////////////////////////

* Modell zur Interaktion von Behinderung und KI-Intensitaet.
logit weiterbildung ///
i.behinderung##i.ki_intensitaet ///
`kontrollen'

margins behinderung#ki_intensitaet

marginsplot, ///
ytitle("Vorhergesagte Wahrscheinlichkeit") ///
xtitle("KI-Nutzungsintensitaet") ///
title("Weiterbildung nach Behinderung und KI-Intensitaet") ///
name(abbildung_intensitaet, replace)

graph export ///
"${projekt}/3-Output/abbildung_z1_weiterbildung_behinderung_ki_intensitaet.png", ///
replace width(2000)

//////////////////////////////////////////////////////////
//////////////////// 6. Abschluss ////////////////////////
//////////////////////////////////////////////////////////

log close

display "Abbildungen erfolgreich abgeschlossen."