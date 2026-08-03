*******************************************************
* Programname: 03_multivariate_modelle.do
*
* Hypothesen:
*
* H1:
* Erwerbstaetige mit amtlich anerkannter Behinderung
* nehmen seltener an beruflicher Weiterbildung teil.
*
* H2:
* Erwerbstaetige mit amtlich anerkannter Behinderung
* nutzen KI-Technologien bei der Arbeit seltener.
*
* H3:
* Der Zusammenhang zwischen KI-Nutzung und Weiterbildung
* unterscheidet sich nach Behinderungsstatus.
*
* Bericht:
* Average Marginal Effects (AME), robuste Standardfehler,
* p-Werte, 95%-Konfidenzintervalle und Signifikanzsterne.
*******************************************************

version 18.0
set more off

capture log close
log using ///
"${outputpfad}/03_multivariate_modelle.log", ///
replace text

use "${datenpfad}/etb2024_analyse_final.dta", clear

capture which esttab
if _rc {
    ssc install estout, replace
}

//////////////////////////////////////////////////////////
//////////////////// 1. Referenzkategorien ///////////////
//////////////////////////////////////////////////////////

fvset base 0 behinderung
fvset base 0 ki_nutzung
fvset base 0 schulabschluss
fvset base 0 berufsabschluss
fvset base 0 betriebsgroesse
fvset base 6 wirtschaftsbereich

//////////////////////////////////////////////////////////
//////////////////// 2. Kontrollvariablen ////////////////
//////////////////////////////////////////////////////////

global kontrollen ///
i.S1 ///
c.zpalter ///
i.schulabschluss ///
i.berufsabschluss ///
i.betriebsgroesse ///
i.wirtschaftsbereich ///
i.F301 ///
i.F318 ///
i.F331 ///
i.F332 ///
i.F333 ///
i.F334

estimates clear

//////////////////////////////////////////////////////////
//////////////////// 3. H1 ///////////////////////////////
//////////////////////////////////////////////////////////

logit weiterbildung ///
i.behinderung ///
${kontrollen}, ///
vce(robust)

estimates store h1_logit

local N_h1   = e(N)
local ll_h1  = e(ll)
local r2p_h1 = e(r2_p)

margins, dydx(*) post

estadd scalar N_model   = `N_h1'
estadd scalar ll_model  = `ll_h1'
estadd scalar r2p_model = `r2p_h1'

estimates store h1_ame

//////////////////////////////////////////////////////////
//////////////////// 4. H2 ///////////////////////////////
//////////////////////////////////////////////////////////

logit ki_nutzung ///
i.behinderung ///
${kontrollen}, ///
vce(robust)

estimates store h2_logit

local N_h2   = e(N)
local ll_h2  = e(ll)
local r2p_h2 = e(r2_p)

margins, dydx(*) post

estadd scalar N_model   = `N_h2'
estadd scalar ll_model  = `ll_h2'
estadd scalar r2p_model = `r2p_h2'

estimates store h2_ame

//////////////////////////////////////////////////////////
//////////////////// 5. H3 ///////////////////////////////
//////////////////////////////////////////////////////////

logit weiterbildung ///
i.behinderung##i.ki_nutzung ///
${kontrollen}, ///
vce(robust)

estimates store h3_logit

local N_h3   = e(N)
local ll_h3  = e(ll)
local r2p_h3 = e(r2_p)

* Bedingter AME der KI-Nutzung nach Behinderungsstatus.
margins, ///
dydx(ki_nutzung) ///
at(behinderung = (0 1)) ///
post

