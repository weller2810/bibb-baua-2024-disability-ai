* Programname: 01_variablenaufbereitung.do
* Projekt: BIBB/BAuA-Erwerbstaetigenbefragung 2024
* Thema: Diversitaet, Digitalisierung und Disparitaeten
* Autorin: Sabrina Weller, BIBB
* Datum: 26.06.2026

/*
Dieses Do-File liest den SUF der BIBB/BAuA-
Erwerbstaetigenbefragung 2024 ein, erzeugt die zentralen
Analysevariablen fuer die Untersuchung von KI-Nutzung,
Weiterbildung und Behinderung und speichert einen
Analysedatensatz.
*/

clear all
version 18.0
capture log close
set more off
set linesize 90
set maxvar 10000

//////////////////////////////////////////////////////////
//////////////////// 1. Projektpfad //////////////////////
//////////////////////////////////////////////////////////

global projekt ///
"P:/2-Veröffentlichungen/2026/4-Sammelband Diversität_Digitalisierung_Disparitäten/2-Berechnungen"

//////////////////////////////////////////////////////////
//////////////////// 2. Daten einlesen ///////////////////
//////////////////////////////////////////////////////////

use "${projekt}/1-Daten/BIBBBAuA_2024_suf1.0.dta", clear

//////////////////////////////////////////////////////////
//////////////////// 3. Variablen prüfen /////////////////
//////////////////////////////////////////////////////////

describe F1300 F1514 F1514c F335 F336 F337
codebook F1300 F1514 F1514c F335 F336 F337

tab F335 F336, missing
tab F335 F337, missing

mvdecode F1300 F1514 F1514c F335 F336 F337, mv(9)

replace F335 = . if F335 == 3

tab F335, missing
tab F336, missing
tab F337, missing

//////////////////////////////////////////////////////////
//////////////////// 4. Weiterbildung ////////////////////
//////////////////////////////////////////////////////////

capture drop weiterbildung

gen byte weiterbildung = .
replace weiterbildung = 1 if inlist(F1300, 1, 2)
replace weiterbildung = 0 if F1300 == 3

label define weiterbildung_lbl ///
    0 "Keine Weiterbildung" ///
    1 "Weiterbildung", replace

label values weiterbildung weiterbildung_lbl
label variable weiterbildung "Teilnahme an beruflicher Weiterbildung"

tab F1300 weiterbildung, missing

//////////////////////////////////////////////////////////
//////////////////// 5. Behinderung //////////////////////
//////////////////////////////////////////////////////////

capture drop behinderung

gen byte behinderung = .
replace behinderung = 1 if F1514 == 1
replace behinderung = 0 if F1514 == 2

label define behinderung_lbl ///
    0 "Keine Behinderung" ///
    1 "Amtlich anerkannte Behinderung", replace

label values behinderung behinderung_lbl
label variable behinderung "Amtlich anerkannte Behinderung"

tab F1514 behinderung, missing

//////////////////////////////////////////////////////////
//////////////////// 6. Schwerbehinderung ////////////////
//////////////////////////////////////////////////////////

capture drop schwere_behinderung

gen byte schwere_behinderung = .
replace schwere_behinderung = 1 if F1514c == 2
replace schwere_behinderung = 0 if F1514c == 1
replace schwere_behinderung = 0 if F1514 == 2

label define schwere_behinderung_lbl ///
    0 "Keine Schwerbehinderung" ///
    1 "Schwerbehinderung", replace

label values schwere_behinderung schwere_behinderung_lbl
label variable schwere_behinderung "Schwerbehinderung (GdB >= 50)"

tab F1514c schwere_behinderung, missing
tab F1514 schwere_behinderung, missing

//////////////////////////////////////////////////////////
//////////////////// 7. KI-Nutzung ///////////////////////
//////////////////////////////////////////////////////////

capture drop ki_nutzung

gen byte ki_nutzung = .
replace ki_nutzung = 1 if F335 == 1
replace ki_nutzung = 0 if F335 == 2

label define ki_nutzung_lbl ///
    0 "Keine KI-Nutzung" ///
    1 "KI-Nutzung", replace

label values ki_nutzung ki_nutzung_lbl
label variable ki_nutzung "Nutzung von KI-Technologien"

tab F335 ki_nutzung, missing

//////////////////////////////////////////////////////////
//////////////////// 8. KI-Intensitaet ///////////////////
//////////////////////////////////////////////////////////

capture drop ki_intensitaet

gen byte ki_intensitaet = .
replace ki_intensitaet = 0 if ki_nutzung == 0
replace ki_intensitaet = 1 if F336 == 3
replace ki_intensitaet = 2 if F336 == 2
replace ki_intensitaet = 3 if F336 == 1

label define ki_intensitaet_lbl ///
    0 "Keine KI-Nutzung" ///
    1 "Selten" ///
    2 "Manchmal" ///
    3 "Haeufig", replace

label values ki_intensitaet ki_intensitaet_lbl
label variable ki_intensitaet "Intensitaet der KI-Nutzung"

tab F336 ki_intensitaet, missing
tab ki_nutzung ki_intensitaet, missing

//////////////////////////////////////////////////////////
//////////////////// 9. Neue KI-Nutzung //////////////////
//////////////////////////////////////////////////////////

capture drop neue_ki_nutzung

gen byte neue_ki_nutzung = .
replace neue_ki_nutzung = 1 if F337 == 1
replace neue_ki_nutzung = 0 if F337 == 2

label define neue_ki_nutzung_lbl ///
    0 "Bereits frueher genutzt" ///
    1 "Erstmals in den letzten zwei Jahren", replace

label values neue_ki_nutzung neue_ki_nutzung_lbl
label variable neue_ki_nutzung "Erstmalige KI-Nutzung"

tab F337 neue_ki_nutzung, missing
tab ki_nutzung neue_ki_nutzung, missing

//////////////////////////////////////////////////////////
//////////////////// 10. Uebersicht //////////////////////
//////////////////////////////////////////////////////////

tab weiterbildung, missing
tab behinderung, missing
tab schwere_behinderung, missing
tab ki_nutzung, missing
tab ki_intensitaet, missing
tab neue_ki_nutzung, missing

//////////////////////////////////////////////////////////
//////////////////// 11. Analysedaten speichern //////////
//////////////////////////////////////////////////////////

save "${projekt}/1-Daten/etb2024_analyse_ki_weiterbildung_behinderung.dta", replace

display "Variablenaufbereitung erfolgreich abgeschlossen."