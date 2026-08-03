CHANGELOG

Projekt:
Diversität, Digitalisierung und Disparitäten –
Berufliche Weiterbildung, Behinderung und KI-Nutzung

Autorin:
Sabrina Weller (BIBB)

====================================================================
Version 2.0 – 03.08.2026
====================================================================

Überarbeitung und Finalisierung des Analyseprojekts.

Wesentliche Änderungen

- Projektstruktur aktualisiert.
- Analyseworkflow über ein Master-Do-File automatisiert.
- Deskriptive Analysen erweitert.
- Logistische Regressionsmodelle vollständig überarbeitet.
- Ausgabe der Regressionsmodelle auf Average Marginal Effects (AME) umgestellt.
- Interaktionsanalysen ergänzt.
- Robustheitsanalysen mit alternativer Operationalisierung des Behinderungsstatus implementiert.
- Projektdokumentation (README und CHANGELOG) aktualisiert.

--------------------------------------------------------------------

00_master.do

- Master-Do-File zur Steuerung des gesamten Analyseworkflows erstellt.
- Automatische Ausführung sämtlicher Do-Files implementiert.
- Einheitliche Protokollierung des Analyseablaufs ergänzt.

--------------------------------------------------------------------

01_variablenaufbereitung.do

- Scientific Use File eingelesen.
- Sondercodes und fehlende Werte rekodiert.
- Analysevariablen erstellt:
  * Berufliche Weiterbildung
  * Amtlich anerkannte Behinderung
  * Anerkannte Schwerbehinderung
  * Berufliche KI-Nutzung
  * Schulabschluss
  * Berufsabschluss
  * Betriebsgröße
  * Wirtschaftsbereich
  * Führungsverantwortung
  * Häufige Computernutzung
  * Nutzung spezieller Computerprogramme
- Endgültigen Analysedatensatz erstellt.
- Analysedatensatz gespeichert.

Ausgabe:
- etb2024_analyse_final.dta

--------------------------------------------------------------------

02_deskriptive_analysen.do

- Beschreibung der Analysestichprobe erstellt.
- Deskriptive Statistiken ergänzt.
- Kreuztabellen erstellt.
- Pearson-χ²-Tests durchgeführt.
- Vertiefende deskriptive Analysen nach
  * Wirtschaftsbereich,
  * Geschlecht,
  * Betriebsgröße,
  * Computernutzung und
  * Nutzung spezieller Computerprogramme ergänzt.
- Tabellen für den Ergebnisteil erstellt.
- Deskriptive Analysen zur KI-Nutzung und beruflichen Weiterbildung ergänzt.

--------------------------------------------------------------------

03_multivariate_modelle.do

- Logistische Regressionsmodelle vollständig überarbeitet.
- Hypothesen H1 bis H3 implementiert.

H1:
Erwerbstätige mit amtlich anerkannter Behinderung weisen eine geringere
Wahrscheinlichkeit der Teilnahme an beruflicher Weiterbildung auf.

H2:
Erwerbstätige mit amtlich anerkannter Behinderung weisen eine geringere
Wahrscheinlichkeit der beruflichen Nutzung von KI-Technologien auf.

H3:
Der Zusammenhang zwischen der beruflichen Nutzung von KI-Technologien
und der Teilnahme an beruflicher Weiterbildung unterscheidet sich
zwischen Erwerbstätigen mit und ohne amtlich anerkannte Behinderung.

- Average Marginal Effects (AME) berechnet.
- Vorhergesagte Wahrscheinlichkeiten mit margins geschätzt.
- Interaktion Behinderung × KI-Nutzung geschätzt.
- Marginsplot automatisch erstellt.
- Publikationsfähige Tabellen als RTF und CSV exportiert.
- Modellschätzungen gespeichert.

--------------------------------------------------------------------

04_Berechnung_Complete_Case.do

- Dokumentation der vollständigen Analysestichprobe ergänzt.
- Ausschlüsse aufgrund fehlender Werte berechnet.
- Endgültige Analysestichprobe dokumentiert.

--------------------------------------------------------------------

06_Robustness_check.do

- Sämtliche Modelle mit anerkannter Schwerbehinderung
  (Grad der Behinderung ≥ 50) als alternativer
  Operationalisierung des Behinderungsstatus erneut geschätzt.
- Vergleich der Ergebnisse mit der Hauptanalyse dokumentiert.

--------------------------------------------------------------------

Dokumentation

- README vollständig aktualisiert.
- Projektstruktur dokumentiert.
- Analyseworkflow beschrieben.
- Reproduzierbarkeit sichergestellt.

====================================================================
Version 1.0 – 26.06.2026
====================================================================

Erstversion des Analyseprojekts.

Neu erstellt

- Projektstruktur eingerichtet.
- Analysedatensatz erstellt.
- Variablenaufbereitung implementiert.
- Erste deskriptive Analysen erstellt.
- Erste logistische Regressionsmodelle implementiert.
- Projektdokumentation (README) erstellt.

====================================================================
Bekannte Hinweise
====================================================================

- Die Regressionsmodelle basieren auf vollständigen Fällen
  (Listwise Deletion).
- Die Ergebnisse werden als Average Marginal Effects (AME) berichtet.
- Alle Analysen wurden mit Stata 18 durchgeführt.
- Sämtliche Ausgaben werden automatisch im Ordner "3-Output"
  gespeichert.

====================================================================
Geplante Erweiterungen
====================================================================

- Ergänzung weiterer Robustheits- und Sensitivitätsanalysen.
- Aktualisierung nach Rückmeldungen aus dem Begutachtungsprozess.
- Erweiterung der Projektdokumentation bei Bedarf.