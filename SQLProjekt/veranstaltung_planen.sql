-- ============================================================
--  UC1 "Veranstaltung planen" / US04 "Event erstellen"
--  Akteur: Veranstalter (UserId 5, 'TechTalks e.V.')
--
--  Eingabewerte des Formulars:
--    Titel       : 'Data Science Summit'
--    Zeitraum    : 2026-11-12 09:00 - 13:00
--    Teilnehmer  : 80 erwartet
--    Ausstattung : Beamer
--    Speaker     : UserId 3 und UserId 4
-- ============================================================

BEGIN TRANSACTION;

-- ------------------------------------------------------------
-- Schritt 1 : Basisdaten erfassen, Status 'geplant'
-- ------------------------------------------------------------
INSERT INTO Event (EventId, VeranstalterId, Titel, Beschreibung, Status, Datum)
VALUES (4, 5,
        'Data Science Summit',
        'Vortraege und Hands-On Sessions rund um Datenanalyse.',
        'geplant',
        unixepoch('2026-11-12 09:00:00'));

-- ------------------------------------------------------------
-- Schritt 2  Das System schlaegt passende Raeume vor
--   - Veranstaltungsraum mit ausreichender Kapazitaet
--   - geforderte Ausstattung vorhanden und funktionsfaehig
--   - im Wunschzeitraum noch nicht belegt
-- ------------------------------------------------------------
SELECT r.RaumId,
       r.Bezeichnung AS Raum,
       r.Typ,
       vr.Kapazitaet
FROM Raum r
         JOIN Veranstaltungsraum vr ON vr.RaumId = r.RaumId
         JOIN Raum_Utensilie ru ON ru.RaumId = r.RaumId
WHERE vr.Kapazitaet >= 80
  AND ru.Bezeichnung = 'Beamer'
  AND ru.Status = 'funktionsfähig'
  AND NOT EXISTS (SELECT 1
                  FROM Zeitslot z
                  WHERE z.RaumId = r.RaumId
                    AND z.Startzeit < unixepoch('2026-11-12 13:00:00')
                    AND z.Endzeit > unixepoch('2026-11-12 09:00:00'))
ORDER BY vr.Kapazitaet;

-- ------------------------------------------------------------
-- Schritt 3 : Zeitslot fuer den gewaehlten Raum anlegen
-- ------------------------------------------------------------
INSERT INTO Zeitslot (ZeitslotId, Startzeit, Endzeit, Bezeichnung, RaumId, EventId)
VALUES (5,
        unixepoch('2026-11-12 09:00:00'),
        unixepoch('2026-11-12 13:00:00'),
        'Hauptprogramm',
        1,      -- gewaehlter Raum aus Schritt 2
        4);

-- ------------------------------------------------------------
-- Schritt 4 : Raum und Zeitslot fest buchen
-- ------------------------------------------------------------
INSERT INTO Zeitslot_Buchung (ZeitslotId, EventId, Status, GebuchtAm)
VALUES (5, 4, 'bestätigt', unixepoch('2026-08-15 12:00:00'));

-- ------------------------------------------------------------
-- Schritt 5 : Speaker zuweisen
--   Alternativablauf "kein Speaker": Block weglassen
-- ------------------------------------------------------------
INSERT INTO Speaker_Belegung (EventId, SpeakerId, Rolle)
VALUES (4, 3, 'Hauptrednerin'),
       (4, 4, 'Co-Referent');

-- ------------------------------------------------------------
-- Schritt 6 : Veroeffentlichen
--   Alternativablauf "nicht publizieren": Status bleibt 'geplant'
-- ------------------------------------------------------------
UPDATE Event
SET Status = 'bestätigt'
WHERE EventId = 4;

COMMIT;

