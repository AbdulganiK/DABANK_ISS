-- ============================================================
--  UC2 "Auslastungsanalyse pro Raum" / US15 "Auslastung einsehen"
--  Akteur: Gebaeudeleiter
--  Ziel:   Auslastung je Raum und Zeitslot auswerten, um zu erkennen,
--          ob eine Veranstaltung in einen groesseren oder kleineren
--          Raum verlegt werden sollte.
--
--  Eingabewerte des Formulars:
--    Zeitraum : 2026-06-01 bis 2026-12-31   (Zeile 27/28)
--    Raeume   : 1, 5, 6 - alle Veranstaltungsraeume
--               fuer einen einzelnen Raum die IN-Liste anpassen (Zeile 31)
-- ============================================================
SELECT
    r.RaumId,
    r.Bezeichnung AS Raum,
    vr.Kapazitaet,
    z.Bezeichnung AS Zeitslot,
    datetime(z.Startzeit, 'unixepoch') AS Beginn,
    datetime(z.Endzeit, 'unixepoch') AS Ende,
    e.Titel AS Event,
    COUNT(tb.TeilnehmerId) AS Anmeldungen,
    (100.0 * COUNT(tb.TeilnehmerId) / vr.Kapazitaet) AS Auslastung_Prozent,
    CASE
        WHEN COUNT(tb.TeilnehmerId) = vr.Kapazitaet THEN 'Voll ausgelastet'
        WHEN COUNT(tb.TeilnehmerId) >= vr.Kapazitaet * 0.5 THEN 'Mittel ausgelastet'
        WHEN COUNT(tb.TeilnehmerId) > 0 THEN 'Gering ausgelastet'
        ELSE 'Frei'
        END AS Interpretation
FROM Raum r
         JOIN Veranstaltungsraum vr ON vr.RaumId = r.RaumId
         LEFT JOIN Zeitslot z ON z.RaumId = r.RaumId
    AND z.Startzeit >= unixepoch('2026-06-01 00:00:00')
    AND z.Endzeit <= unixepoch('2026-12-31 23:59:59')
         LEFT JOIN Event e ON e.EventId = z.EventId
         LEFT JOIN Teilnehmer_Buchung tb ON tb.EventId = e.EventId
WHERE r.RaumId IN (1, 5, 6)
GROUP BY r.RaumId, r.Bezeichnung, vr.Kapazitaet, z.ZeitslotId, z.Bezeichnung, z.Startzeit, z.Endzeit, e.Titel
ORDER BY r.RaumId, z.Startzeit;