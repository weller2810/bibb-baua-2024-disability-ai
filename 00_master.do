* Programname: 00_master.do
* Projekt: BIBB/BAuA-Erwerbstaetigenbefragung 2024
* Thema: Diversitaet, Digitalisierung und Disparitaeten
* Autorin: Sabrina Weller, BIBB
* Datum: 26.06.2026

/*
Dieses Master-Do-File fuehrt alle Analyseschritte in der
richtigen Reihenfolge aus.

Reihenfolge:
1. Variablenaufbereitung
2. Deskriptive Tabellen
3. Regressionsmodelle
4. Abbildungen
*/

clear all
version 18.0
capture log close
set more off
set linesize 90
set maxvar 10000

//////////////////////////////////////////////////////////
//////////////////// 1. Pfade setzen /////////////////////
//////////////////////////////////////////////////////////

local basispfad ///
  "P:/2-Veröffentlichungen/2026/4-Sammelband Diversität_Digitalisierung_Disparitäten/2-Berechnungen"

local datenpfad "`basispfad'/1-Daten"
local dofilepfad "`basispfad'/2-Do-Files"
local outputpfad "`basispfad'/3-Output"

capture mkdir "`outputpfad'"

//////////////////////////////////////////////////////////
//////////////////// 2. Log-Datei starten ////////////////
//////////////////////////////////////////////////////////

capture log close
log using "`outputpfad'/00_master.log", replace text

//////////////////////////////////////////////////////////
//////////////////// 3. Do-Files ausfuehren /////////////
//////////////////////////////////////////////////////////

run "`dofilepfad'/01_variablenaufbereitung.do"
do "`dofilepfad'/02_deskriptive_tabellen.do"
do "`dofilepfad'/03_regressionsmodelle.do"
do "`dofilepfad'/04_abbildungen.do"

//////////////////////////////////////////////////////////
//////////////////// 4. Log-Datei schliessen ////////////
//////////////////////////////////////////////////////////

log close