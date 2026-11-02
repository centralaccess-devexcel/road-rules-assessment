# RoadRules learning log

2026-11-02 · .NET SDK 10.0.402 (EF Core 10.0.14, dotnet-ef 10.0.10) · VS Code · Windows 11, Docker Desktop 29

## What broke or surprised me

| What broke or surprised me | Why | What I did | What I learned |
|---|---|---|---|
| `dotnet new sln` produced `RoadRules.slnx`, not `RoadRules.sln` | .NET 10 defaults to the new XML solution format | `dotnet new sln -n RoadRules --format sln` | Templates change defaults between majors; check the output against the guide |
| dotnet-ef warned "tools version 10.0.10 is older than runtime 10.0.14" | Global tool not updated | Harmless; `dotnet tool update --global dotnet-ef` clears it | |
| No `sqlite3` on the machine to inspect `roadrules.db` | Prerequisite missing | `winget install SQLite.SQLite` | |
| `EffectiveFrom` is `TEXT` in SQLite (`2026-01-01`, `typeof` = text) | SQLite has no date type; EF Core stores `DateOnly` as ISO text | Nothing yet; this matters for the SQL Server move | The ISO format is what should make the move to a real `date` column safe |
| `dotnet new gitignore` has no `*.db` line, so `roadrules.db` would have been committed | The template only ignores specific `.db` names | Appended `*.db` to `.gitignore` before the first commit | Check `git status` before the first commit, not after |
| `Calculator.razor` did not compile: CS0542 `'Calculator': member names cannot be the same as their enclosing type` | The page's class is `Calculator` and `@inject IWeightCalculator Calculator` adds a property with the same name | Injected it as `Calc` instead | A `.razor` file is a class named after the file; injected names live in it |
| Broke a test on purpose: changed 17000 to 18000 in `FakeLimitSource` | To see the fake protect the numbers | `Expected: 17000, Actual: 18000`, 1 failed / 5 passed; changed it back, 6 passed | The tests run with no database and still catch a bad number |
| SQLite and SQL Server migrations differ | Migrations are provider-specific | Deleted `Migrations/`, regenerated as `InitialSqlServer`; the SQLite one stays in the first commit | `INTEGER`/`TEXT` became `int`/`nvarchar(max)`/`date`; `Sqlite:Autoincrement` became `SqlServer:Identity "1, 1"` |
| The sqlite3 3.54 dump was `INSERT INTO AxleLimits VALUES(16,1,...)`: names not quoted, but **no column list** | `.mode insert` writes values only | Added the column list plus `SET IDENTITY_INSERT AxleLimits ON/OFF` (see `extra_rows.sql`) | SQL Server Msg 8101: explicit identity values need **both** a column list and `IDENTITY_INSERT ON`; either alone fails |
| `docker exec ... /opt/mssql-tools18/bin/sqlcmd` from Git Bash failed with `C:/Program Files/Git/opt/` | Git Bash rewrites Unix-looking paths into Windows paths | `export MSYS_NO_PATHCONV=1` (or run from PowerShell) | |
| After the move, Ontario + 2 axles returned **17,500**, not the 17,000 the guide expects | `EfLimitSource` ordered only by `AxleCount`; rows 2 (17,000) and 17 (17,500) tie, and SQL Server's order among ties is undefined (it returned Id 17 first) | Added `.ThenBy(l => l.Id)` so the seeded row wins deterministically | "It ignores EffectiveFrom" was true, but which row it picked was luck; a missing tiebreaker is a bug on any provider |
| `WeightCalculator` ignores `EffectiveFrom`; the July 2026 row (Id 17, 17,500) exists but is never used | Deliberate gap in tier one | Left as is | Fixed by tier two, step 11 |
| NU1903: `System.Security.Cryptography.Pkcs` 9.0.11 has a high-severity advisory | Transitive: EF Core SqlServer → Microsoft.Data.SqlClient 6.1.7 → Pkcs 9.0.11 | Pinned `System.Security.Cryptography.Pkcs` 10.0.14 in `RoadRules.csproj` | `dotnet nuget why <project> <package>` shows the chain |
| Jurisdictions page shows 5 limits per jurisdiction on SQL Server, not 3 | The 10 migrated rows are included | Expected | |

## Migration reconciliation (step 7)

| Check | SQLite (before) | SQL Server (after) |
|---|---|---|
| `SELECT COUNT(*), SUM(MaxKg) FROM AxleLimits` | 25, 416,350 | 25, 416,350 |
| `SELECT COUNT(*) FROM Jurisdictions` | 5 | 5 |
| Id 16 | 1, Single, 1, 9500, 2026-07-01 | 1, Single, 1, 9500, 2026-07-01 |
| Id 25 | 4, Tridem, 3, 24100, 2026-07-01 | 4, Tridem, 3, 24100, 2026-07-01 |
| Id 17 (July tandem) | 17,500 | present, 17,500 |

Sum check by hand: seeded 252,300 + ten added 164,050 = 416,350.
