*******************************************************
* Complete-Case-Analyse
* - Erstellung eines Complete-Case-Indikators
* - Vergleich vollständiger und unvollständiger Fälle
* - Logistische Regression zur Prüfung systematischer
*   Ausfälle
* - Beschränkung der Analysen auf vollständige Datensätze
* Projekt: BIBB/BAuA-Erwerbstaetigenbefragung 2024
* Thema: Diversitaet, Digitalisierung und Disparitaeten
* Autorin: Sabrina Weller, BIBB
* Datum: 31.07.2026
*******************************************************

keep if inrange(zpalter, 15, 67)

gen byte complete_case = !missing(weiterbildung, ///
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

label define complete_lbl 0 "Unvollständige Fälle" ///
                          1 "Vollständige Fälle"
label values complete_case complete_lbl

tab complete_case

foreach var in weiterbildung ki_nutzung behinderung S1 zpalter ///
               schulabschluss berufsabschluss betriebsgroesse ///
               wirtschaftsbereich fuehrung computer spezprog {

    quietly count if missing(`var')
    display "`var': " r(N) " fehlende Werte"
}

dtable ///
    i.behinderung ///
    i.S1 ///
    zpalter ///
    i.schulabschluss ///
    i.berufsabschluss ///
    i.betriebsgroesse ///
    i.wirtschaftsbereich ///
    i.fuehrung ///
    i.computer ///
    i.spezprog, ///
    by(complete_case, tests nototals) ///
    continuous(zpalter, statistics(mean sd)) ///
    factor(behinderung S1 schulabschluss berufsabschluss ///
           betriebsgroesse wirtschaftsbereich fuehrung ///
           computer spezprog, ///
           statistics(fvfrequency fvpercent)) ///
    nformat(%9.2f mean sd) ///
    nformat(%9.0f fvfrequency) ///
    nformat(%9.1f fvpercent) ///
    title("Vergleich vollständiger und unvollständiger Fälle")
	
logit complete_case ///
    i.behinderung ///
    i.S1 ///
    c.zpalter ///
    i.schulabschluss ///
    i.berufsabschluss ///
    i.betriebsgroesse ///
    i.wirtschaftsbereich ///
    i.fuehrung ///
    i.computer ///
    i.spezprog, vce(robust)

margins, dydx(*)


keep if complete_case == 1


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