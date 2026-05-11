#!/usr/bin/env bash
set -euo pipefail

REPO="https://github.com/andychanfp/commit-this.git"
SKILL_NAME="commit-this"
SKILLS_DIR="${HOME}/.claude/skills"
DEST="${SKILLS_DIR}/${SKILL_NAME}"

# ── helpers ──────────────────────────────────────────────────────────────────
info()  { printf '\033[0;34m[info]\033[0m  %s\n' "$*"; }
ok()    { printf '\033[0;32m[ok]\033[0m    %s\n' "$*"; }
die()   { printf '\033[0;31m[error]\033[0m %s\n' "$*" >&2; exit 1; }

# ── preflight ────────────────────────────────────────────────────────────────
command -v git >/dev/null 2>&1 || die "git is required but not found"
command -v claude >/dev/null 2>&1 || die "Claude Code CLI (claude) is required but not found"

# ── install / update ─────────────────────────────────────────────────────────
mkdir -p "${SKILLS_DIR}"

if [[ -d "${DEST}/.git" ]]; then
  info "Skill already installed — pulling latest..."
  git -C "${DEST}" pull --ff-only
else
  info "Cloning ${REPO}..."
  git clone "${REPO}" "${DEST}"
fi

ok "Skill files ready at ${DEST}"

# ── register the slash command ────────────────────────────────────────────────
# Claude Code picks up skills automatically from ~/.claude/skills/<name>/SKILL.md
# No further registration step is needed; verify it appears in /help.
ok "/${SKILL_NAME} is now available in Claude Code — try it with /commit-this"
