---
name: application
description: Rules for the Application layer (Application projects) - MediatR commands, queries and handlers, validators, query interfaces, ITransactionRequest, unit of work and ITimeService. Use when adding or changing a use case, command, query, handler or validator.
---

# Application Layer

## Purpose
Coordinates use cases and orchestrates domain and persistence interactions.

## Responsibilities
- Implement MediatR commands, queries, and handlers
- MediatR commands should be defined as a C# record with positional parameters, and should be defined in the same C# file as their handler but outside the handler class.
- Use repositories for all command stack data access (no direct EF Core queries in handlers)
- The application layer may never reference the Persistence layer directly; it should only reference the repositories via interfaces defined in the Domain layer. The actual repository implementations in the Persistence layer will be injected at runtime.
- Implement queries with an interface so that InMemory versions can be used for testing without EF Core dependencies.
- the type `ITransactionRequest` or `ITransactionRequest<T>` can be used when only one SaveChanges is required.
- Use Unit of Work when multiple repository operations must be atomic

## Functional Programming Style

Handlers must use functional style - load the `functional` skill.

## Notes
- Handlers must not contain UI or API logic
- Validators enforce input rules, not domain invariants
- **Time Handling Rule**: The Application layer must NEVER use `DateTime.Now` or similar. All time-dependent operations must use `ITimeService` to ensure testability and determinism.

## Related skills
- `functional` - required for every handler
- `domain` - entities and repository interfaces the handler orchestrates
- `persistence` - repository and query implementations, and the repository vs query decision guide
- `testing` - application-level tests are the primary test type
