---
name: contracts
description: Rules for the Contracts project (Contracts projects) - NuGet-packaged API resources and enums. Use when adding or changing resources, DTOs or enums in Contracts, or when the package <Version> needs bumping.
---

## Conventions

- The Contracts project is published as a NuGet package (`Dataglide.CT.Application.Contracts`) and is consumed by external clients, so its contents are a public API surface.

## Package Versioning

- Whenever a resource, enum or any public type in Contracts is **added or changed**, bump the `<Version>` property in `Contracts.csproj` in the same change.
- Use semantic versioning:
  - **Minor** bump for additive changes (new resources, new fields, new enum values).
  - **Major** bump for breaking changes (renamed/removed fields or types, changed types, reordered/removed enum values).
- Do not ship Contracts changes without the corresponding version bump — consumers will not receive the new surface.

## Resource Conventions

- Contracts types are plain `record`s and enums; they must not reference Domain types.
- Domain enums that appear in responses need a separate resource-level enum in Contracts (e.g. `ShareClassInvestorReportStatus` → `ShareClassInvestorReportStatusResource`), mapped in the Application layer.
- Map domain primitives to their raw values (`Id.Value`, `Name.Value`) in the Application handler, not in Contracts.

## Message Enum Conventions

- Enums used in messages belong in Contracts. Bump `<Version>` in `Contracts.csproj` whenever an enum changes.
- Keep enum-to-text mapping out of Contracts. Put it in an Application extension method: the enum defines the business concept, while text is a presentation-specific representation.

## Related skills

- `api` - endpoint and routing conventions that expose these resources
- `application` - handlers that map projections to Contracts resources
