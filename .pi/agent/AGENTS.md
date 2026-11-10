# Dataglide Engineering Guidelines

## Architecture
.NET Clean Architecture. Project names vary by repo; identify the layer from the project name:

| Layer | Typical project names | References |
|---|---|---|
| Api | `Api`, `Server` | Application, Persistence (sole composition root) |
| Application | `Application`, `Application.Query` | Domain |
| Domain | `Domain`, `SharedKernel` | Dataglide packages only |
| Persistence | `Persistence`, `EFPersistence` | Domain |
| Tests | `<Layer>.Tests`, `<Layer>.IntegrationTests` | layer under test |

## Always-on conventions
- Indent with 4 spaces, never tabs.
- Suffixes: `Command`, `Query`, `Handler`, `Validator`, `Repository`.
- Domain and Persistence folder structures mirror each other; test projects mirror the layer they test.
- Only add a `CancellationToken` parameter when the signature requires it (e.g. MediatR handlers).
- Code that can fail for a business reason returns `Result<T, ApplicationError>`; optional values use `Option<T>` (see `functional`).

## Skills
Load every skill that matches the work before writing code. Most tasks need more than one.

| Working on | Load |
|---|---|
| Entities, value objects, domain events, repository interfaces | `domain` |
| Commands, queries, handlers, validators | `application`, `functional` |
| EF Core configuration, DbContext, repository/query implementations, migrations | `persistence` |
| Minimal API endpoints, routes, `Program.cs` / DI | `api`, `functional` |
| Any test project | `testing` (+ the skill for the layer under test) |
| Any `Result` / `Option` code | `functional` |
| .NET 10 upgrade | `dotnet-10-upgrade` |

A new feature end to end usually goes: `domain` -> `persistence` -> `application` -> `api` -> `testing`.
