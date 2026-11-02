# RoadRules

A small Blazor Web App built as a practice project: a weight calculator that
returns the maximum weight for an axle group in a jurisdiction. The numbers
are invented and nothing here is real regulatory data.

## Stack
- Blazor Web App (.NET 10), Interactive Server render mode
- EF Core 10 with SQL Server (started on SQLite; see "Migration" below)
- xUnit tests against a fake data source
- Docker, multi-stage build

## Run
    docker run -e "ACCEPT_EULA=Y" -e "MSSQL_SA_PASSWORD=RoadRules_Pa55w0rd" -p 1433:1433 --name roadrules-sql -d mcr.microsoft.com/mssql/server:2022-latest
    dotnet run --project RoadRules

Then open the URL printed. Migrations apply on startup.

## Test
    dotnet test

## Container
    docker build -t roadrules .
    docker run -p 8080:8080 -e "ConnectionStrings__Default=Server=host.docker.internal,1433;Database=RoadRules;User Id=sa;Password=RoadRules_Pa55w0rd;TrustServerCertificate=True" roadrules

Then open http://localhost:8080/calculator.

## Migration
The project started on SQLite and was moved to SQL Server. Migrations were
regenerated for the new provider; ten rows that existed only in SQLite were
moved with an INSERT script (IDENTITY_INSERT, bracketed names, ISO dates)
and reconciled by row count and sum of MaxKg. The script is `extra_rows.sql`.

## Note
The SA password is in appsettings.json because this is a throwaway project.
In anything real it would come from user secrets locally and Key Vault in Azure.
