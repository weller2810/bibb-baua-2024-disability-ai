*******************************************************
* Programname: 00_master.do
* Projekt: BIBB/BAuA-Erwerbstaetigenbefragung 2024
* Thema: Diversitaet, Digitalisierung und Disparitaeten
* Autorin: Sabrina Weller, BIBB
* Datum: 03.08.2026
*
* Dieses Master-Do-File fuehrt alle Analyseschritte
* in der vorgesehenen Reihenfolge aus.
*
* Reihenfolge:
* 1. Variablenaufbereitung
* 2. Deskriptive Analysen
* 3. Multivariate Modelle
* 4. Berechnung der Complete-Case-Stichprobe
* 5. Robustheitsanalysen
*******************************************************

clear all
version 18.0
capture log close
set more off
set linesize 120
set maxvar 10000

//////////////////////////////////////////////////////////
//////////////////// 1. Projektpfade //////////////////////
//////////////////////////////////////////////////////////

* Projektpfad bei Bedarf anpassen.
global projekt ///
"P:/2-Veröffentlichungen/2026/4-Sammelband Diversität_Digitalisierung_Disparitäten/2-Berechnungen"

global dopfad     "${projekt}/2-Do-Files"
global datenpfad  "${projekt}/1-Daten"
global outputpfad "${projekt}/3-Output"

* Outputordner anlegen, sofern er noch nicht existiert.
capture mkdir "${outputpfad}"

* Prüfen, ob der Projektpfad erreichbar ist.
capture cd "${projekt}"

if _rc {
    display as error ///
        "Projektpfad nicht erreichbar: ${projekt}"
    exit 603
}

//////////////////////////////////////////////////////////
//////////////////// 2. Master-Log ////////////////////////
//////////////////////////////////////////////////////////

capture log close

log using ///
"${outputpfad}/00_master.log", ///
replace text

display as text ///
"Start des Analyseworkflows: `c(current_date)' `c(current_time)'"

//////////////////////////////////////////////////////////
//////////////////// 3. Analyseschritte ///////////////////
//////////////////////////////////////////////////////////

display as text ///
"1/5 Variablenaufbereitung"

do "${dopfad}/01_variablenaufbereitung.do"


display as text ///
"2/5 Deskriptive Analysen"

do "${dopfad}/02_deskriptive_analysen.do"


display as text ///
"3/5 Multivariate Modelle"

do "${dopfad}/03_multivariate_modelle.do"


display as text ///
"4/5 Berechnung der Complete-Case-Stichprobe"

do "${dopfad}/04_Berechnung_Complete_Case.do"


display as text ///
"5/5 Robustheitsanalysen"

do "${dopfad}/06_Robustness_check.do"

//////////////////////////////////////////////////////////
//////////////////// 4. Abschluss /////////////////////////
//////////////////////////////////////////////////////////

display as text ///
"Ende des Analyseworkflows: `c(current_date)' `c(current_time)'"

log close

display as result ///
"Analyseworkflow erfolgreich abgeschlossen."