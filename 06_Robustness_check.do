*******************************************************
* Robustheitsanalyse
* Alternative Operationalisierung des Behinderungsstatus
*
* Wiederholung der Hauptmodelle mit anerkannter
* Schwerbehinderung (Grad der Behinderung >= 50)
* als alternativer Operationalisierung des
* Behinderungsstatus.
*
* Geprüft werden:
* 1. Schwerbehinderung und Weiterbildung
* 2. Schwerbehinderung und KI-Nutzung
* 3. Interaktion zwischen Schwerbehinderung und KI-Nutzung
*******************************************************

version 18.0
set more off


*******************************************************
* 1. Variable und Analysestichprobe prüfen
*******************************************************

capture confirm variable schwere_behinderung

if _rc != 0 {
    display as error ///
        "Die Variable schwere_behinderung ist nicht vorhanden."
    exit 111
}

* Verteilung der Robustheitsvariable prüfen
tab schwere_behinderung, missing

* Prüfung der Kodierung
assert inlist(schwere_behinderung, 0, 1) ///
    if !missing(schwere_behinderung)


*******************************************************
* 2. Complete-Case-Stichprobe für Robustheitsanalyse
*******************************************************

gen byte complete_robust = !missing(weiterbildung, ///
                                    ki_nutzung, ///
                                    schwere_behinderung, ///
                                    S1, ///
                                    zpalter, ///
                                    schulabschluss, ///
                                    berufsabschluss, ///
                                    betriebsgroesse, ///
                                    wirtschaftsbereich, ///
                                    fuehrung, ///
                                    computer, ///
                                    spezprog)

label define complete_robust_lbl ///
    0 "Unvollständige Fälle" ///
    1 "Vollständige Fälle", replace

label values complete_robust complete_robust_lbl

tab complete_robust

* Analysen auf vollständige Fälle beschränken
preserve
keep if complete_robust == 1


*******************************************************
* 3. Modell 1: Schwerbehinderung und Weiterbildung
*******************************************************

logit weiterbildung ///
    i.schwere_behinderung ///
    i.S1 ///
    c.zpalter ///
    i.schulabschluss ///
    i.berufsabschluss ///
    i.betriebsgroesse ///
    i.wirtschaftsbereich ///
    i.fuehrung ///
    i.computer ///
    i.spezprog, ///
    vce(robust)

estimates store robust_m1

* Average Marginal Effect der Schwerbehinderung
margins, dydx(schwere_behinderung)

estimates store robust_m1_ame


*******************************************************
* 4. Modell 2: Schwerbehinderung und KI-Nutzung
*******************************************************

logit ki_nutzung ///
    i.schwere_behinderung ///
    i.S1 ///
    c.zpalter ///
    i.schulabschluss ///
    i.berufsabschluss ///
    i.betriebsgroesse ///
    i.wirtschaftsbereich ///
    i.fuehrung ///
    i.computer ///
    i.spezprog, ///
    vce(robust)

estimates store robust_m2

* Average Marginal Effect der Schwerbehinderung
margins, dydx(schwere_behinderung)

estimates store robust_m2_ame


*******************************************************
* 5. Modell 3: Interaktion Schwerbehinderung × KI
*******************************************************

logit weiterbildung ///
    i.schwere_behinderung##i.ki_nutzung ///
    i.S1 ///
    c.zpalter ///
    i.schulabschluss ///
    i.berufsabschluss ///
    i.betriebsgroesse ///
    i.wirtschaftsbereich ///
    i.fuehrung ///
    i.computer ///
    i.spezprog, ///
    vce(robust)

estimates store robust_m3


*******************************************************
* 6. Marginale Effekte des Interaktionsmodells
*******************************************************

* AMEs von Schwerbehinderung und KI-Nutzung
margins, dydx(schwere_behinderung ki_nutzung)

* Vorhergesagte Wahrscheinlichkeiten für alle vier Gruppen
margins schwere_behinderung#ki_nutzung

* Effekt der KI-Nutzung getrennt nach Schwerbehinderung
margins, dydx(ki_nutzung) ///
    at(schwere_behinderung = (0 1))

* Effekt der Schwerbehinderung getrennt nach KI-Nutzung
margins, dydx(schwere_behinderung) ///
    at(ki_nutzung = (0 1))


*******************************************************
* 7. Interaktionseffekt testen
*******************************************************

testparm i.schwere_behinderung#i.ki_nutzung


*******************************************************
* 8. Modellübersicht
*******************************************************

estimates table robust_m1 robust_m2 robust_m3, ///
    b(%9.3f) ///
    se(%9.3f) ///
    stats(N ll)


*******************************************************
* 9. Ursprünglichen Datensatz wiederherstellen
*******************************************************

restore

display as result ///
    "Robustheitsanalyse erfolgreich abgeschlossen."