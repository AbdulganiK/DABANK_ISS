-- ============================================================
--  US19 "Kostenabrechnung"
--  Akteur: Gebaeudeleiter
--
--  Rechnungsbetrag = Raummiete (Stundensatz x Nutzungsdauer)
--                  + gebuchte Sitzplaetze (US9)
--                  + Ersatz defekter Materialien (US16/US22)
--
--  HINWEIS: Raum hat keinen Stundensatz und Raum_Utensilie keinen Preis.
--  Die Saetze sind deshalb im Query hinterlegt: Stundensatz je Raumtyp,
--  5 EUR je Sitzplatz, 250 EUR Pauschale je Ersatzteil.
-- ============================================================
WITH Kosten AS (
    SELECT e.EventId,
           e.Titel,
           u.Vorname || ' ' || u.Nachname AS Rechnungsempfaenger,
           -- Nutzungsdauer in Stunden
           (SELECT SUM((z.Endzeit - z.Startzeit) / 3600.0)
            FROM Zeitslot z
            WHERE z.EventId = e.EventId)                AS Nutzungsdauer_Std,
           -- Raummiete: Dauer x Stundensatz des Raumtyps
           (SELECT SUM((z.Endzeit - z.Startzeit) / 3600.0 *
                       CASE r.Typ
                           WHEN 'Veranstaltungssaal' THEN 150
                           WHEN 'Hörsaal'            THEN 100
                           WHEN 'Konferenzraum'      THEN  80
                           ELSE                            50
                       END)
            FROM Zeitslot z
                     JOIN Raum r ON r.RaumId = z.RaumId
            WHERE z.EventId = e.EventId)                AS Raummiete,
           -- Sitzplaetze: 5 EUR je Anmeldung
           (SELECT COUNT(*) * 5
            FROM Teilnehmer_Buchung tb
            WHERE tb.EventId = e.EventId)               AS Sitzplatzkosten,
           -- Material: 250 EUR je defektem Utensil im genutzten Raum
           (SELECT COUNT(*) * 250
            FROM Zeitslot z
                     JOIN Raum_Utensilie ru ON ru.RaumId = z.RaumId
            WHERE z.EventId = e.EventId
              AND ru.Status <> 'funktionsfähig')        AS Materialkosten
    FROM Event e
             JOIN "User" u ON u.UserId = e.VeranstalterId
    WHERE e.Status = 'abgeschlossen'    -- nur durchgefuehrte Veranstaltungen
)
SELECT EventId,
       Titel,
       Rechnungsempfaenger,
       Nutzungsdauer_Std,
       Raummiete,
       Sitzplatzkosten,
       Materialkosten,
       Raummiete + Sitzplatzkosten + Materialkosten AS Gesamtbetrag
FROM Kosten
ORDER BY EventId;

-- ------------------------------------------------------------
INSERT INTO Rechnung (RechnungsId, Betrag, UserId, Status, AusgestelltAm, FaelligAm)
VALUES (5, 330, 5, 'offen',
        unixepoch('2026-06-21 00:00:00'),
        unixepoch('2026-06-21 00:00:00') + 30 * 24 * 60 * 60);

