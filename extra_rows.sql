-- The ten rows that existed only in SQLite, dumped with:
--   sqlite3 roadrules.db ".mode insert AxleLimits" "SELECT * FROM AxleLimits WHERE Id > 15;" > extra_rows.sql
-- Fixed for SQL Server:
--   1. Id is an IDENTITY column, so explicit ids need IDENTITY_INSERT ON before and OFF after.
--   2. IDENTITY_INSERT requires an explicit column list; the sqlite3 dump had none (INSERT INTO AxleLimits VALUES(...)).
--   3. Names are left unquoted; SQL Server would want [brackets], not "double quotes", if they were quoted.
--   4. Dates stay as ISO text ('2026-07-01'), which SQL Server converts to date; any other format would not be safe.
SET IDENTITY_INSERT AxleLimits ON;
INSERT INTO AxleLimits (Id, JurisdictionId, AxleGroup, AxleCount, MaxKg, EffectiveFrom) VALUES (16, 1, 'Single', 1, 9500, '2026-07-01');
INSERT INTO AxleLimits (Id, JurisdictionId, AxleGroup, AxleCount, MaxKg, EffectiveFrom) VALUES (17, 1, 'Tandem', 2, 17500, '2026-07-01');
INSERT INTO AxleLimits (Id, JurisdictionId, AxleGroup, AxleCount, MaxKg, EffectiveFrom) VALUES (18, 2, 'Single', 1, 9200, '2026-07-01');
INSERT INTO AxleLimits (Id, JurisdictionId, AxleGroup, AxleCount, MaxKg, EffectiveFrom) VALUES (19, 3, 'Tridem', 3, 24500, '2026-07-01');
INSERT INTO AxleLimits (Id, JurisdictionId, AxleGroup, AxleCount, MaxKg, EffectiveFrom) VALUES (20, 4, 'Tandem', 2, 17200, '2026-07-01');
INSERT INTO AxleLimits (Id, JurisdictionId, AxleGroup, AxleCount, MaxKg, EffectiveFrom) VALUES (21, 5, 'Single', 1, 9300, '2026-07-01');
INSERT INTO AxleLimits (Id, JurisdictionId, AxleGroup, AxleCount, MaxKg, EffectiveFrom) VALUES (22, 5, 'Tandem', 2, 17100, '2026-07-01');
INSERT INTO AxleLimits (Id, JurisdictionId, AxleGroup, AxleCount, MaxKg, EffectiveFrom) VALUES (23, 2, 'Tridem', 3, 26500, '2026-07-01');
INSERT INTO AxleLimits (Id, JurisdictionId, AxleGroup, AxleCount, MaxKg, EffectiveFrom) VALUES (24, 3, 'Single', 1, 9150, '2026-07-01');
INSERT INTO AxleLimits (Id, JurisdictionId, AxleGroup, AxleCount, MaxKg, EffectiveFrom) VALUES (25, 4, 'Tridem', 3, 24100, '2026-07-01');
SET IDENTITY_INSERT AxleLimits OFF;
