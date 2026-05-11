---
name: commit-this
description: Read the staged git diff or the last unpublished commit, generate a Conventional Commits message with a gitmoji prefix, emit it, then ask once whether to run git commit on behalf of the user. Invoke with /commit-this.
model: claude-haiku-4-5-20251001
allowed-tools:
  - Bash
---

## Usage

**Invoke**: `/commit-this` — no arguments. The skill auto-detects whether to read staged changes or the last unpublished commit.

- Slash command `/commit-this`
- Activates only on the slash command. No keyword trigger.

## Inputs

| Name | Format | Source |
|------|--------|--------|
| staged_diff | unified diff | `git diff --staged` (preferred when present) |
| last_commit | commit + diff | `git show HEAD` (fallback when nothing staged) |
| repo_state | text | `git rev-parse --is-inside-work-tree`, `git status -sb` |

## Outputs

| Name | Format | Destination |
|------|--------|-------------|
| commit_message | Conventional Commits text with gitmoji prefix | shown inline to the user |
| commit_action | shell side effect | `git commit -m "<message>"` via Bash, only if user answers yes |

## Step-by-step protocol

**Step 1 — Validate environment**
Run `git rev-parse --is-inside-work-tree` to confirm a git repo. Run `git diff --staged --name-only` to detect staged files. If empty, run `git log -1 --format="%H"` to confirm a commit exists. Run `git status -sb` and inspect for `[ahead N]` — if the branch has an upstream and is not ahead, the last commit is published. Refuse and terminate on any failure with a one-line reason. Produce: `validation_pass = true` plus `input_source ∈ {staged, last_commit}`.

**Step 2 — Read the diff**
If `input_source = staged`, run `git diff --staged`. If `input_source = last_commit`, run `git show HEAD`. Capture the full diff text and the list of changed files. Produce: `diff_text`, `changed_files[]`.

**Step 3 — Infer type, scope, breaking flag, gitmoji**
Apply rules from `refs/conventional-commits.md`:
- **Type**: classify against the type table (feat, fix, refactor, docs, test, chore, perf, ci, style, build, revert).
- **Scope**: take the most specific common path segment across `changed_files[]`. Multi-domain → top-level domain.
- **Breaking flag**: scan for renamed/removed public symbols, parameter signature changes, return type changes. If found → set `breaking = true`.
- **Gitmoji**: look up the type in the mapping table.

Produce: `type`, `scope`, `breaking`, `emoji`.

**Step 4 — Draft the commit message**
Format per the spec template in `refs/conventional-commits.md`. Use `refs/exemplars.md` to match shape:

```
<emoji> <type>(<scope>)[!]: <subject>

<body — 1 to 3 lines, why and what, wrapped at 72>

[BREAKING CHANGE: <what broke and what callers must update>]
```

Subject: imperative mood, ≤72 characters, no period. Body wrapped at 72. Footer only when `breaking = true`.

Produce: `commit_message`.

**Step 5 — Emit the message**
Print `commit_message` exactly as drafted. No preamble, no metadata, no "I inferred…". Produce: rendered output to user.

**Step 6 — Ask to commit**
Emit one line: `Run git commit for you? (yes / no)`.

**Step 7 — Run or terminate**
On `yes`: run `git commit -m "<commit_message>"` via Bash. Report the resulting commit SHA. On `no` or no answer: terminate. The message is already on screen for the user to copy. Produce: commit SHA or termination.

## References

- `refs/conventional-commits.md` — full Conventional Commits v1.0.0 spec, type table with gitmoji, and message template
- `refs/exemplars.md` — 6 worked examples: feat, fix, refactor, breaking change, squash, chore
