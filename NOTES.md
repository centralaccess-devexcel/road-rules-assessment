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
