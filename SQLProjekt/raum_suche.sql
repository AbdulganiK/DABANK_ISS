SELECT
    r.RaumId,
    r.Bezeichnung,
    v.Kapazitaet,
    ru.Bezeichnung,
    ru.Beschreibung,
    ru.Status
FROM Raum r
         JOIN Veranstaltungsraum v ON r.RaumID = v.RaumID
         JOIN Raum_Utensilie ru on r.RaumId = ru.RaumId
where v.Kapazitaet >= 1 and ru.Bezeichnung = "Beamer" and ru.Status = 'funktionsfähig'
  AND NOT EXISTS (
    SELECT *
    FROM Zeitslot z
    WHERE z.RaumId = r.RaumId
      AND z.Startzeit < unixepoch('2026-06-01 20:00:00')
      AND z.Endzeit > unixepoch('2026-06-01 20:10:00')
);