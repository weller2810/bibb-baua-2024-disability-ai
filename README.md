README

Projekt

Titel

Diversität, Digitalisierung und Disparitäten – Berufliche Weiterbildung,
Behinderung und KI-Nutzung

Datengrundlage

BIBB/BAuA-Erwerbstätigenbefragung 2024 (Scientific Use File)

Autorin

Sabrina Weller (BIBB)

Erstellt

26.06.2026

------------------------------------------------------------------------

Forschungsfrage

Ziel des Projekts ist die Untersuchung des Zusammenhangs zwischen
beruflicher Weiterbildung, amtlich anerkannter Behinderung,
Schwerbehinderung sowie der Nutzung von KI-Technologien.

Im Mittelpunkt steht die Forschungsfrage:

  Haben Beschäftigte mit Behinderung geringere Chancen auf berufliche
  Weiterbildung und welche Rolle spielt dabei die Nutzung von
  KI-Technologien?

------------------------------------------------------------------------

Projektstruktur

Projekt │ ├── 1-Daten │ ├── BIBBBAuA_2024_SUF.dta │ └──
etb2024_analyse_ki_weiterbildung_behinderung.dta │ ├── 2-Do-Files │ ├──
01_variablenaufbereitung.do │ ├── 02_deskriptive_tabellen.do │ └──
03_regressionsmodelle.do │ └── 3-Output ├── Logs ├── Tabellen ├──
Abbildungen └── Regressionsmodelle

------------------------------------------------------------------------

Reihenfolge der Analysen

1.  01_variablenaufbereitung.do
    -   Erstellung des Analysedatensatzes und aller Analysevariablen.
2.  02_deskriptive_tabellen.do
    -   Erstellung der deskriptiven Tabellen, Kreuztabellen und
        Chi²-Tests.
3.  03_regressionsmodelle.do
    -   Schätzung der logistischen Regressionsmodelle und
        Zusatzanalysen.

------------------------------------------------------------------------

Beschreibung der Do-Files

01_variablenaufbereitung.do

Dieses Do-File: - liest den Scientific Use File ein, - bereitet alle
Analysevariablen auf, - recodiert Sonderwerte, - erstellt den
Analysedatensatz, - speichert den Datensatz für die weiteren Analysen.

Ausgabe: - etb2024_analyse_ki_weiterbildung_behinderung.dta

02_deskriptive_tabellen.do

Dieses Do-File erstellt: - Häufigkeitsverteilungen, - Kreuztabellen, -
Pearson-χ²-Tests, - Cramérs V, - Tabellen für die Ergebnisdarstellung.

03_regressionsmodelle.do

Dieses Do-File schätzt die logistischen Regressionsmodelle.

Hypothesen: - H1: Beschäftigte mit Behinderung nehmen seltener an
beruflicher Weiterbildung teil. - H2: Beschäftigte mit Behinderung
nutzen seltener KI-Technologien. - H3: KI-Nutzung erhöht die
Wahrscheinlichkeit beruflicher Weiterbildung. - H4: Der Zusammenhang
zwischen KI-Nutzung und Weiterbildung unterscheidet sich zwischen
Beschäftigten mit und ohne Behinderung. - H5: Beschäftigte, die KI erst
seit Kurzem nutzen, nehmen häufiger an beruflicher Weiterbildung teil.

Zusatzanalysen: - KI-Intensität statt KI-Nutzung (ja/nein) -
Schwerbehinderung statt amtlich anerkannter Behinderung

------------------------------------------------------------------------

Analysevariablen

Abhängige Variablen: - Teilnahme an beruflicher Weiterbildung - Nutzung
von KI-Technologien

Zentrale unabhängige Variablen: - Amtlich anerkannte Behinderung -
Schwerbehinderung - KI-Nutzung - KI-Nutzungsintensität - Erstmalige
KI-Nutzung

Kontrollvariablen: - Geschlecht - Alter - Schulabschluss -
Berufsabschluss - Anforderungsniveau - Betriebsgröße - Branche -
Führungsverantwortung - Computerarbeit - Digitale Arbeitsbedingungen

------------------------------------------------------------------------

Statistische Verfahren

-   Deskriptive Analysen
-   Kreuztabellen
-   Pearson-χ²-Test
-   Cramérs V
-   Binäre logistische Regression
-   Interaktionseffekte
-   Marginale Effekte (margins)
-   Vorhergesagte Wahrscheinlichkeiten (marginsplot)

Die Regressionsmodelle werden als Odds Ratios (OR) berichtet.

------------------------------------------------------------------------

Output

Die Analysen erzeugen: - Log-Dateien - Deskriptive Tabellen -
Regressionsmodelle - Marginal-Effects-Schätzungen - Abbildungen der
vorhergesagten Wahrscheinlichkeiten

Alle Ergebnisse werden im Ordner “3-Output” gespeichert.

------------------------------------------------------------------------

Software

-   Stata 18

------------------------------------------------------------------------

Reproduzierbarkeit

Die Analysen sind vollständig reproduzierbar.

Voraussetzungen: - Originaldatensatz der
BIBB/BAuA-Erwerbstätigenbefragung 2024 - Unveränderte
Projektordnerstruktur - Ausführung der Do-Files in der Reihenfolge: 01 →
02 → 03
