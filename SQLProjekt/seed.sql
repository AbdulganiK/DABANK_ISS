-- ============================================================
--  DABANK – Seed-Daten für ProjectDatabase.db
--  Erzeugt ein zusammenhängendes Beispielszenario:
--  Adressen, Fakultäten, Gebäude/Etagen/Räume, Nutzer mit ihren
--  Rollen, Events mit Zeitslots, Buchungen, Feedback & Rechnungen.
--
--  Re-runnable: löscht vorhandene Daten und setzt AUTOINCREMENT zurück.
-- ============================================================

PRAGMA foreign_keys = OFF;
BEGIN TRANSACTION;

-- --- Aufräumen (Reihenfolge egal, da FKs aus) -------------
DELETE FROM Zeitslot_Buchung;
DELETE FROM Teilnehmer_Buchung;
DELETE FROM Speaker_Belegung;
DELETE FROM Feedback;
DELETE FROM Agenda;
DELETE FROM Zeitslot;
DELETE FROM Rechnung;
DELETE FROM Event;
DELETE FROM Raum_Utensilie;
DELETE FROM Veranstaltungsraum;
DELETE FROM Raum;
DELETE FROM Etage;
DELETE FROM Gebaeude;
DELETE FROM Fakultaet;
DELETE FROM Gebaeudeleiter;
DELETE FROM Speaker;
DELETE FROM Veranstalter;
DELETE FROM Teilnehmer;
DELETE FROM Adresse;
DELETE FROM "User";
DELETE FROM sqlite_sequence;

-- ============================================================
--  Adressen
-- ============================================================
INSERT INTO Adresse (AdresseId, "Straße", Hausnummer, Postleitzahl, Stadt) VALUES
  (1, 'Musterstraße',   12, '10115', 'Berlin'),
  (2, 'Hauptstraße',     5, '20095', 'Hamburg'),
  (3, 'Lindenallee',    23, '80331', 'München'),
  (4, 'Bahnhofstraße',   8, '50667', 'Köln'),
  (5, 'Gartenweg',      14, '60311', 'Frankfurt'),
  (6, 'Schlossplatz',    1, '70173', 'Stuttgart');

-- ============================================================
--  Fakultäten
-- ============================================================
INSERT INTO Fakultaet (FakultaetId, Name, Kuerzel) VALUES
  (1, 'Informatik',                'INF'),
  (2, 'Wirtschaftswissenschaften', 'WIWI'),
  (3, 'Maschinenbau',              'MB'),
  (4, 'Design',                    'DES');

-- ============================================================
--  Gebäude
-- ============================================================
INSERT INTO Gebaeude (GebaeudeId, Bezeichnung, Adresse, Baujahr, FakultaetId) VALUES
  (1, 'Hauptgebäude', 1, 1998, 1),
  (2, 'Technikum',    2, 2010, 3),
  (3, 'Mensa & Aula', 3, 2005, 2);

-- ============================================================
--  Etagen
-- ============================================================
INSERT INTO Etage (EtagenId, GebaeudeId, Ebene) VALUES
  (1, 1, 'Erdgeschoss'),
  (2, 1, '1. Obergeschoss'),
  (3, 2, 'Erdgeschoss'),
  (4, 3, 'Erdgeschoss'),
  (5, 3, '1. Obergeschoss');

-- ============================================================
--  Räume
-- ============================================================
INSERT INTO Raum (RaumId, EtagenId, Bezeichnung, Typ, Flaeche) VALUES
  (1, 1, 'H001 Hörsaal',       'Hörsaal',           120.5),
  (2, 1, 'S002 Seminarraum',   'Seminarraum',        45.0),
  (3, 2, 'L101 Labor',         'Labor',              60.0),
  (4, 3, 'T001 Werkstatt',     'Werkstatt',         200.0),
  (5, 4, 'Aula',               'Veranstaltungssaal', 350.0),
  (6, 5, 'K1 Konferenzraum',   'Konferenzraum',      80.0);

-- Veranstaltungsräume (Spezialisierung von Raum mit Kapazität)
INSERT INTO Veranstaltungsraum (RaumId, Kapazitaet) VALUES
  (1, 100),
  (5, 300),
  (6,  60);

-- Ausstattung / Utensilien
INSERT INTO Raum_Utensilie (RaumId, UtensilienId, Bezeichnung, Beschreibung, Status) VALUES
  (1, 1, 'Beamer',               'Full-HD Deckenbeamer',        'funktionsfähig'),
  (1, 2, 'Whiteboard',           'Großes Whiteboard',           'funktionsfähig'),
  (5, 3, 'Mikrofonanlage',       '4 Funkmikrofone + Mischpult', 'funktionsfähig'),
  (5, 4, 'Bühnenlicht',          'LED-Scheinwerfer',            'in Wartung'),
  (6, 5, 'Videokonferenzsystem', 'Kamera, Display, Mikrofon',   'funktionsfähig');

-- ============================================================
--  Nutzer (Basistabelle)
-- ============================================================
INSERT INTO "User" (UserId, Vorname, Nachname, Email, AdresseID) VALUES
  (1,  'Anna',  'Schmidt',   'anna.schmidt@dabank.de',   1),
  (2,  'Bernd', 'Müller',    'bernd.mueller@dabank.de',  2),
  (3,  'Clara', 'Weber',     'clara.weber@dabank.de',    3),
  (4,  'David', 'Fischer',   'david.fischer@dabank.de',  4),
  (5,  'Eva',   'Becker',    'eva.becker@dabank.de',     5),
  (6,  'Felix', 'Wagner',    'felix.wagner@dabank.de',   6),
  (7,  'Greta', 'Hoffmann',  'greta.hoffmann@dabank.de', 1),
  (8,  'Hans',  'Schulz',    'hans.schulz@dabank.de',    2),
  (9,  'Ida',   'Koch',      'ida.koch@dabank.de',       3),
  (10, 'Jonas', 'Bauer',     'jonas.bauer@dabank.de',    4);

