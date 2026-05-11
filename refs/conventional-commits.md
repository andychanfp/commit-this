---
name: Conventional Commits
description: Full Conventional Commits v1.0.0 spec, type table, and message template the skill uses to format every commit
type: reference
---

# Conventional Commits v1.0.0

The Conventional Commits spec defines a lightweight convention on top of commit messages. Source: https://www.conventionalcommits.org/en/v1.0.0/

## Message structure

```
<type>[optional scope][!]: <description>

[optional body]

[optional footer(s)]
```

Rules:

1. **Type** — required. One of the values in the type table below. Lowercase.
2. **Scope** — optional. A noun in parentheses describing the section of the codebase: `feat(parser)`, `fix(api)`. Lowercase.
3. **`!`** — optional. Append directly after type/scope to flag a breaking change: `feat(api)!:`. Equivalent to a `BREAKING CHANGE:` footer; both may be used together.
4. **Description** — required. Short summary in imperative mood, present tense ("add", not "added" or "adds"). No trailing period. Soft cap 72 characters.
5. **Body** — optional. Free-form prose, wrapped at 72 characters. Separated from description by one blank line. Explains *what* and *why*, not *how*.
6. **Footers** — optional. Each footer is `Token: value` or `Token #value`. Tokens use kebab-case (`Reviewed-by`, `Refs`). Exception: `BREAKING CHANGE` is the literal token (uppercase, with space). Footers separated from body by one blank line.

## Type table

| Type | Emoji | Use for | Example |
|------|-------|---------|---------|
| `feat` | ✨ | A new user-facing feature or capability | `✨ feat(auth): add OAuth2 login flow` |
| `fix` | 🐛 | A bug correction visible to the user | `🐛 fix(parser): handle empty input` |
| `refactor` | ♻️ | Code change that neither fixes a bug nor adds a feature | `♻️ refactor(api): extract response builder` |
| `docs` | 📝 | Documentation-only changes | `📝 docs(readme): update install steps` |
| `test` | ✅ | Adding, updating, or fixing tests | `✅ test(auth): cover token expiry path` |
| `chore` | 🔧 | Tooling, config, dependency bumps with no code logic change | `🔧 chore(deps): bump axios to 1.7.0` |
| `perf` | ⚡️ | Performance improvement | `⚡️ perf(query): cache user lookups` |
| `ci` | 👷 | CI/CD config changes | `👷 ci(github): add lint workflow` |
| `style` | 🎨 | Formatting, whitespace, missing semicolons — no logic change | `🎨 style: apply prettier to components` |
| `build` | 📦 | Build system or external dependency changes | `📦 build(webpack): split vendor bundle` |
| `revert` | ⏪ | Reverts a previous commit | `⏪ revert: feat(auth): add OAuth2 login flow` |

## Breaking change rules

A breaking change is any modification that requires callers or users to change their behaviour. Trigger conditions:

- A public function, method, route, CLI flag, or config key is **renamed** or **removed**.
- A parameter or return type **changes shape** (added required field, type change, removed field).
- An environment variable is renamed or its meaning changes.
- A default value changes in a way that alters output.

When breaking, both signals SHOULD appear:

```
feat(api)!: rename listUsers to listAccounts

BREAKING CHANGE: listUsers has been renamed to listAccounts.
Update all import sites and API consumers.
```

The `!` makes the breaking nature visible in `git log --oneline`. The `BREAKING CHANGE:` footer gives migration detail.

## Subject line rules

- **Imperative mood**: write the subject as if completing the sentence "If applied, this commit will…". Use `add`, `fix`, `rename` — not `added`, `fixes`, `renaming`.
- **No period**: do not end the subject with `.`.
- **Length**: aim for ≤50 characters; hard cap at 72.
- **Lowercase first word** after the colon (unless it is a proper noun): `feat(auth): add token` not `feat(auth): Add token`.

## Worked example

Input diff: a new `refreshToken()` function added to `src/api/auth.ts`, exported from `src/api/index.ts`.

Output:

```
✨ feat(auth): add refresh token function

Introduce refreshToken() to renew access tokens without
prompting the user to re-authenticate. Export from the
api barrel to make it consumable by client code.
```

Type `feat` (new capability), scope `auth` (most specific common path segment), no breaking change (purely additive), body explains *why* in two short lines.
