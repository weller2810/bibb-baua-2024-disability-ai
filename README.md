README
Projekt
Titel

Diversität, Digitalisierung und Disparitäten – Berufliche Weiterbildung, Behinderung und KI-Nutzung

Datengrundlage

BIBB/BAuA-Erwerbstätigenbefragung 2024 (Scientific Use File)

Autorin

Sabrina Weller (BIBB)

Erstellt

03.08.2026

Forschungsfrage

Ziel des Projekts ist die Untersuchung der Zusammenhänge zwischen beruflicher Weiterbildung, amtlich anerkannter Behinderung und der beruflichen Nutzung von KI-Technologien.

Im Mittelpunkt steht die Forschungsfrage:

Unterscheidet sich der Zusammenhang zwischen der beruflichen Nutzung von KI-Technologien und der Teilnahme an beruflicher Weiterbildung zwischen Erwerbstätigen mit und ohne amtlich anerkannte Behinderung?

Projektstruktur
Projekt
│
├── 1-Daten
│   ├── BIBBBAuA_2024_SUF.dta
│   └── etb2024_analyse_final.dta
│
├── 2-Do-Files
│   ├── 00_master.do
│   ├── 01_variablenaufbereitung.do
│   ├── 02_deskriptive_analysen.do
│   ├── 03_multivariate_modelle.do
│   ├── 04_Berechnung_Complete_Case.do
│   └── 06_Robustness_check.do
│
└── 3-Output
    ├── Logs
    ├── Tabellen
    ├── Abbildungen
    └── Modellschätzungen
Reihenfolge der Analysen
00_master.do
Führt sämtliche Analyseschritte in der vorgesehenen Reihenfolge aus.
01_variablenaufbereitung.do
Erstellung des Analysedatensatzes und aller Analysevariablen.
02_deskriptive_analysen.do
Erstellung der deskriptiven Tabellen, Kreuztabellen und Chi²-Tests.
03_multivariate_modelle.do
Schätzung der logistischen Regressionsmodelle, Average Marginal Effects (AME), Interaktionsanalysen und vorhergesagten Wahrscheinlichkeiten.
04_Berechnung_Complete_Case.do
Dokumentation der Analysestichprobe und der Ausschlüsse aufgrund fehlender Werte.
06_Robustness_check.do
Robustheitsanalysen unter Verwendung einer anerkannten Schwerbehinderung (Grad der Behinderung ≥ 50) als alternativer Operationalisierung des Behinderungsstatus.
Beschreibung der Do-Files
00_master.do

Steuert den gesamten Analyseworkflow und führt alle Do-Files automatisch in der vorgesehenen Reihenfolge aus.

01_variablenaufbereitung.do

Dieses Do-File:

liest den Scientific Use File ein,
bereitet alle Analysevariablen auf,
rekodiert Sonderwerte,
erstellt den Analysedatensatz,
speichert den Datensatz für die weiteren Analysen.

Ausgabe:

etb2024_analyse_final.dta
02_deskriptive_analysen.do

Dieses Do-File erstellt:

deskriptive Statistiken,
Kreuztabellen,
Pearson-χ²-Tests,
Tabellen und Abbildungen für die Ergebnisdarstellung.
03_multivariate_modelle.do

Dieses Do-File schätzt die logistischen Regressionsmodelle.

Hypothesen

H1: Erwerbstätige mit amtlich anerkannter Behinderung weisen eine geringere Wahrscheinlichkeit der Teilnahme an beruflicher Weiterbildung auf als Erwerbstätige ohne amtlich anerkannte Behinderung.

H2: Erwerbstätige mit amtlich anerkannter Behinderung weisen eine geringere Wahrscheinlichkeit der beruflichen Nutzung von KI-Technologien auf als Erwerbstätige ohne amtlich anerkannte Behinderung.

H3: Der Zusammenhang zwischen der beruflichen Nutzung von KI-Technologien und der Teilnahme an beruflicher Weiterbildung unterscheidet sich zwischen Erwerbstätigen mit und ohne amtlich anerkannte Behinderung.

Die Ergebnisse werden als Average Marginal Effects (AME) berichtet.

04_Berechnung_Complete_Case.do

Dieses Do-File dokumentiert den Ausschluss fehlender Werte und die Bildung der endgültigen Analysestichprobe.

06_Robustness_check.do

Dieses Do-File wiederholt sämtliche Regressionsmodelle unter Verwendung einer anerkannten Schwerbehinderung (Grad der Behinderung ≥ 50) als alternativer Operationalisierung des Behinderungsstatus.

Analysevariablen
Abhängige Variablen
Teilnahme an beruflicher Weiterbildung
Berufliche Nutzung von KI-Technologien
Zentrale unabhängige Variablen
Amtlich anerkannte Behinderung
Berufliche KI-Nutzung
Interaktion: Behinderung × KI-Nutzung
Kontrollvariablen
Geschlecht
Alter
Allgemeiner Schulabschluss
Beruflicher Abschluss
Betriebsgröße
Wirtschaftsbereich
Führungsverantwortung
Häufige Computernutzung
Nutzung spezieller Computerprogramme
Statistische Verfahren
Deskriptive Analysen
Kreuztabellen
Pearson-χ²-Test
Binäre logistische Regression
Interaktionseffekte
Average Marginal Effects (AME)
Vorhergesagte Wahrscheinlichkeiten (margins)
Marginsplots

Die Ergebnisse der Regressionsmodelle werden als Average Marginal Effects (AME) berichtet.

Output

Die Analysen erzeugen:

Log-Dateien
Deskriptive Tabellen
Regressionsmodelle
Average Marginal Effects (AME)
Vorhergesagte Wahrscheinlichkeiten
Marginsplots
Robustheitsanalysen

Alle Ergebnisse werden im Ordner 3-Output gespeichert.

Software
Stata 18
Reproduzierbarkeit

Die Analysen sind vollständig reproduzierbar.

Voraussetzungen

Originaldatensatz der BIBB/BAuA-Erwerbstätigenbefragung 2024
Unveränderte Projektordnerstruktur
Ausführung des Master-Do-Files (00_master.do) oder alternativ der einzelnen Do-Files in der vorgesehenen Reihenfolge.