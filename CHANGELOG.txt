CHANGELOG

Projekt: Diversität, Digitalisierung und Disparitäten – Berufliche
Weiterbildung, Behinderung und KI-Nutzung

Autorin: Sabrina Weller (BIBB)

====================================================================
Version 1.0 – 26.06.2026
====================================================================

Erstversion des Analyseprojekts.

Neu erstellt: - Projektstruktur eingerichtet. - Analysedatensatz
erstellt. - Variablenaufbereitung dokumentiert. - Deskriptive Analysen
erstellt. - Regressionsmodelle implementiert. - Abbildungen auf Basis
der Marginaleffekte erstellt. - README-Datei erstellt.

------------------------------------------------------------------------

00_master.do - Master-Do-File zur Steuerung des gesamten Analyseablaufs
erstellt. - Automatische Ausführung aller Do-Files implementiert.

------------------------------------------------------------------------

01_variablenaufbereitung.do - Einlesen des Scientific Use Files. -
Recodierung fehlender Werte und Sondercodes. - Erstellung der
Analysevariablen: * Weiterbildung * Behinderung * Schwerbehinderung *
KI-Nutzung * KI-Nutzungsintensität * Erstmalige KI-Nutzung - Speicherung
des Analysedatensatzes.

------------------------------------------------------------------------

02_deskriptive_tabellen.do - Fallzahlübersichten ergänzt. -
Häufigkeitsverteilungen erstellt. - Kreuztabellen erstellt. -
Pearson-χ²-Tests ergänzt. - Cramérs V ergänzt. - Tabellen zur
Beschreibung der Stichprobe erstellt.

------------------------------------------------------------------------

03_regressionsmodelle.do - Logistische Regressionsmodelle
implementiert. - Hypothesen H1 bis H5 geschätzt. - Interaktion
Behinderung × KI-Nutzung ergänzt. - Robustheitsanalysen mit
KI-Nutzungsintensität ergänzt. - Robustheitsanalysen mit
Schwerbehinderung ergänzt. - Marginaleffekte berechnet. -
Regressionsmodelle gespeichert.

------------------------------------------------------------------------

04_abbildungen.do - Marginsplots erstellt. - Grafische Darstellung der
Interaktionseffekte ergänzt. - Abbildungen der vorhergesagten
Wahrscheinlichkeiten erstellt.

------------------------------------------------------------------------

Dokumentation - README erstellt. - Projektstruktur dokumentiert. -
Analyseablauf dokumentiert. - Reproduzierbarkeit sichergestellt.

====================================================================
Bekannte Hinweise
====================================================================

-   Die Regressionsmodelle verwenden Listwise Deletion bei fehlenden
    Werten.
-   Modell H5 wird ausschließlich für Beschäftigte mit KI-Nutzung
    geschätzt.
-   Alle Analysen wurden mit Stata 18 durchgeführt.

====================================================================
Nächste geplante Erweiterungen
====================================================================

-   Export der Regressionstabellen (Word/Excel).
-   Automatisierte Erstellung publikationsfähiger Tabellen.
-   Ergänzung weiterer Sensitivitätsanalysen.
-   Erweiterung der grafischen Ergebnisdarstellung.
