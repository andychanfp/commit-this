<div align="center">
<img src="./asset/header.jpg"/>


# 👍🏻 commit-this

I hate thinking about commit messages.

This skill reads your staged changes or last unpublished commit, generates a [Conventional Commits](https://www.conventionalcommits.org/) message with a gitmoji prefix.

It'll offer to run `git commit` for you too.

</div>

## ⚒️ Usage

Just run `/commit-this`. No args.

## 🚀 Installation

**Recommended — one-line install:**

```bash
curl -fsSL https://raw.githubusercontent.com/andychanfp/commit-this/main/install.sh | bash
```

**Or clone manually:**

```bash
git clone https://github.com/andychanfp/commit-this.git ~/.claude/skills/commit-this
```

## How it works

1. **Validate** — confirms you're in a git repo and detects whether to read staged changes or the last unpublished commit.
2. **Read** — runs `git diff --staged` (or `git show HEAD` as fallback) to capture the full diff.
3. **Generate** — classifies the change type, infers scope from changed file paths, checks for breaking changes, and picks the matching gitmoji.
4. **Emit** — outputs a single `git commit -m "..."` line and asks `Commit? (yes / no)`.
5. **Commit** — on `yes`, runs the command and reports the resulting SHA. On `no`, exits silently.

### Output

```
git commit -m "✨ feat(auth): add OAuth2 login flow"

Commit? (yes / no)
```

For larger or breaking changes, a body and `BREAKING CHANGE:` footer are included automatically.

## FAQ

1. **Why not write commit messages yourself?** I do, but not for big code changes.
2. **But it takes like, 5 seconds.** Nyet.
3. **What if I want just the message?** Just say "no" to the skill and you can copy and paste the git command yourself. Remember to `git push`!
4. **Does it push to my repo?** No. That's not very safe. I prefer running `git push` manually.
5. **Should I use it on every commit?** Probably not. I would use it for larger code changes or detecting any breaking changes. For small changes, I still try to write it myself. 