---
name: Exemplars
description: Six worked commit messages covering feat, fix, refactor, breaking change, squash, and chore — match the shape, not the words
type: reference
---

# Exemplars

Six end-to-end examples. Each shows the input shape (changed files + change kind) and the exact output the skill should produce. Match the shape, not the words.

## 1. feat — new capability, single scope

**Diff shape**: new function `refreshToken()` added to `src/api/auth.ts`; export added to `src/api/index.ts`.

**Output**:

```
✨ feat(auth): add refresh token function

Introduce refreshToken() to renew access tokens without
prompting the user to re-authenticate. Export from the api
barrel for client use.

Run git commit for you? (yes / no)
```

Why: type `feat` (new capability), scope `auth` (most specific common path), no breaking change, body explains *why*.

## 2. fix — bug correction

**Diff shape**: `src/parser/json.ts` — guard added against empty string input that previously threw.

**Output**:

```
🐛 fix(parser): handle empty input without throwing

Return null instead of raising when the parser receives
an empty string. Empty input is now treated as a no-op.

Run git commit for you? (yes / no)
```

Why: type `fix`, scope `parser`, body names the previous behaviour and the new one.

## 3. refactor — restructure with no behaviour change

**Diff shape**: `src/api/response.ts` extracted from `src/api/handler.ts`; tests unchanged.

**Output**:

```
♻️ refactor(api): extract response builder

Move response shaping logic from handler.ts into a
dedicated response.ts module. No behaviour change;
tests pass without modification.

Run git commit for you? (yes / no)
```

Why: type `refactor` (no behaviour change), scope `api`, body confirms behavioural neutrality.

## 4. breaking change — public API rename across files

**Diff shape**: parameter `user_id` renamed to `userId` across `src/api/users.ts`, `src/models/user.ts`, `tests/api/users.test.ts`.

**Output**:

```
♻️ refactor(api)!: rename user_id parameter to userId

Rename user_id to userId across API handler, user model,
and test suite to align with project camelCase convention.

BREAKING CHANGE: user_id parameter renamed to userId —
all API consumers must update their request payloads.

Run git commit for you? (yes / no)
```

Why: type `refactor` (rename), scope `api` (dominant top-level path), `!` flags breaking, `BREAKING CHANGE` footer names the migration step.

## 5. squash — collapse a commit range into one message

**Diff shape**: 3 unpublished commits on the branch, all touching `src/checkout/`. Messages: "wip cart", "fix tax calc", "add unit tests".

**Output**:

```
✨ feat(checkout): add cart with tax calculation

Implement the checkout cart with line items, subtotal,
and tax calculation. Add unit tests covering the tax
edge cases (zero, mixed-rate jurisdictions).

Run git commit for you? (yes / no)
```

Why: when multiple unpublished commits are read together, generate one cohesive message describing the *outcome*, not the work-in-progress sequence. Type and scope reflect the dominant change; body summarises the combined result.

## 6. chore — dependency bump

**Diff shape**: `package.json` and `package-lock.json` — axios upgraded from 1.6.8 to 1.7.0; no source code changes.

**Output**:

```
🔧 chore(deps): bump axios to 1.7.0

Upgrade axios from 1.6.8 to 1.7.0 to pick up the
fix for CVE-2024-39338 (SSRF via protocol-relative URLs).

Run git commit for you? (yes / no)
```

Why: type `chore`, scope `deps`, body names the *reason* for the bump (security fix) — not just the version delta visible in the diff.

## Reading the exemplars

- The subject line is **always** `<emoji> <type>(<scope>)[!]: <imperative description>`.
- The body is **1–3 lines**, wrapped at 72 characters, and explains *why* the change exists.
- The `BREAKING CHANGE:` footer appears **only** when `!` is present, and names the migration the consumer must perform.
- The gate question is **always** the literal string `Run git commit for you? (yes / no)` on its own line, separated from the message by one blank line.
