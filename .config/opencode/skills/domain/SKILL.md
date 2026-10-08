---
name: domain
description: Rules for the Domain layer (Domain / SharedKernel projects) - entities, aggregates, value objects, domain events, invariants, factory methods, repository interfaces and Dataglide.Generators attributes ([DomainId], [DomainPrimitive<T>], [DomainSerializable]). Use when creating or changing domain types or business rules.
---

# Domain Layer

## Purpose
The Domain layer contains the core business model and business rules.
It must remain pure and dependency‑free.

## Responsibilities
- Define entities, value objects, domain events, and invariants
- Enforce invariants using factory methods (no public constructors)
- Encapsulate business logic inside domain entities (rich domain model)
- Avoid anemic domain models (ie entities with only properties and no behaviour)
- Keep domain entities persistence‑ignorant
- Keep the structure of the entity, value objects and domain events in the same folder structure as its associated entity; common events and value objects can go in their own folders.
- All Entity objects should have a `CreatedOn` and `ModifiedOn` DateTime property that are set internally within the domain layer only when each aggregate updates.
- No external dependencies other than the Dataglide packages (Dataglide.Functional, Dataglide.FunctionalExtensions, Dataglide.Generators)
- Repository interfaces must always be defined in the Domain layer, but their implementations must be in the Persistence layer. 

## Notes
- Entities should inherit from the abstract `Entity` base class.
- Domain events are named in past tense: `<Entity><Action>Event`.

## Dataglide Generators
We have attributes in the Dataglide.Generators package which help when creating domain types:
| Attribute | Description |
| ---- | -----|
|`[DomainSerializable]` | Used to provide an empty private constructor for ef core |
|`[DomainPrimitive<T>]` | Used to create domain primitive wrappers around primitive types e.g `string` |
|`[DomainId]` | Used for creating wrappers around domain identifies instead of `Guid` |

## Related skills
- `functional` - for domain methods that return `Result` / `Option`
- `persistence` - where repository interfaces defined here are implemented
- `testing` - domain unit tests (rare; prefer application-level tests)