estadd scalar N_model   = `N_h3'
estadd scalar ll_model  = `ll_h3'
estadd scalar r2p_model = `r2p_h3'

estimates store h3_ame

* Adjustierte Wahrscheinlichkeiten fuer die vier Gruppen.
estimates restore h3_logit

margins behinderung#ki_nutzung, post
estimates store h3_prob

* Formeller Vergleich der gruppenspezifischen AMEs.
estimates restore h3_logit

margins behinderung, ///
dydx(ki_nutzung) ///
pwcompare(effects) ///
post

estimates store h3_ame_vergleich

* Interaktionsgrafik.
estimates restore h3_logit
margins behinderung#ki_nutzung

marginsplot, ///
title("Weiterbildungswahrscheinlichkeit nach KI-Nutzung und Behinderung") ///
ytitle("Adjustierte Wahrscheinlichkeit") ///
xtitle("KI-Nutzung") ///
legend(order(1 "Keine Behinderung" 2 "Behinderung")) ///
name(h3_marginsplot, replace)

graph export ///
"${outputpfad}/Abbildung_1_H3_Margins.pdf", ///
replace

graph export ///
"${outputpfad}/Abbildung_1_H3_Margins.png", ///
width(2400) replace

//////////////////////////////////////////////////////////
//////////////////// 6. Publikationstabellen /////////////
//////////////////////////////////////////////////////////

* AME-Tabellen berichten Standardfehler, nicht
* Standardabweichungen.

esttab ///
h1_ame ///
h2_ame ///
using "${outputpfad}/Tabelle_2_AME_H1_H2.rtf", ///
replace ///
cells("b(star fmt(3)) se(par fmt(3)) p(fmt(3)) ci(fmt(3))") ///
star(* 0.05 ** 0.01 *** 0.001) ///
stats(N_model ll_model r2p_model, ///
fmt(0 2 3) ///
labels("Beobachtungen" "Log-Likelihood" "Pseudo-R2")) ///
mtitles("H1: Weiterbildung" "H2: KI-Nutzung") ///
title("Average Marginal Effects der multivariaten Logitmodelle") ///
label ///
compress ///
nogaps ///
nonotes ///
addnotes( ///
"AME; robuste Standardfehler in Klammern; p-Werte und 95%-Konfidenzintervalle." ///
"* p<0,05; ** p<0,01; *** p<0,001." ///
"Referenz Wirtschaftsbereich: anderer Bereich." ///
)

esttab ///
h1_ame ///
h2_ame ///
using "${outputpfad}/Tabelle_2_AME_H1_H2.csv", ///
replace ///
cells("b(star fmt(3)) se(fmt(3)) p(fmt(3)) ci(fmt(3))") ///
star(* 0.05 ** 0.01 *** 0.001) ///
stats(N_model ll_model r2p_model, ///
fmt(0 2 3) ///
labels("N" "Log Likelihood" "Pseudo R2")) ///
mtitles("H1 Weiterbildung" "H2 KI-Nutzung") ///
label plain

esttab ///
h3_ame ///
using "${outputpfad}/Tabelle_3_AME_H3.rtf", ///
replace ///
cells("b(star fmt(3)) se(par fmt(3)) p(fmt(3)) ci(fmt(3))") ///
star(* 0.05 ** 0.01 *** 0.001) ///
stats(N_model ll_model r2p_model, ///
fmt(0 2 3) ///
labels("Beobachtungen" "Log-Likelihood" "Pseudo-R2")) ///
mtitles("AME der KI-Nutzung") ///
title("Bedingte AMEs der KI-Nutzung nach Behinderungsstatus") ///
label ///
compress ///
nogaps ///
nonotes ///
addnotes( ///
"Robuste Standardfehler in Klammern." ///
"* p<0,05; ** p<0,01; *** p<0,001." ///
)

esttab ///
h3_prob ///
using "${outputpfad}/Tabelle_4_H3_Wahrscheinlichkeiten.rtf", ///
replace ///
cells("b(star fmt(3)) se(par fmt(3)) p(fmt(3)) ci(fmt(3))") ///
star(* 0.05 ** 0.01 *** 0.001) ///
title("Adjustierte Weiterbildungswahrscheinlichkeiten") ///
label compress nogaps nonotes

esttab ///
h3_ame_vergleich ///
using "${outputpfad}/Tabelle_5_H3_AME_Vergleich.rtf", ///
replace ///
cells("b(star fmt(3)) se(par fmt(3)) p(fmt(3)) ci(fmt(3))") ///
star(* 0.05 ** 0.01 *** 0.001) ///
title("Vergleich der AMEs zwischen den Behinderungsgruppen") ///
label compress nogaps nonotes

//////////////////////////////////////////////////////////
//////////////////// 7. Modelle speichern ////////////////
//////////////////////////////////////////////////////////

foreach m in ///
h1_logit h1_ame ///
h2_logit h2_ame ///
h3_logit h3_ame h3_prob h3_ame_vergleich {

    estimates restore `m'
    estimates save "${outputpfad}/`m'.ster", replace
}

log close
display as result "Multivariate Modelle und Tabellen erstellt."



*------------------------------------------------------------*
* Tabelle 1: Deskriptive Statistik
*------------------------------------------------------------*

*------------------------------------------------------------*
* Tabelle 1: Deskriptive Statistik nach Behinderungsstatus
*------------------------------------------------------------*

* Fehlwerte Alter
replace zpalter = . if zpalter == 9999

