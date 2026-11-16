---
name: azure-devops-code-review
description: Tells you how to review code in an azure devops pull request
---

Reviewing an Azure DevOps pull request has two parts, done by two separate sub agents:

1. A standard review that posts comments on the PR.
2. A "human review" pass that marks which files a person needs to look at.

## Setup

- Use the skill `azure-devops-pr` to connect to Azure DevOps.
- Identify the PR from the user's URL or org/project/repo/PR id. Get the source and target branches from `pullRequests/{id}` and the changed files from `pullRequests/{id}/iterations/{n}/changes`.
- Diff against the merge-base of the source and target branches, not the whole branch history.

## Part 1: standard review

Use the skill `code-review` to do a normal review. Add the resulting comments to the PR. Prefix any reply you post with "Agent Response: ".

## Part 2: human-review pass

Use a **different** sub agent from part 1. This agent must NOT post PR comments. It only marks files locally and returns a summary.

### Get the branch

- Work directly in the main working tree (the repo's normal checkout). Do not use a worktree by default.
- If the PR source branch is already checked out, use it. Otherwise check out the source branch.
- Only if the working tree has uncommitted changes, ask the user what to do. Offer: stash, use a separate `git worktree` (an option only, not the default), cancel the review, or something else.

### Decide which files need human review

Include:
- Files that add or change business logic (domain and application layers first: entities, value objects, handlers, validators).
- New or changed tests. Check whether they actually assert the behaviour they claim to.
- Security, auth, migrations, data deletion, concurrency or transaction changes.
- Public API contract changes (routes, request/response shapes).
- Anything out of the ordinary: large or surprising diffs, files unrelated to the PR's stated purpose, disabled or removed tests.

Exclude:
- Boilerplate that follows an existing pattern in the repo (DTOs, standard DI registration, simple endpoint wiring).
- Generated code, EF designer and snapshot files.
- Pure renames or moves, and formatting-only changes.
- Simple changes that are clearly correct (constants, typos, trivial config).

Order the list by importance and keep it short, aiming for around 15 files at most.

### Mark the files

Add a TODO comment at the top of each file that needs review, in this exact greppable format with a short reason:

`TODO(human-review): <reason>`

- Use the comment syntax of the file type: `//` for `.cs`, `<!-- -->` for `.csproj`/`.xml`/`.razor`/`.html`, `#` for `.yml`/`.yaml`.
- Skip files that can't hold comments (JSON, binaries, etc.). List them in the summary instead.
- Be idempotent: if the file already has a `TODO(human-review)` line, update it rather than adding another.
- Do NOT commit or push the TODOs. Leave them as uncommitted changes so they don't pollute the PR. Tell the user how to remove them: `git grep -l "TODO(human-review)"`.

### Report

Return a summary table to the user with: file, reason, risk (high/medium/low). Also list any files skipped because they couldn't take a comment.
