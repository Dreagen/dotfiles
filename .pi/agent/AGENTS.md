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

## Quality and workflow
- Before declaring work done, run a build and the full test suite. Keep new compiler warnings at zero, including in test projects.
- Finish with a cleanup pass: remove unused usings and parameters, use named arguments where they improve clarity, and follow the test naming convention in the testing skill.
- Do not change behavior in a cleanup commit. Keep behavioral changes separate from refactors.
- When a spec lists scenarios, list the requested items back to the user and ask about undecided details (such as queue settings or enum members) rather than inventing values.

## Contracts and class structure
- Prefer enums over free strings for values crossing a contract, such as a message or API. Put the enum in Contracts and bump the package <Version>.
- Place private methods at the bottom of a class file.

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
