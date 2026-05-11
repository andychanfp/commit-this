---
name: protocol
description: Type/emoji lookup, breaking-change rule, and two exemplars for commit-this
type: reference
---

# commit-this protocol

## Type → emoji

| Type | Emoji | When |
|------|-------|------|
| `feat` | ✨ | new user-facing capability |
| `fix` | 🐛 | bug correction |
| `refactor` | ♻️ | restructure, no behaviour change |
| `docs` | 📝 | documentation only |
| `test` | ✅ | tests only |
| `chore` | 🔧 | tooling, config, deps |
| `perf` | ⚡️ | performance improvement |
| `ci` | 👷 | CI/CD config |
| `style` | 🎨 | formatting, no logic change |
| `build` | 📦 | build system or dependency |
| `revert` | ⏪ | reverts a previous commit |

## Breaking change

Set `breaking = true` when a public symbol, param, route, env var, or default is **renamed, removed, or changes shape**. Emit `!` on the subject line and a `BREAKING CHANGE:` footer.

## Exemplars

**Subject-only** (≤3 diff hunks, no breaking change):

```
🔧 chore(deps): bump axios to 1.7.0
```

**Full** (breaking change — body + footer required):

```
♻️ refactor(api)!: rename user_id parameter to userId

Rename user_id to userId across the API handler and user model
to align with project camelCase convention.

BREAKING CHANGE: user_id renamed to userId — all consumers
must update their request payloads.
```
