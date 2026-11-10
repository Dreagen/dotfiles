---
name: persistence
description: Rules for the Persistence layer (Persistence / EFPersistence projects) - EF Core DbContext, EntityTypeConfiguration classes (Fluent API), repository and query implementations, and choosing between a repository and a query. Use when adding or changing data access, EF Core mappings or migrations.
compatibility: opencode
---

# Persistence Layer

## Purpose
Implements infrastructure for storing and retrieving domain objects using EF Core.

## Responsibilities
- Interact with the EF Core DbContext
- Mirror the Domain folder structure
- When defining `EntityTypeConfiguration`, use the convention `<DomainObjectName>EntityTypeConfiguration` as the class name
- Check to see if a base class of `<Project>EntityTypeConfiguration<TEntity>` exists and inherit from it
- Implement repository classes that implement the repository interfaces defined in the Domain layer
- Use Fluent API only (no data annotations).

## Notes
- Persistence must not contain business logic

## Queries/Repositories

Methods should return either `IEnumerable<T>` or `Option<T>`. For conciseness we sometimes have a Required version of a function which returns `Result<T, ApplicationError>`.

```csharp
Task<IEnumerable<T>> GetAll();
Task<Option<T>> Get(TId id);
Task<Result<T, ApplicationError>> GetRequired(TId id);
```

## Repository vs Query Decision Guide

**When to use Repository (`IXxxRepository`)**:
- Loading an entity to call **domain logic/behavior** (even read-only methods)
- Loading an entity to **modify state** (command operations)
- Checking **existence** or **uniqueness** constraints
- Any operation that needs the **full domain entity**

**When to use Queries (`IXxxQueries`)**:
- Returning **read-optimized projections** (DTOs) for display
- **List/search** operations that don't need domain behavior
- **Aggregations, counts, or statistics**
- Cross-aggregate **reporting queries**

## Related skills
- `domain` - repository interfaces and the entities being mapped
- `functional` - `Option<T>` / `Result<T, ApplicationError>` return types
- `testing` - persistence tests use SQLite in-memory