-- --- Rollen-Spezialisierungen ----------------------------
INSERT INTO Gebaeudeleiter (UserId, Buero_Nummer) VALUES
  (1, 'H1.01'),
  (2, 'T2.05');

INSERT INTO Speaker (UserId, Biografie) VALUES
  (3, 'Professorin für Künstliche Intelligenz, 15 Jahre Forschungserfahrung.'),
  (4, 'Cloud-Architekt und freiberuflicher Trainer für DevOps-Themen.');

INSERT INTO Veranstalter (UserId, Organisation, Telefon) VALUES
  (5, 'TechTalks e.V.',    301234567),
  (6, 'Uni Career Center', 302345678);

INSERT INTO Teilnehmer (UserId, Matrikelnummer, Studiengang) VALUES
  (7,  100001, 1),
  (8,  100002, 2),
  (9,  100003, 1),
  (10, 100004, 3);

-- ============================================================
--  Events
-- ============================================================
INSERT INTO Event (EventId, VeranstalterId, Titel, Beschreibung, Status, Datum) VALUES
  (1, 5, 'KI in der Praxis',        'Ganztägige Konferenz zu KI-Anwendungen in der Industrie.', 'geplant',       unixepoch('2026-09-15 10:00:00')),
  (2, 6, 'Karrieretag 2026',        'Firmenmesse mit Vorträgen und Recruiting-Ständen.',        'bestätigt',     unixepoch('2026-10-01 09:00:00')),
  (3, 5, 'Cloud Computing Workshop','Praxis-Workshop zu Kubernetes und CI/CD.',                 'abgeschlossen', unixepoch('2026-06-20 14:00:00'));

-- ============================================================
--  Agenda
-- ============================================================
INSERT INTO Agenda (AgendaId, EventId, GebaeudeleiterId, Titel, Inhalt) VALUES
  (1, 1, 1, 'Begrüßung',        'Eröffnung durch die Fakultät Informatik.'),
  (2, 1, 1, 'Keynote',          'KI-Grundlagen und aktuelle Trends.'),
  (3, 2, 2, 'Unternehmensmesse','Stände der Partnerfirmen im Foyer der Aula.');

-- ============================================================
--  Speaker-Belegung (Event <-> Speaker)
-- ============================================================
INSERT INTO Speaker_Belegung (EventId, SpeakerId, Rolle) VALUES
  (1, 3, 'Hauptrednerin'),
  (1, 4, 'Co-Referent'),
  (3, 4, 'Workshop-Leiter');

-- ============================================================
--  Zeitslots
-- ============================================================
INSERT INTO Zeitslot (ZeitslotId, Startzeit, Endzeit, Bezeichnung, RaumId, EventId) VALUES
  (1, unixepoch('2026-09-15 10:00:00'), unixepoch('2026-09-15 12:00:00'), 'Vormittagssession',  1, 1),
  (2, unixepoch('2026-09-15 13:00:00'), unixepoch('2026-09-15 15:00:00'), 'Nachmittagssession', 1, 1),
  (3, unixepoch('2026-10-01 09:00:00'), unixepoch('2026-10-01 17:00:00'), 'Karrieretag',        5, 2),
  (4, unixepoch('2026-06-20 14:00:00'), unixepoch('2026-06-20 18:00:00'), 'Workshop',           6, 3);

INSERT INTO Zeitslot_Buchung (ZeitslotId, EventId, Status, GebuchtAm) VALUES
  (1, 1, 'bestätigt',     unixepoch('2026-08-01 09:30:00')),
  (2, 1, 'bestätigt',     unixepoch('2026-08-01 09:30:00')),
  (3, 2, 'bestätigt',     unixepoch('2026-09-05 11:00:00')),
  (4, 3, 'abgeschlossen', unixepoch('2026-05-15 08:00:00'));

-- ============================================================
--  Teilnehmer-Buchungen (Anmeldungen)
-- ============================================================
INSERT INTO Teilnehmer_Buchung (TeilnehmerId, EventId, Anmeldedatum) VALUES
  (7,  1, '2026-08-01'),
  (8,  1, '2026-08-03'),
  (9,  2, '2026-09-10'),
  (10, 3, '2026-06-01'),
  (7,  3, '2026-06-02');

-- ============================================================
--  Feedback (nur für abgeschlossenes Event)
-- ============================================================
INSERT INTO Feedback (FeedbackId, TeilnehmerId, EventId, Kommentar, Bewertung) VALUES
  (1, 10, 3, 'Sehr praxisnah und gut strukturiert!', 5),
  (2, 7,  3, 'Guter Workshop, aber leider etwas zu kurz.', 4);

-- ============================================================
--  Rechnungen
-- ============================================================
INSERT INTO Rechnung (RechnungsId, Betrag, UserId, Status, AusgestelltAm, FaelligAm) VALUES
  (1, 1500, 5,  'bezahlt', unixepoch('2026-07-01 00:00:00'), unixepoch('2026-07-31 00:00:00')),
  (2, 2500, 6,  'offen',   unixepoch('2026-09-01 00:00:00'), unixepoch('2026-09-30 00:00:00')),
  (3,   50, 7,  'bezahlt', unixepoch('2026-06-01 00:00:00'), unixepoch('2026-06-15 00:00:00')),
  (4,   75, 10, 'offen',   unixepoch('2026-06-01 00:00:00'), unixepoch('2026-06-15 00:00:00'));

COMMIT;
PRAGMA foreign_keys = ON;
