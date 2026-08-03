*******************************************************
* Programname: 01_variablenaufbereitung.do
* Projekt: BIBB/BAuA-Erwerbstaetigenbefragung 2024
* Thema: Diversitaet, Digitalisierung und Disparitaeten
*
* Finaler Stand:
* - Weiterbildung
* - amtlich anerkannte Behinderung
* - Schwerbehinderung
* - KI-Nutzung
* - allgemeinbildender Schulabschluss aus S3
* - Berufsabschluss aus B1202
* - Betriebsgroesse aus F515
* - Wirtschaftsbereich aus F512
*
* Nicht mehr enthalten:
* - KI-Intensitaet
* - erstmalige/neue KI-Nutzung
*******************************************************

version 18.0
set more off

capture log close
log using ///
"${outputpfad}/01_variablenaufbereitung.log", ///
replace text

//////////////////////////////////////////////////////////
//////////////////// 1. Ausgangsdaten ////////////////////
//////////////////////////////////////////////////////////

use "${datenpfad}/BIBBBAuA_2024_suf1.0.dta", clear

local erforderlich ///
F1300 F1514 F1514c F335 S3 B1202 F515 F512 ///
S1 zpalter F301 F318 F331 F332 F333 F334

foreach v of local erforderlich {
    capture confirm variable `v'
    if _rc {
        display as error "Erforderliche Variable fehlt: `v'"
        exit 111
    }
}

//////////////////////////////////////////////////////////
//////////////////// 2. Fehlende Werte ///////////////////
//////////////////////////////////////////////////////////

* Keine Angabe bzw. unklare KI-Nutzung als fehlend.
replace F1300  = . if F1300  == 9
replace F1514  = . if F1514  == 9
replace F1514c = . if F1514c == 9
replace F335   = . if inlist(F335, 3, 9)

replace S3     = . if S3     == 9
replace B1202  = . if B1202  == 99
replace F515   = . if F515   == 99
replace F512   = . if F512   == 9

//////////////////////////////////////////////////////////
//////////////////// 3. Weiterbildung ////////////////////
//////////////////////////////////////////////////////////

capture drop weiterbildung
generate byte weiterbildung = .
replace weiterbildung = 1 if inlist(F1300, 1, 2)
replace weiterbildung = 0 if F1300 == 3

label define ja_nein_lbl 0 "Nein" 1 "Ja", replace
label values weiterbildung ja_nein_lbl
label variable weiterbildung ///
"Berufliche Weiterbildung in den letzten zwei Jahren"

//////////////////////////////////////////////////////////
//////////////////// 4. Behinderung //////////////////////
//////////////////////////////////////////////////////////

capture drop behinderung
generate byte behinderung = .
replace behinderung = 1 if F1514 == 1
replace behinderung = 0 if F1514 == 2

label define behinderung_lbl ///
0 "Keine amtlich anerkannte Behinderung" ///
1 "Amtlich anerkannte Behinderung", replace

label values behinderung behinderung_lbl
label variable behinderung "Amtlich anerkannte Behinderung"

capture drop schwere_behinderung
generate byte schwere_behinderung = .
replace schwere_behinderung = 0 if F1514 == 2
replace schwere_behinderung = 0 if F1514 == 1 & F1514c == 1
replace schwere_behinderung = 1 if F1514 == 1 & F1514c == 2

label define schwere_behinderung_lbl ///
0 "Keine Schwerbehinderung" ///
1 "Schwerbehinderung (GdB 50+)", replace

label values schwere_behinderung schwere_behinderung_lbl
label variable schwere_behinderung "Schwerbehinderung (GdB 50+)"

//////////////////////////////////////////////////////////
//////////////////// 5. KI-Nutzung ///////////////////////
//////////////////////////////////////////////////////////

capture drop ki_nutzung
generate byte ki_nutzung = .
replace ki_nutzung = 1 if F335 == 1
replace ki_nutzung = 0 if F335 == 2

label define ki_nutzung_lbl ///
0 "Keine KI-Nutzung" ///
1 "KI-Nutzung", replace

label values ki_nutzung ki_nutzung_lbl
label variable ki_nutzung "Nutzung von KI-Technologien bei der Arbeit"

//////////////////////////////////////////////////////////
//////////////////// 6. Schulabschluss ///////////////////
//////////////////////////////////////////////////////////

* S3:
* 1 Hauptschulabschluss oder gleichwertig
* 2 Realschulabschluss/mittlere Reife
* 3 Abitur/Fachhochschulreife
* 4 kein Schulabschluss
* 5 anderer Schulabschluss
*
* Code 5 wird nicht inhaltlich einer der vier Gruppen
* zugeschlagen, sondern als fehlend behandelt.

capture drop schulabschluss
generate byte schulabschluss = .
replace schulabschluss = 0 if S3 == 4
replace schulabschluss = 1 if S3 == 1
replace schulabschluss = 2 if S3 == 2
replace schulabschluss = 3 if S3 == 3

label define schulabschluss_lbl ///
0 "Kein Schulabschluss" ///
1 "Erster Schulabschluss" ///
2 "Mittlerer Abschluss" ///
3 "Fach-/Abitur", replace

label values schulabschluss schulabschluss_lbl
label variable schulabschluss ///
"Hoechster allgemeinbildender Schulabschluss"

//////////////////////////////////////////////////////////
//////////////////// 7. Berufsabschluss //////////////////
//////////////////////////////////////////////////////////

