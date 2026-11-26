---
name: mutation-review
description: Run Stryker.NET mutation testing on the code changed on a branch, in a dedicated long-lived git worktree, and report which mutants were killed or survived; later re-run in the same worktree to verify that newly added tests kill the survivors. Use as a review stage after implementing a feature, or when asked to check test coverage quality with mutation testing.
---

# Mutation review

Finds gaps in the existing tests by mutating the **changed production code** and checking that tests fail.
A surviving mutant means no test noticed the change. This skill only **reports**; it does not write tests.

Requires the repo to contain `scripts/mutation.cs` (a cross-platform .NET file-based app), `stryker-config.json` and the `dotnet-stryker` tool in
`.config/dotnet-tools.json`. If they are missing, tell the user instead of improvising.

## Why a worktree
Stryker runs build and test cycles for several minutes. Running it in a separate worktree
(`../<repo>-mutation` by default) keeps the main checkout free, and the worktree and its results stay around
so the same run can be re-checked after tests are added. The worktree only sees **committed** code.

## Run (report phase)

1. Make sure the feature code is committed (the worktree cannot see uncommitted changes).
2. From the repo root:
   ```bash
   dotnet run scripts/mutation.cs -- run --base main
   ```
   - `--base <ref>`: what the feature branched from (default `main`); only lines changed since the merge-base are mutated.
   - `--feature <ref>`: commit to test (default `HEAD`).
   - `--worktree <path>`: override the worktree location.
   - `--whole-files`: mutate whole changed files instead of only the changed lines (use the same flag for `verify`).
   - Takes roughly 3-5 minutes; use a generous command timeout (>= 1800s).
3. Return to the caller:
   - the full `summary.md` output (totals + each undetected mutant with file, line, original code, mutation),
   - the **worktree path/name**,
   - a short triage of each undetected mutant (see below). Do not write or edit tests.

## Triage guidance
- **NO COVERAGE**: no test executes that code at all. Highest priority; a test is missing.
- **SURVIVED**: code is executed but no assertion depends on it. Say what behaviour is unasserted
  (e.g. "no test where `RelatedEntity` is `Funds` asserts `FundId` is returned").
- For EF Core query mutants, the usual fix is test data: each clause needs a row that matches and a row that
  doesn't, plus an ordering assertion where `OrderBy` is used.
- Flag likely **equivalent mutants** (the mutation cannot change observable behaviour, e.g. logging text,
  exception message strings that nothing asserts, `<` vs `<=` on values that can never be equal) as
  "probably equivalent, suggest ignoring" rather than demanding a test.
- Do not suggest tests that just mirror the implementation.

## Verify phase (after tests were added)

The caller adds tests on the feature branch and **commits** them. Then, from the repo root:

```bash
dotnet run scripts/mutation.cs -- verify --base main
```

This moves the previous results aside, checks out the new commit in the same worktree, re-runs Stryker and
reports: previously undetected mutants that are now killed, still undetected, new survivors, and mutants that
could not be re-tested (source lines moved). Return that report to the caller.

## Cleanup
When the user is done: `git worktree remove --force <worktree-path>`. Results live in
`<worktree>/StrykerOutput/` (`current/`, `previous/`, `summary.md`, per-project `*.log`).

## Notes / gotchas
- Stryker's own `--since` does not work inside a worktree, hence the line ranges computed by
  `scripts/mutation.cs`.
- In `stryker-config.json` the persistence scope is the `*EfPersistenceQuery.cs` and `*EfRepository.cs` files;
  migrations, entity type configurations and DbContexts are excluded.
- If Stryker fails, the script prints the tail of `StrykerOutput/current/<project>.log`.