* Erwerbsalter
keep if zpalter < 67


drop if missing(weiterbildung, ///
                ki_nutzung, ///
                behinderung, ///
                S1, ///
                zpalter, ///
                schulabschluss, ///
                berufsabschluss, ///
                betriebsgroesse, ///
                wirtschaftsbereich, ///
                fuehrung, ///
                computer, ///
                spezprog)

dtable ///
    i.weiterbildung ///
    i.ki_nutzung ///
    i.S1 ///
    zpalter ///
    i.schulabschluss ///
    i.berufsabschluss ///
    i.betriebsgroesse ///
    i.wirtschaftsbereich ///
    i.fuehrung ///
    i.computer ///
    i.spezprog, ///
    by(behinderung, tests nototals) ///
    continuous(zpalter, statistics(mean sd)) ///
    factor(weiterbildung ki_nutzung S1 ///
           schulabschluss berufsabschluss betriebsgroesse ///
           wirtschaftsbereich fuehrung computer spezprog, ///
           statistics(fvfrequency fvpercent)) ///
    nformat(%9.2f mean sd) ///
    nformat(%9.0f fvfrequency) ///
    nformat(%9.1f fvpercent) ///
    title("Tabelle 1: Deskriptive Statistik nach Behinderungsstatus")
	

collect export ///
"P:\2-Veröffentlichungen\2026\4-Sammelband Diversität_Digitalisierung_Disparitäten\3-Abbildungen_Tabellen\Tabelle_1_Deskriptive_Statistik_nach_Behinderung.docx", ///
replace


*******************************************************
* Programname: 04_deskriptive_vertiefungsanalysen.do
*
* Ziel:
* 1. Beschreibung der KI-Nutzenden
* 2. Vergleich der KI-Nutzenden mit und ohne Behinderung
* 3. Weiterbildung nach Behinderungsstatus in Teilgruppen
* 4. KI-Nutzung nach Behinderungsstatus in Teilgruppen
* 5. Zusammenhang zwischen KI-Nutzung und Weiterbildung
*
* Auswertungen:
* Kreuztabellen mit Zeilenprozenten und Chi-Quadrat-Tests
* sowie Mittelwertvergleich des Alters.
*******************************************************

version 18.0
set more off

capture log close
log using ///
"${outputpfad}/04_deskriptive_vertiefungsanalysen.log", ///
replace text

use "${datenpfad}/etb2024_analyse_final.dta", clear


//////////////////////////////////////////////////////////
//////////////////// 1. Analysestichprobe ////////////////
//////////////////////////////////////////////////////////

* Ungültigen Alterswert als fehlend kennzeichnen.
replace zpalter = . if zpalter == 9999

* Beschränkung auf Erwerbstätige unter 67 Jahren.
keep if zpalter < 67

* Beschränkung auf vollständige Fälle der relevanten Variablen.
drop if missing(weiterbildung, ///
                ki_nutzung, ///
                behinderung, ///
                S1, ///
                zpalter, ///
                schulabschluss, ///
                berufsabschluss, ///
                betriebsgroesse, ///
                wirtschaftsbereich, ///
                fuehrung, ///
                computer, ///
                spezprog)


//////////////////////////////////////////////////////////
//////////////////// 2. Wer nutzt KI? ////////////////////
//////////////////////////////////////////////////////////

* Die folgenden Auswertungen beschreiben ausschließlich
* Erwerbstätige, die KI-Technologien bei der Arbeit nutzen.
*
* Die Zeilenprozente zeigen, wie sich KI-Nutzende mit und
* ohne Behinderung hinsichtlich der jeweiligen Merkmale
* zusammensetzen.
*
* Der Chi-Quadrat-Test prüft, ob zwischen Behinderungsstatus
* und dem jeweiligen kategorialen Merkmal ein Zusammenhang
* besteht.

