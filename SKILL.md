---
name: commit-this
description: Read the staged git diff or the last unpublished commit, generate a Conventional Commits message with a gitmoji prefix, emit it, then ask once whether to run git commit on behalf of the user. Invoke with /commit-this.
model: claude-haiku-4-5-20251001
allowed-tools:
  - Bash
---

## Protocol

**Step 1 — Validate**
Run `git rev-parse --is-inside-work-tree`. Run `git diff --staged --name-only` — if files exist, use staged; otherwise fall back to last commit. Check `git status -sb` for `[ahead N]`; if the branch has an upstream and is not ahead, the last commit is already published — refuse. Abort on any failure with a one-line reason.

**Step 2 — Read**
Staged: `git diff --staged`. Last commit: `git show HEAD`. Collect diff text and changed file list.

**Step 3 — Generate**
Consult `refs/protocol.md` for the type/emoji table and breaking-change rule. Scope: most specific common path segment across changed files; multi-domain → top-level. Omit body unless `breaking = true` OR more than 3 distinct diff hunks.

**Step 4 — Emit and ask**
Output exactly:
```
git commit -m "<commit_message>"
```
Then on a new line: `Commit? (yes / no)`

**Step 5 — Act**
`yes` → run via Bash, report the SHA. Anything else → terminate silently.

## References

- `refs/protocol.md` — type/emoji table, breaking-change rule, and two exemplars
