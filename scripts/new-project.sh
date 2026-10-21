#!/usr/bin/env bash
# new-project.sh — create a new project wired to the TheAIOfficers build framework.
# Usage:  bash <framework>/scripts/new-project.sh my-project [/path/to/projects] [build-model] [advisor-model]
# Creates <path>/<name> with project-docs/, a framework-wired CLAUDE.md, an audit-lessons file,
# a version pin, and git history. build-model/advisor-model (optional, founder's choice — CLAUDE.md
# Section 16 rule 7) write .claude/settings.json; omit them to keep the default model routing.

set -euo pipefail

NAME="${1:-}"
DEST="${2:-$(pwd)}"
BUILD_MODEL="${3:-}"
ADVISOR_MODEL="${4:-}"

if [ -z "$NAME" ]; then
  echo "ERROR: usage: new-project.sh <project-name> [destination-folder] [build-model] [advisor-model]" >&2
  echo "       (advisor only: new-project.sh <name> <folder> \"\" <advisor-model>)" >&2
  exit 1
fi

# --- validate optional model names before anything is created ---
for m in "$BUILD_MODEL" "$ADVISOR_MODEL"; do
  if [ -n "$m" ] && ! printf '%s' "$m" | grep -Eq '^[A-Za-z0-9._-]+$'; then
    echo "ERROR: model name '$m' may only contain letters, digits, '.', '_' or '-'." >&2
    exit 1
  fi
done

# --- locate the framework (this script lives in <framework>/scripts/) ---
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FRAMEWORK_ROOT="$(dirname "$SCRIPT_DIR")"
if [ ! -f "$FRAMEWORK_ROOT/CLAUDE.md" ]; then
  echo "ERROR: framework CLAUDE.md not found at $FRAMEWORK_ROOT — is this script inside the framework's scripts/ folder?" >&2
  exit 1
fi

# --- read the framework version from CHANGELOG.md ---
VERSION="unknown"
if [ -f "$FRAMEWORK_ROOT/CHANGELOG.md" ]; then
  VERSION="$(grep -oE '^## (v[0-9]+\.[0-9]+\.[0-9]+)' "$FRAMEWORK_ROOT/CHANGELOG.md" | head -n1 | sed 's/^## //')"
  [ -z "$VERSION" ] && VERSION="unknown"
fi

# --- create the project folder ---
PROJECT_DIR="$DEST/$NAME"
if [ -e "$PROJECT_DIR" ]; then
  echo "ERROR: $PROJECT_DIR already exists. Choose a different name or delete the folder first." >&2
  exit 1
fi
mkdir -p "$PROJECT_DIR"

# --- copy the planning documents template ---
cp -R "$FRAMEWORK_ROOT/project-docs-template" "$PROJECT_DIR/project-docs"

# --- record the framework version pin in TRD.md ---
if [ -f "$PROJECT_DIR/project-docs/TRD.md" ]; then
  {
    echo ""
    echo "<!-- Framework pin (GOVERNANCE.md Section 4) -->"
    echo "Framework: $VERSION (pinned $(date +%Y-%m-%d))"
  } >> "$PROJECT_DIR/project-docs/TRD.md"
fi

# --- write the project-level CLAUDE.md ---
LESSONS_FILE="${NAME}_Audit_Lessons.md"
cat > "$PROJECT_DIR/CLAUDE.md" <<EOF
# CLAUDE.md — $NAME (project rules)

## The framework governs this project