foreach var in ///
    S1 ///
    schulabschluss ///
    berufsabschluss ///
    betriebsgroesse ///
    wirtschaftsbereich ///
    fuehrung {

    display as text ///
        "KI-Nutzende nach Behinderungsstatus und `var'"

    tab behinderung `var' if ki_nutzung == 1, ///
        row chi2
}


//////////////////////////////////////////////////////////
//////////////////// 3. Alter der KI-Nutzenden ///////////
//////////////////////////////////////////////////////////

* Mittelwert und Standardabweichung des Alters von
* KI-Nutzenden, getrennt nach Behinderungsstatus.

tabstat zpalter if ki_nutzung == 1, ///
    by(behinderung) ///
    statistics(n mean sd)

* Der t-Test prüft, ob sich das durchschnittliche Alter
* der KI-Nutzenden mit und ohne Behinderung unterscheidet.

ttest zpalter if ki_nutzung == 1, ///
    by(behinderung)


//////////////////////////////////////////////////////////
//////////////////// 4. Weiterbildung ////////////////////
//////////////////////////////////////////////////////////

* Weiterbildung nach Behinderungsstatus, getrennt nach
* Wirtschaftsbereich, Geschlecht und Betriebsgröße.
*
* Die Zeilenprozente geben innerhalb jeder Behinderungsgruppe
* den Anteil der Erwerbstätigen mit und ohne Weiterbildung an.
*
* Der Chi-Quadrat-Test wird für jede Teilgruppe separat
* berechnet.

foreach var in ///
    wirtschaftsbereich ///
    S1 ///
    betriebsgroesse {

    display as text ///
        "Weiterbildung nach Behinderung und `var'"

    bysort `var': ///
        tab behinderung weiterbildung, ///
        row chi2
}


//////////////////////////////////////////////////////////
//////////////////// 5. KI-Nutzung ///////////////////////
//////////////////////////////////////////////////////////

* KI-Nutzung nach Behinderungsstatus, getrennt nach
* Wirtschaftsbereich, Geschlecht und Betriebsgröße.
*
* Die Prozentwerte zeigen innerhalb der jeweiligen
* Behinderungsgruppe den Anteil der KI-Nutzenden.

foreach var in ///
    wirtschaftsbereich ///
    S1 ///
    betriebsgroesse {

    display as text ///
        "KI-Nutzung nach Behinderung und `var'"

    bysort `var': ///
        tab behinderung ki_nutzung, ///
        row chi2
}


//////////////////////////////////////////////////////////
//////////////////// 6. Weitere Teilgruppen //////////////
//////////////////////////////////////////////////////////

* Vertiefende Analyse der KI-Nutzung nach Schulabschluss,
* Berufsabschluss, Führungsverantwortung und Merkmalen
* der digitalen Arbeitsumgebung.

foreach var in ///
    schulabschluss ///
    berufsabschluss ///
    fuehrung ///
    computer ///
    spezprog {

    display as text ///
        "KI-Nutzung nach Behinderung und `var'"

    bysort `var': ///
        tab behinderung ki_nutzung, ///
        row chi2
}


//////////////////////////////////////////////////////////
//////////////////// 7. KI und Weiterbildung /////////////
//////////////////////////////////////////////////////////

* Vergleich der Weiterbildungsbeteiligung von KI-Nutzenden
* und Erwerbstätigen ohne KI-Nutzung.
*
* Die Zeilenprozente zeigen die Weiterbildungsquote innerhalb
* der beiden Gruppen.
*
* Der Chi-Quadrat-Test prüft den bivariaten Zusammenhang
* zwischen KI-Nutzung und Weiterbildung.

tab ki_nutzung weiterbildung, ///
    row chi2


//////////////////////////////////////////////////////////
//////////////////// 8. Getrennt nach Behinderung ////////
//////////////////////////////////////////////////////////

* Prüfung, ob die höhere Weiterbildungsbeteiligung von
* KI-Nutzenden sowohl bei Erwerbstätigen mit als auch ohne
* Behinderung zu beobachten ist.

bysort behinderung: ///
    tab ki_nutzung weiterbildung, ///
    row chi2


log close

display as result ///
    "Deskriptive Vertiefungsanalysen abgeschlossen."
	
*******************************************************
* Computernutzung und Behinderung
*******************************************************

* Häufige Computernutzung nach Behinderungsstatus
tab behinderung computer, row chi2

* Nutzung spezieller Computerprogramme nach Behinderungsstatus
tab behinderung spezprog, row chi2


*******************************************************
* Computernutzung nach Teilgruppen
*******************************************************

foreach var in ///
    wirtschaftsbereich ///
    S1 ///
    betriebsgroesse {

    di as text "Computernutzung nach Behinderung und `var'"

    bysort `var': ///
        tab behinderung computer, row chi2
}


*******************************************************
* Spezielle Computerprogramme nach Teilgruppen
*******************************************************

foreach var in ///
    wirtschaftsbereich ///
    S1 ///
    betriebsgroesse {

    di as text "Nutzung spezieller Computerprogramme nach Behinderung und `var'"

    bysort `var': ///
        tab behinderung spezprog, row chi2
}