* B1202:
* 1 betriebliche Berufsausbildung/Lehre
* 2 schulische Berufsausbildung
* 3 Fortbildungsabschluss
* 4 Fachhochschulabschluss
* 5 Universitaetsabschluss
* 6 anderer Ausbildungsabschluss
* 10 Berufsakademie/Verwaltungs-/Wirtschaftsakademie
*
* Systemmissings bei B1202 werden als "kein Abschluss"
* behandelt. Diese Annahme sollte mit dem Fragebogenfilter
* bzw. Methodenbericht abschliessend geprueft werden.

capture drop berufsabschluss
generate byte berufsabschluss = .

replace berufsabschluss = 0 if missing(B1202)
replace berufsabschluss = 1 if inlist(B1202, 1, 2, 3, 6)
replace berufsabschluss = 2 if inlist(B1202, 4, 5, 10)

label define berufsabschluss_lbl ///
0 "Kein Berufsabschluss" ///
1 "Berufliche/schulische Ausbildung" ///
2 "Fach-/Hochschulabschluss", replace

label values berufsabschluss berufsabschluss_lbl
label variable berufsabschluss "Hoechster beruflicher Abschluss"

//////////////////////////////////////////////////////////
//////////////////// 8. Betriebsgroesse //////////////////
//////////////////////////////////////////////////////////

* Aufgrund der vorgegebenen Klassen von F515 kann die
* Grenze nur als 250 und mehr abgebildet werden:
* 1-5  = unter 20
* 6-8  = 20 bis 249
* 9-11 = 250 und mehr

capture drop betriebsgroesse
generate byte betriebsgroesse = .
replace betriebsgroesse = 0 if inrange(F515, 1, 5)
replace betriebsgroesse = 1 if inrange(F515, 6, 8)
replace betriebsgroesse = 2 if inrange(F515, 9, 11)

label define betriebsgroesse_lbl ///
0 "Unter 20 Beschaeftigte" ///
1 "20 bis 249 Beschaeftigte" ///
2 "250 und mehr Beschaeftigte", replace

label values betriebsgroesse betriebsgroesse_lbl
label variable betriebsgroesse "Betriebsgroesse"

//////////////////////////////////////////////////////////
//////////////////// 9. Wirtschaftsbereich ///////////////
//////////////////////////////////////////////////////////

capture drop wirtschaftsbereich
generate byte wirtschaftsbereich = F512

label define wirtschaftsbereich_lbl ///
1 "Oeffentlicher Dienst" ///
2 "Industrie" ///
3 "Handwerk" ///
4 "Handel" ///
5 "Sonstige Dienstleistungen" ///
6 "Anderer Bereich" ///
7 "Privathaushalt", replace

label values wirtschaftsbereich wirtschaftsbereich_lbl
label variable wirtschaftsbereich "Wirtschaftsbereich"

* Referenzkategorie: anderer Bereich.
fvset base 6 wirtschaftsbereich



*--------------------------------------------------
* Führungsverantwortung
* 1 = Ja
* 0 = Nein
*--------------------------------------------------

gen fuehrung = .
replace fuehrung = 1 if F301 == 1
replace fuehrung = 0 if F301 == 2

label define fuehrung 0 "Keine Führungsverantwortung" ///
                      1 "Führungsverantwortung"

label values fuehrung fuehrung
label variable fuehrung "Führungsverantwortung"


*--------------------------------------------------
* Computernutzung
* 1 = häufig
* 0 = manchmal oder nie
*--------------------------------------------------

gen computer = .

replace computer = 1 if F318 == 1
replace computer = 0 if inlist(F318,2,3)

label define computer ///
0 "manchmal oder nie" ///
1 "häufig"

label values computer computer
label variable computer "Arbeitet häufig mit Computern"

*--------------------------------------------------
* Spezielle Computerprogramme
*--------------------------------------------------

gen spezprog = .

replace spezprog = 1 if F332 == 1
replace spezprog = 0 if F332 == 2

label define spezprog ///
0 "Nein" ///
1 "Ja"

label values spezprog spezprog
label variable spezprog "Nutzung spezieller Computerprogramme"



//////////////////////////////////////////////////////////
//////////////////// 10. Plausibilitaet //////////////////
//////////////////////////////////////////////////////////

tabulate F1300 weiterbildung, missing
tabulate F1514 behinderung, missing
tabulate F1514c schwere_behinderung, missing
tabulate F335 ki_nutzung, missing

tabulate S3 schulabschluss, missing
tabulate B1202 berufsabschluss, missing
tabulate F515 betriebsgroesse, missing
tabulate F512 wirtschaftsbereich, missing

assert inlist(weiterbildung, 0, 1, .)
assert inlist(behinderung, 0, 1, .)
assert inlist(schwere_behinderung, 0, 1, .)
assert inlist(ki_nutzung, 0, 1, .)
assert inlist(schulabschluss, 0, 1, 2, 3, .)
assert inlist(berufsabschluss, 0, 1, 2, .)
assert inlist(betriebsgroesse, 0, 1, 2, .)
assert inlist(wirtschaftsbereich, 1, 2, 3, 4, 5, 6, 7, .)


tab zpalter, missing
summarize zpalter, detail

replace zpalter = . if zpalter == 9999
tab zpalter if zpalter > 100, missing
summarize zpalter, detail

//////////////////////////////////////////////////////////
//////////////////// 11. Speichern ///////////////////////
//////////////////////////////////////////////////////////

compress
save "${datenpfad}/etb2024_analyse_final.dta", replace

log close
display as result "Finaler Analysedatensatz gespeichert."
