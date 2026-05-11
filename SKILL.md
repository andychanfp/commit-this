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
Emit `checking env...`. Run `git rev-parse --is-inside-work-tree` to confirm a git repo. Run `git diff --staged --name-only` to detect staged files. If empty, run `git log -1 --format="%H"` to confirm a commit exists. Run `git status -sb` and inspect for `[ahead N]` — if the branch has an upstream and is not ahead, the last commit is published. Refuse and terminate on any failure with a one-line reason. Produce: `validation_pass = true` plus `input_source ∈ {staged, last_commit}`.

**Step 2 — Read the diff**
Emit `reading diff...`. If `input_source = staged`, run `git diff --staged`. If `input_source = last_commit`, run `git show HEAD`. Capture the full diff text and the list of changed files. Produce: `diff_text`, `changed_files[]`.

**Step 3 — Generate the commit message**
Emit `generating message...`. Apply rules from `refs/conventional-commits.md` internally — do not show type, scope, breaking flag, or gitmoji selection to the user:
- **Type**: classify against the type table (feat, fix, refactor, docs, test, chore, perf, ci, style, build, revert).
- **Scope**: take the most specific common path segment across `changed_files[]`. Multi-domain → top-level domain.
- **Breaking flag**: scan for renamed/removed public symbols, parameter signature changes, return type changes. If found → set `breaking = true`.
- **Gitmoji**: look up the type in the mapping table.

Format per the spec template in `refs/conventional-commits.md`. Use `refs/exemplars.md` to match shape:

```
<emoji> <type>(<scope>)[!]: <subject>

<body — 1 to 3 lines, why and what, wrapped at 72>

[BREAKING CHANGE: <what broke and what callers must update>]
```

Subject: imperative mood, ≤72 characters, no period. Body wrapped at 72. Footer only when `breaking = true`.

**Body rule**: omit the body unless `breaking = true` OR `changed_files[]` has more than 3 distinct top-level diff hunks. When omitted, the message is subject line only.

Produce: `commit_message`.

**Step 4 — Emit the command and ask**
Output exactly one line in this format, then ask the user if they want to commit:

```
git commit -m "<commit_message>"
```

No preamble, no metadata, no explanation — just the `git commit -m "..."` line. Then emit: `Commit? (yes / no)`

**Step 5 — Run or terminate**
On `yes`: run the command via Bash. Report the resulting commit SHA. On `no` or no answer: terminate silently.

## References

- `refs/conventional-commits.md` — full Conventional Commits v1.0.0 spec, type table with gitmoji, and message template
- `refs/exemplars.md` — 6 worked examples: feat, fix, refactor, breaking change, squash, chore
