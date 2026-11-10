---
name: dotnet-10-upgrade
description: Use when upgrading a .NET solution or project to .NET 10, including SDKs, target frameworks, .NET platform packages, build pipelines, and migration verification.
compatibility: opencode
---

# Upgrade a .NET solution to .NET 10

Upgrade the existing solution to .NET 10 carefully, preserving its architecture, behavior, and established conventions. Treat this as a framework migration, not a general dependency refresh or refactor.

## Scope and package-version policy

- Upgrade only dependencies that are part of, or directly support, the .NET platform being migrated. Examples include .NET SDK/workload components, `Microsoft.NET.*` build and test tooling, ASP.NET Core and `Microsoft.Extensions.*` packages, Entity Framework Core, and .NET platform-specific libraries whose versions must align with the target framework.
- For each in-scope package, determine and use its latest **stable** version that is compatible with .NET 10 and the project's other in-scope packages. Confirm versions using authoritative NuGet package metadata and/or official .NET documentation. Never select preview, alpha, beta, RC, or other prerelease versions.
- Do not upgrade unrelated application, vendor, UI, logging, serialization, cloud-provider, or other third-party packages merely because newer versions exist. Do not run a blanket package-update command. If an unrelated package blocks the migration, explain the specific incompatibility and change it only when required to restore .NET 10 compatibility.
- Do not assume every .NET-related package should have version `10.x`; use the latest stable compatible version available for that package. Keep coordinated Microsoft package families on compatible versions and avoid mixing incompatible major versions.
- Preserve existing version-management conventions, including `Directory.Packages.props`, central package management, lock files, and repository-specific package files.

## Migration workflow

1. **Inspect before editing.** Identify the repository's SDK pin (`global.json`), solution and project files, target frameworks, project references, central package/version files, build scripts, CI workflows, Dockerfiles, deployment manifests, and test commands. Note multi-targeting, platform workloads, and any projects intentionally staying on an older framework.
2. **Establish a baseline.** Run the existing restore/build and relevant tests where possible. Record pre-existing failures so they are not confused with migration regressions. Check the installed .NET 10 SDK and required workloads; install or document prerequisites only as appropriate to the environment.
3. **Review migration guidance.** Consult the official .NET 10 upgrade guide, breaking changes, and release notes for the application's project types and dependencies. Use guidance applicable to the exact source and destination versions; do not apply unrelated migration suggestions.
4. **Update framework and SDK configuration.** Change applicable project TFMs to `net10.0` (or the appropriate .NET 10 platform-specific TFM), update the SDK pin in `global.json` when present, and update relevant `TargetFramework`/`TargetFrameworks` properties, build configuration, and project metadata. Preserve intentional multi-targeting and platform-specific targets rather than replacing them indiscriminately.
5. **Update only in-scope packages and tooling.** Select the latest stable compatible versions under the package policy above. Review transitive and centrally managed versions as needed, but do not use this migration to refresh unrelated direct or transitive dependencies.
6. **Resolve migration issues deliberately.** Address compiler errors, obsolete API warnings that indicate required .NET 10 changes, analyzer findings, and documented behavior changes. Prefer small, behavior-preserving edits. Avoid unrelated refactoring, style churn, or suppressions that hide a real compatibility issue.
7. **Update build and deployment surfaces.** Check CI SDK setup and caching, restore/build/test/publish commands, container base images, runtime identifiers, deployment/runtime prerequisites, and any scripts or manifests that encode an older framework version. Change only .NET 10-related settings and retain existing operational choices.
8. **Verify from restore through publish.** Restore, build the full solution in the relevant configurations, run unit/integration tests, and publish representative deployable projects. Run repository-specific formatting, analyzers, and packaging checks when they are part of normal validation. For multi-targeted or platform-specific projects, verify each affected target that can be exercised in the environment.
9. **Review the final diff.** Confirm all intended projects and .NET 10 configuration surfaces were handled, unrelated package versions and behavior remain untouched, and no preview versions or accidental broad upgrades were introduced. Summarize changes, verification results, and any blocked or unavailable checks.

## Important compatibility checks

- Review .NET 10 breaking changes relevant to the application, especially runtime behavior, ASP.NET Core, Entity Framework Core, serialization, hosting, and platform-specific workloads where used.
- Ensure EF Core packages, providers, design-time tooling, and migrations are mutually compatible. Do not upgrade a provider just because EF Core was upgraded unless compatibility requires it.
- Check test projects and test infrastructure as well as production projects; upgrade .NET-specific test SDKs and framework integrations only when needed for stable .NET 10 support.
- Validate project references and shared build props so libraries, executables, and tests agree on intended target frameworks.
- Preserve deployment model and runtime assumptions (framework-dependent, self-contained, trimming, AOT, containers, and runtime identifiers). Revalidate options affected by .NET 10 rather than changing them by default.
- If a required dependency has no stable .NET 10-compatible release, do not silently use a prerelease or force an incompatible version. Report the blocker and its impact, and make any feasible independent migration progress.

## Completion report

Report the projects/TFMs migrated, .NET-related packages and tooling changed with their selected versions, significant compatibility fixes, commands/checks run and their results, and any remaining blockers. Explicitly note if unrelated package versions were left unchanged.