- Follow the TheAIOfficers build framework at:
  \`$FRAMEWORK_ROOT\`
- Read that framework's \`CLAUDE.md\` at the start of EVERY session, then follow its session-start
  protocol (targeted layer reading, project memory docs, SWEEP → MOCKUP → PLAN → AUDIT → IMPLEMENT).
- This project is pinned to framework **$VERSION** (recorded in \`project-docs/TRD.md\`). If the
  framework's current version differs, follow GOVERNANCE.md Section 4 before adopting new rules.
- Planning/memory documents live in \`project-docs/\` — the pre-coding gate applies: no application
  code until the six gate docs are complete and mockups are approved.
- Never edit the canonical framework files; propose changes via the framework's \`PROPOSED-RULES.md\`.
- Before building, read the framework's \`GLOBAL-AUDIT-LESSONS.md\` and this project's
  \`$LESSONS_FILE\`; the auditor checks every lesson and appends new repeatable mistakes.

## Operating rules (apply regardless of model)

1. **Verify, don't assume.** Never claim a file, function, or behaviour exists without reading it
   this session. Label claims as fact (read/ran it), inference, or assumption.
2. **Root cause first.** Reproduce and diagnose before fixing. Never patch a symptom.
3. **Prove it works.** Run or test every change and show the output. "Should work" is not done.
4. **Report honestly.** Lead with the outcome. Failed tests, skipped steps, and unmet criteria are
   stated plainly — never a success report without verification.
5. **No sycophancy.** No praise openers. Push back on flawed ideas with the specific failure case
   and a stronger alternative.
6. **Smallest change that solves it.** Don't refactor, rename, or "improve" untouched code. New
   ideas found mid-task go to \`project-docs/productdebt.md\` — never silent scope growth.
7. **Finish the turn.** No response ends with an unfulfilled promise. Do it now, or name the exact
   input that blocks it.
8. **Ask only when it matters.** Reversible in-scope work proceeds without asking. Destructive,
   outward-facing (deploy/publish/send), or scope-changing actions stop for approval.
9. **Update the docs with the code.** todo.md / techdebt.md / build-log at session end. Code and
   gate docs must never silently diverge.
10. **Explain for the owner.** Plain-language "what this means for you" alongside every technical
    decision — the owner verifies through docs and the admin panel, not code.

## Project-specific notes

(Add project-only rules and context below this line. Standards live in the framework, not here.)
EOF

# --- write the project audit-lessons file (GLOBAL-AUDIT-LESSONS.md explains the system) ---
cat > "$PROJECT_DIR/$LESSONS_FILE" <<EOF
# $NAME — Audit Lessons (read before every build; the auditor checks each line)
Append-only. One line per lesson. Never delete; mark RETIRED. Keep it short (~60 live lines).
Hit = one separate audit round where the mistake was found. Tag project-agnostic lessons [GLOBAL?]
and propose them in the framework's PROPOSED-RULES.md.

| # | Lesson | Check | Sev | Hits | Source |
|---|--------|-------|-----|------|--------|
EOF

# --- optional model routing (founder's cost override, CLAUDE.md Section 16 rule 7) ---
SETTINGS_WRITTEN="no"
if [ -n "$BUILD_MODEL" ] || [ -n "$ADVISOR_MODEL" ]; then
  mkdir -p "$PROJECT_DIR/.claude"
  {
    echo "{"
    if [ -n "$BUILD_MODEL" ] && [ -n "$ADVISOR_MODEL" ]; then
      printf '  "model": "%s",\n  "advisorModel": "%s"\n' "$BUILD_MODEL" "$ADVISOR_MODEL"
    elif [ -n "$BUILD_MODEL" ]; then
      printf '  "model": "%s"\n' "$BUILD_MODEL"
    else
      printf '  "advisorModel": "%s"\n' "$ADVISOR_MODEL"
    fi
    echo "}"
  } > "$PROJECT_DIR/.claude/settings.json"
  printf '\n## Model routing (founder'"'"'s cost override — framework CLAUDE.md Section 16 rule 7)\n\n- Build: %s · Advisor: %s (set in `.claude/settings.json`). Planning and audits stay with the best model.\n' \
    "${BUILD_MODEL:-default}" "${ADVISOR_MODEL:-none}" >> "$PROJECT_DIR/CLAUDE.md"
  SETTINGS_WRITTEN="yes"
fi

# --- start git history ---
GIT_DONE="no"
if command -v git >/dev/null 2>&1; then
  (
    cd "$PROJECT_DIR"
    git init --quiet
    printf '.env\n.env.*\nnode_modules/\ndist/\n__pycache__/\n*.log\n' > .gitignore
    git add -A
    git commit --quiet -m "chore: bootstrap project from claude-build-framework $VERSION"
  )
  GIT_DONE="yes"
else
  echo "NOTE: git not found — skipped version history. Install git and run 'git init' in the project later."
fi

# --- report ---
echo ""
echo "DONE — project created."
echo "  Folder:            $PROJECT_DIR"
echo "  Framework version: $VERSION (pinned in project-docs/TRD.md)"
echo "  Planning docs:     $PROJECT_DIR/project-docs/"
echo "  Audit lessons:     $PROJECT_DIR/$LESSONS_FILE"
[ "$SETTINGS_WRITTEN" = "yes" ] && echo "  Model routing:     .claude/settings.json (build: ${BUILD_MODEL:-default}, advisor: ${ADVISOR_MODEL:-none})"
[ "$GIT_DONE" = "yes" ] && echo "  Git:               initialised with first commit"
echo ""
echo "NEXT STEP: open Claude Code inside this folder and paste the kickoff prompt from START-HERE.md (Step 2)."
