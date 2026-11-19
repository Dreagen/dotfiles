---
name: human-review
description: Tells you how to review code and decide which items need human review (uses hunk cli tool)
---

The review will be done using a hunk session, see skill hunk-review for interacting with hunk, this may be done against a PR in azure devops or just against code on the local branch, if unsure from the prompt ask for clarity from the user

Review has two parts

1. A standard review using the code-review skill.
2. A "human review" pass that notes which files a person needs to look at.

## Setup

- Use the skill `azure-devops` to connect to Azure DevOps.
- Identify the PR from the user's URL or org/project/repo/PR id. Get the source and target branches from `pullRequests/{id}` and the changed files from `pullRequests/{id}/iterations/{n}/changes`.
- Diff against the merge-base of the source and target branches, not the whole branch history.

## Part 1: standard review

Use the skill `code-review` to do a normal review. Any comments will be later added to a hunk session as notes.

## Part 2: human-review pass

Use a **different** sub agent from part 1. This agent must NOT post PR comments. It only marks files locally and returns a summary.
Return a list of all files which need to be reviewed by a human.

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
- Project files changes (e.g. package updates or reference changes)
- Anything out of the ordinary: large or surprising diffs, files unrelated to the PR's stated purpose, disabled or removed tests.

Exclude:
- Boilerplate that follows an existing pattern in the repo (DTOs, standard DI registration, simple endpoint wiring).
- Generated code, EF designer and snapshot files.
- Pure renames or moves, and formatting-only changes.
- Simple changes that are clearly correct (constants, typos, trivial config).

Order the list by importance and keep it short.

### Report

Return a summary table to the user with: file, reason, risk (high/medium/low).

Create a hunk session with all the files needed for human review plus any that have comments from the standard review,
add the comments from the standard review as agent notes in the hunk session and output the command needed to review the hunk session. This should have the diffs of the files agaisnt the root of the changes, 
if we were using git diff instead of hunk an example would be something like:

`git diff origin/main...HEAD -- path/to/File1.cs path/to/File2.cs`

