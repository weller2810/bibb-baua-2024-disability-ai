* Programname: 02_deskriptive_tabellen.do
* Projekt: BIBB/BAuA-Erwerbstaetigenbefragung 2024
* Thema: Diversitaet, Digitalisierung und Disparitaeten
* Programmaufgabe:
/*
Dieses Do-File erstellt die deskriptiven Auswertungen
für die Analyse des Zusammenhangs zwischen beruflicher
Weiterbildung, Behinderung und der Nutzung von
KI-Technologien.

Grundlage ist der im Do-File
01_variablenaufbereitung.do erzeugte Analysedatensatz.

Ausgegeben werden

1. Fallzahl- und Missingwertübersichten,
2. univariate Verteilungen,
3. bivariate Kreuztabellen,
4. Chi²-Tests und Cramérs V sowie
5. vertiefende Tabellen zur Rolle der KI-Nutzung.
*/

* Autorin: Sabrina Weller, BIBB
* Erstellt: 15.06.2026
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

/*
Der Projektpfad verweist auf den zentralen Projektordner.
Alle weiteren Pfade werden relativ zu diesem Projektordner
definiert.
*/

local projekt ///
  "P:/2-Veröffentlichungen/2026/4-Sammelband Diversität_Digitalisierung_Disparitäten/2-Berechnungen"

local datenpfad  "`projekt'/1-Daten"
local outputpfad "`projekt'/3-Output"

//////////////////////////////////////////////////////////
//////////////////// 2. Log-Datei starten ////////////////
//////////////////////////////////////////////////////////

capture mkdir "`outputpfad'"

log using ///
  "`outputpfad'/02_deskriptive_tabellen.log", ///
  replace text

//////////////////////////////////////////////////////////
//////////////////// 3. Analysedaten einlesen ////////////
//////////////////////////////////////////////////////////

use ///
  "`datenpfad'/etb2024_analyse_ki_weiterbildung_behinderung.dta", ///
  clear

//////////////////////////////////////////////////////////
//////////////////// 4. Fallzahlprüfung //////////////////
//////////////////////////////////////////////////////////

/*
Prüfung der Anzahl gültiger und fehlender Werte der
zentralen Analysevariablen.
*/

misstable summarize ///
  weiterbildung ///
  behinderung ///
  schwere_behinderung ///
  ki_nutzung ///
  ki_intensitaet ///
  neue_ki_nutzung

//////////////////////////////////////////////////////////
//////////////////// 5. Univariate Verteilungen //////////
//////////////////////////////////////////////////////////

/*
Beschreibung der Verteilungen der zentralen Variablen.
Bei Variablen, die nur für KI-Nutzende erhoben wurden,
werden zusätzlich bedingte Häufigkeiten ausgegeben.
*/

tab weiterbildung, missing
tab behinderung, missing
tab schwere_behinderung, missing
tab ki_nutzung, missing

tab F336 if ki_nutzung == 1, missing
tab ki_intensitaet, missing
tab ki_intensitaet if ki_nutzung == 1, missing

tab neue_ki_nutzung, missing
tab neue_ki_nutzung if ki_nutzung == 1, missing

//////////////////////////////////////////////////////////
//////////////////// 6. Bivariate Analysen ///////////////
//////////////////////////////////////////////////////////

/*
Kreuztabellen mit Spaltenprozenten, Pearson-Chi²-Test
und Cramérs V zur Beschreibung der Zusammenhänge
zwischen Weiterbildung, Behinderung und KI-Nutzung.
*/

* Tabelle 1: Weiterbildung nach Behinderung.
tab weiterbildung behinderung, column chi2 V

* Tabelle 2: KI-Nutzung nach Behinderung.
tab ki_nutzung behinderung, column chi2 V

* Tabelle 3: Weiterbildung nach KI-Nutzung.
tab weiterbildung ki_nutzung, column chi2 V

/*
Tabelle 4 zeigt den Anteil mit Weiterbildung nach
Behinderung und KI-Nutzung. Da weiterbildung als 0/1-
Variable kodiert ist, entspricht der Mittelwert dem Anteil
der Personen mit Weiterbildung.
*/

table (behinderung) (ki_nutzung), ///
  statistic(mean weiterbildung) ///
  statistic(count weiterbildung) ///
  nformat(%9.3f mean)

* Tabelle 5: KI-Intensität nach Behinderung.
tab ki_intensitaet behinderung, column chi2 V

* Tabelle 6: Erstmalige KI-Nutzung nach Behinderung.
tab neue_ki_nutzung behinderung, column chi2 V

//////////////////////////////////////////////////////////
//////////////////// 7. Vertiefende Analysen /////////////
//////////////////////////////////////////////////////////

/*
Zusätzliche Auswertungen zur Weiterbildungsbeteiligung
getrennt nach KI-Nutzung sowie nach Intensität der
KI-Nutzung.
*/

* Tabelle 7a: Weiterbildung nach Behinderung ohne KI-Nutzung.
tab weiterbildung behinderung if ki_nutzung == 0, column chi2 V

* Tabelle 7b: Weiterbildung nach Behinderung mit KI-Nutzung.
tab weiterbildung behinderung if ki_nutzung == 1, column chi2 V

* Tabelle 8: Weiterbildung nach KI-Intensität.
tab weiterbildung ki_intensitaet, column chi2 V

//////////////////////////////////////////////////////////
//////////////////// 8. Programmende /////////////////////
//////////////////////////////////////////////////////////

log close

display as text ///
  "Deskriptive Auswertungen erfolgreich abgeschlossen."
