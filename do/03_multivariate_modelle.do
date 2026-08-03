*******************************************************
* 03_multivariate_modelle_word_final_korrigiert.do
*
* Logitmodelle und Average Marginal Effects (AME)
* fuer Weiterbildung, KI-Nutzung und die Interaktion
* zwischen Behinderung und KI-Nutzung.
*
* Analytische Stichprobe:
* - Alterssondercode 9999 als fehlend
* - Personen unter 67 Jahren
* - vollstaendige Angaben zu allen Analysevariablen
*
* Ausgabe:
* ${outputpfad}/Multivariate_Ergebnisse_AME.docx
*******************************************************

version 18.0
clear all
set more off

capture log close
log using ///
    "${outputpfad}/03_multivariate_modelle_word_final_korrigiert.log", ///
    replace text

use "${datenpfad}/etb2024_analyse_final.dta", clear

*******************************************************
* 1. Analytische Stichprobe vorbereiten
*******************************************************

* Sondercode beim Alter als fehlend kodieren.
replace zpalter = . if zpalter == 9999

* Nur Personen mit gueltigem Alter unter 67 Jahren.
keep if !missing(zpalter) & zpalter < 67

* Einheitliche Complete-Case-Stichprobe fuer alle Modelle.
local analysevariablen ///
    weiterbildung ///
    ki_nutzung ///
    behinderung ///
    S1 ///
    zpalter ///
    schulabschluss ///
    berufsabschluss ///
    betriebsgroesse ///
    wirtschaftsbereich ///
    fuehrung ///
    computer ///
    spezprog

egen n_missing = rowmiss(`analysevariablen')
keep if n_missing == 0
drop n_missing

count
local N_analyse = r(N)
display as result "Analytische Stichprobe: N = " %12.0fc `N_analyse'

*******************************************************
* 2. Referenzkategorien und Kontrollvariablen
*******************************************************

fvset base 0 behinderung
fvset base 0 ki_nutzung
fvset base 1 S1
fvset base 0 schulabschluss
fvset base 0 berufsabschluss
fvset base 0 betriebsgroesse
fvset base 6 wirtschaftsbereich
fvset base 0 fuehrung
fvset base 0 computer
fvset base 0 spezprog

global kontrollen ///
    i.S1 ///
    c.zpalter ///
    i.schulabschluss ///
    i.berufsabschluss ///
    i.betriebsgroesse ///
    i.wirtschaftsbereich ///
    i.fuehrung ///
    i.computer ///
    i.spezprog

local worddatei ///
    "${outputpfad}/Multivariate_Ergebnisse_AME.docx"

local grafikdatei ///
    "${outputpfad}/Abbildung_1_H3_Margins.png"

capture erase "`worddatei'"
estimates clear

*******************************************************
* 3. Hilfsprogramm fuer AME-Tabellen
*******************************************************

capture program drop write_ame_table
program define write_ame_table
    version 18.0

    syntax, MATRIX(name) TABLENAME(name) TITLE(string asis) ///
        N(real) LOGLIK(real) R2(real)

    local M "`matrix'"
    local nr = rowsof(`M')
    local tabrows = `nr' + 1
    local rn : rownames `M'

    putdocx paragraph
    putdocx text (`"`title'"'), bold font("Arial", 11)

    putdocx table `tablename' = (`tabrows', 5), layout(autofitcontents)

    putdocx table `tablename'(1,1) = ("Merkmal")
    putdocx table `tablename'(1,2) = ("AME")
    putdocx table `tablename'(1,3) = ("Robuster SE")
    putdocx table `tablename'(1,4) = ("p-Wert")
    putdocx table `tablename'(1,5) = ("95%-KI")

    putdocx table `tablename'(1,.), bold
    putdocx table `tablename'(1,.), halign(center)
    putdocx table `tablename'(.,1), halign(left)
    putdocx table `tablename'(.,2/5), halign(center)

    forvalues i = 1/`nr' {
        local zeile = `i' + 1
        local term : word `i' of `rn'
        local label `"`term'"'

        * Lesbare Bezeichnungen ohne Auswertung von Faktorvariablen-Syntax.
        if `"`term'"' == "1.behinderung"       local label "Amtlich anerkannte Behinderung"
        if `"`term'"' == "1.ki_nutzung"        local label "Nutzung von KI-Technologien"
        if `"`term'"' == "2.S1"                local label "Geschlecht: weiblich"
        if `"`term'"' == "zpalter"             local label "Alter in Jahren"
        if `"`term'"' == "c.zpalter"           local label "Alter in Jahren"

        if `"`term'"' == "1.schulabschluss"    local label "Schulabschluss: erster Schulabschluss"
        if `"`term'"' == "2.schulabschluss"    local label "Schulabschluss: mittlerer Abschluss"
        if `"`term'"' == "3.schulabschluss"    local label "Schulabschluss: Fach-/Abitur"

        if `"`term'"' == "1.berufsabschluss"   local label "Berufsabschluss: berufliche/schulische Ausbildung"
        if `"`term'"' == "2.berufsabschluss"   local label "Berufsabschluss: Fach-/Hochschulabschluss"

        if `"`term'"' == "1.betriebsgroesse"   local label "Betriebsgroesse: 20 bis 249 Beschaeftigte"
        if `"`term'"' == "2.betriebsgroesse"   local label "Betriebsgroesse: 250 und mehr Beschaeftigte"

        if `"`term'"' == "1.wirtschaftsbereich" local label "Wirtschaftsbereich: Oeffentlicher Dienst"
        if `"`term'"' == "2.wirtschaftsbereich" local label "Wirtschaftsbereich: Industrie"
        if `"`term'"' == "3.wirtschaftsbereich" local label "Wirtschaftsbereich: Handwerk"
        if `"`term'"' == "4.wirtschaftsbereich" local label "Wirtschaftsbereich: Handel"
        if `"`term'"' == "5.wirtschaftsbereich" local label "Wirtschaftsbereich: sonstige Dienstleistungen"
        if `"`term'"' == "7.wirtschaftsbereich" local label "Wirtschaftsbereich: Privathaushalt"

        if `"`term'"' == "1.fuehrung"          local label "Fuehrungsverantwortung"
        if `"`term'"' == "1.computer"          local label "Haeufige Computernutzung"
        if `"`term'"' == "1.spezprog"          local label "Nutzung spezieller Computerprogramme"

        if `"`term'"' == "KI_ohne_Behinderung" local label "KI-Nutzung: keine Behinderung"
        if `"`term'"' == "KI_mit_Behinderung"  local label "KI-Nutzung: Behinderung"

        scalar ame_b  = `M'[`i',1]
        scalar ame_se = `M'[`i',2]
        scalar ame_p  = `M'[`i',4]
        scalar ame_ll = `M'[`i',5]
        scalar ame_ul = `M'[`i',6]

        local stern ""
        if scalar(ame_p) < .001 local stern "***"
        else if scalar(ame_p) < .01 local stern "**"
        else if scalar(ame_p) < .05 local stern "*"

        local btxt = strtrim(string(scalar(ame_b), "%9.3f")) + "`stern'"
        local setxt = strtrim(string(scalar(ame_se), "%9.3f"))

        if scalar(ame_p) < .001 {
            local ptxt "<0,001"
        }
        else {
            local ptxt = subinstr(strtrim(string(scalar(ame_p), "%9.3f")), ".", ",", .)
        }

        local lltxt = strtrim(string(scalar(ame_ll), "%9.3f"))
        local ultxt = strtrim(string(scalar(ame_ul), "%9.3f"))
        local citxt "[`lltxt'; `ultxt']"

        putdocx table `tablename'(`zeile',1) = (`"`label'"')
        putdocx table `tablename'(`zeile',2) = ("`btxt'")
        putdocx table `tablename'(`zeile',3) = ("`setxt'")
        putdocx table `tablename'(`zeile',4) = ("`ptxt'")
        putdocx table `tablename'(`zeile',5) = ("`citxt'")
    }

    local ntxt  = strtrim(string(`n', "%12.0fc"))
    local lltxt = strtrim(string(`loglik', "%12.2f"))
    local r2txt = strtrim(string(`r2', "%9.3f"))

    putdocx paragraph
    putdocx text ///
        ("Modellstatistik: N = `ntxt'; Log-Likelihood = `lltxt'; Pseudo-R2 = `r2txt'."), ///
        italic font("Arial", 9)
end

*******************************************************
* 4. Word-Dokument beginnen
*******************************************************

* Keine pagesize()-Option: Dadurch wird der Syntaxfehler r(198) vermieden.
putdocx begin, font("Arial", 9)

putdocx paragraph, halign(center)
putdocx text ///
    ("Multivariate Analysen: Behinderung, KI-Nutzung und Weiterbildung"), ///
    bold font("Arial", 15)

putdocx paragraph, halign(center)
putdocx text ///
    ("BIBB/BAuA-Erwerbstaetigenbefragung 2024"), ///
    italic font("Arial", 10)

putdocx paragraph
putdocx text ///
    ("Berichtet werden Average Marginal Effects (AME) aus Logitmodellen mit robusten Standardfehlern. Die Analysen beziehen sich auf Erwerbstaetige unter 67 Jahren mit vollstaendigen Angaben zu allen Analysevariablen."), ///
    font("Arial", 9)

*******************************************************
* 5. H1: Behinderung und Weiterbildung
*******************************************************

logit weiterbildung ///
    i.behinderung ///
    ${kontrollen}, ///
    vce(robust)

estimates store h1_logit

local N_h1   = e(N)
local ll_h1  = e(ll)
local r2p_h1 = e(r2_p)

margins, dydx(*) post
matrix H1 = r(table)'

write_ame_table, ///
    matrix(H1) ///
    tablename(tab_h1) ///
    title("Tabelle 1. Average Marginal Effects auf die Weiterbildungsbeteiligung") ///
    n(`N_h1') ///
    loglik(`ll_h1') ///
    r2(`r2p_h1')

*******************************************************
* 6. H2: Behinderung und KI-Nutzung
*******************************************************

putdocx pagebreak

logit ki_nutzung ///
    i.behinderung ///
    ${kontrollen}, ///
    vce(robust)

estimates store h2_logit

local N_h2   = e(N)
local ll_h2  = e(ll)
local r2p_h2 = e(r2_p)

margins, dydx(*) post
matrix H2 = r(table)'

write_ame_table, ///
    matrix(H2) ///
    tablename(tab_h2) ///
    title("Tabelle 2. Average Marginal Effects auf die Nutzung von KI-Technologien") ///
    n(`N_h2') ///
    loglik(`ll_h2') ///
    r2(`r2p_h2')

*******************************************************
* 7. H3: Interaktion Behinderung x KI-Nutzung
*******************************************************

putdocx pagebreak

logit weiterbildung ///
    i.behinderung##i.ki_nutzung ///
    ${kontrollen}, ///
    vce(robust)

estimates store h3_logit

local N_h3   = e(N)
local ll_h3  = e(ll)
local r2p_h3 = e(r2_p)

* Wald-Test des Interaktionsterms auf der Logit-Skala.
testparm i.behinderung#i.ki_nutzung
local p_interaktion = r(p)

* Bedingte AMEs der KI-Nutzung nach Behinderungsstatus.
margins, dydx(ki_nutzung) at(behinderung=(0 1)) post
matrix H3 = r(table)'
matrix rownames H3 = KI_ohne_Behinderung KI_mit_Behinderung

write_ame_table, ///
    matrix(H3) ///
    tablename(tab_h3) ///
    title("Tabelle 3. Bedingte AMEs der KI-Nutzung nach Behinderungsstatus") ///
    n(`N_h3') ///
    loglik(`ll_h3') ///
    r2(`r2p_h3')

if `p_interaktion' < .001 {
    local pintxt "<0,001"
}
else {
    local pintxt = subinstr(strtrim(string(`p_interaktion', "%9.3f")), ".", ",", .)
}

putdocx paragraph
putdocx text ///
    ("Wald-Test des Interaktionsterms: p = `pintxt'."), ///
    italic font("Arial", 9)

*******************************************************
* 8. Adjustierte Wahrscheinlichkeiten aus Modell 3
*******************************************************

estimates restore h3_logit
margins behinderung#ki_nutzung, post
matrix H3P = r(table)'

putdocx paragraph
putdocx text ///
    ("Tabelle 4. Vorhergesagte Wahrscheinlichkeiten der Weiterbildung"), ///
    bold font("Arial", 11)

putdocx table tab_h3p = (5, 5), layout(autofitcontents)

putdocx table tab_h3p(1,1) = ("Behinderungsstatus")
putdocx table tab_h3p(1,2) = ("KI-Nutzung")
putdocx table tab_h3p(1,3) = ("Wahrscheinlichkeit")
putdocx table tab_h3p(1,4) = ("Robuster SE")
putdocx table tab_h3p(1,5) = ("95%-KI")

putdocx table tab_h3p(1,.), bold
putdocx table tab_h3p(1,.), halign(center)
putdocx table tab_h3p(.,1/2), halign(left)
putdocx table tab_h3p(.,3/5), halign(center)

local behind1 "Keine Behinderung"
local behind2 "Keine Behinderung"
local behind3 "Behinderung"
local behind4 "Behinderung"

local ki1 "Keine KI-Nutzung"
local ki2 "KI-Nutzung"
local ki3 "Keine KI-Nutzung"
local ki4 "KI-Nutzung"

forvalues i = 1/4 {
    local zeile = `i' + 1

    scalar pr_b  = H3P[`i',1]
    scalar pr_se = H3P[`i',2]
    scalar pr_ll = H3P[`i',5]
    scalar pr_ul = H3P[`i',6]

    local btxt  = strtrim(string(scalar(pr_b), "%9.3f"))
    local setxt = strtrim(string(scalar(pr_se), "%9.3f"))
    local lltxt = strtrim(string(scalar(pr_ll), "%9.3f"))
    local ultxt = strtrim(string(scalar(pr_ul), "%9.3f"))
    local citxt "[`lltxt'; `ultxt']"

    putdocx table tab_h3p(`zeile',1) = ("`behind`i''")
    putdocx table tab_h3p(`zeile',2) = ("`ki`i''")
    putdocx table tab_h3p(`zeile',3) = ("`btxt'")
    putdocx table tab_h3p(`zeile',4) = ("`setxt'")
    putdocx table tab_h3p(`zeile',5) = ("`citxt'")
}

*******************************************************
* 9. Interaktionsgrafik
*******************************************************

estimates restore h3_logit
margins ki_nutzung#behinderung

marginsplot, ///
    xdimension(ki_nutzung) ///
    plotdimension(behinderung) ///
    recast(line) ///
    recastci(rcap) ///
    xlabel(0 "Keine KI-Nutzung" 1 "KI-Nutzung") ///
    ytitle("Vorhergesagte Wahrscheinlichkeit der Weiterbildung") ///
    xtitle("") ///
    title("") ///
    legend(order(1 "Keine Behinderung" 2 "Behinderung") cols(1)) ///
    name(h3_marginsplot, replace)

graph export "`grafikdatei'", width(3000) replace

putdocx paragraph
putdocx text ///
    ("Abbildung 1. Vorhergesagte Wahrscheinlichkeit der Teilnahme an beruflicher Weiterbildung nach KI-Nutzung und Behinderungsstatus"), ///
    bold font("Arial", 10)

putdocx paragraph, halign(center)
putdocx image "`grafikdatei'", width(6)

local Nh3txt = strtrim(string(`N_h3', "%12.0fc"))

putdocx paragraph
putdocx text ///
    ("Anmerkung. Dargestellt sind vorhergesagte Wahrscheinlichkeiten aus dem logistischen Regressionsmodell. Die Fehlerbalken zeigen 95%-Konfidenzintervalle. N = `Nh3txt'."), ///
    font("Arial", 8)

*******************************************************
* 10. Allgemeine Anmerkungen
*******************************************************

putdocx paragraph
putdocx text ("Anmerkungen."), bold font("Arial", 8)

putdocx paragraph
putdocx text ///
    ("AME = Average Marginal Effect; SE = Standardfehler; KI = Konfidenzintervall. Robuste Standardfehler. * p < 0,05; ** p < 0,01; *** p < 0,001."), ///
    font("Arial", 8)

putdocx paragraph
putdocx text ///
    ("Referenzkategorien: keine amtlich anerkannte Behinderung; keine KI-Nutzung; maennlich; kein Schulabschluss; kein Berufsabschluss; unter 20 Beschaeftigte; Wirtschaftsbereich der Referenzkategorie 6; keine Fuehrungsverantwortung; Computernutzung manchmal oder nie; keine Nutzung spezieller Computerprogramme."), ///
    font("Arial", 8)

putdocx paragraph
putdocx text ///
    ("Quelle: Eigene Berechnungen auf Basis der BIBB/BAuA-Erwerbstaetigenbefragung 2024."), ///
    font("Arial", 8)

*******************************************************
* 11. Dokument und Modelle speichern
*******************************************************

putdocx save "`worddatei'", replace

foreach m in h1_logit h2_logit h3_logit {
    estimates restore `m'
    estimates save "${outputpfad}/`m'.ster", replace
}

log close

display as result "Word-Datei erstellt:"
display as result "`worddatei'"
