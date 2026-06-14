# GOVERNANCE.md — Where the framework lives & how rules change

This document defines (a) where these rule files are located, (b) how Claude Code uses them every
session, and (c) how new rules get in — from Claude Code during work, and from the founder via
discussions and outside sources.

---

## 1. Where the files live (location & structure)

🟩 **FOR THE FOUNDER** — there is ONE canonical copy of this framework, shared across every project
you build. It is not copied into each project; projects *reference* it. Only the per-project memory
(the `project-docs/` files) lives inside each project.

**Canonical home: a dedicated Git repository on GitHub** (e.g. `claude-build-framework`). Git gives
you versioning (every rule change is tracked, attributable, revertible) and a natural review point
(commits / pull requests). This matches the STACK.md default (GitHub for version control).

```
claude-build-framework/            ← the ONE canonical repo (GitHub)
├── CLAUDE.md                       ← master rules (loaded every session)
├── GOVERNANCE.md                   ← this file
├── PROPOSED-RULES.md               ← staging queue for proposed changes
├── STACK.md
├── layers/                         ← the 13 layer docs
├── cross-cutting/                  ← CROSS-01, CROSS-02
├── reference-architectures/        ← REF-01, REF-02
└── project-docs-template/          ← copied into each new project as project-docs/
```

**How a project connects to it** (pick one, simplest first):
1. **Claude Code global memory (simplest).** Place the framework so Claude Code loads it globally —
   e.g. point your global `~/.claude/CLAUDE.md` to (or import) this framework's CLAUDE.md, so every
   session in every project reads it automatically. Per-project `./CLAUDE.md` stays for project-only notes.
2. **Git submodule.** Add the framework repo as a submodule inside each project (e.g. `/framework`).
   The project pins a version and updates deliberately. Best when you want each project locked to a
   known framework version.
3. **Symlink / synced folder.** Symlink the canonical folder into each project. Simple, but less
   explicit about versioning than git.

🟩 Recommendation: start with **option 1** (global memory) for speed; move to **option 2** (submodule)
once you have several live projects and want each pinned to a specific framework version.

---

## 2. How Claude Code uses the files every session

Per CLAUDE.md Section 1, at session start Claude Code reads the canonical framework (master + ACTIVE
layers + cross-cutting + relevant reference architectures) and the project's live memory docs. This
already happens — this section just confirms the canonical files are the ones in the repo above.

---

## 3. How rules change (the intake system)

There are TWO sources of new rules. Both flow through review; neither edits canonical files blindly.

### Source A — Claude Code proposes (during a build)
🟦 When Claude Code learns something during work that should be a durable rule, it appends a proposal
to `PROPOSED-RULES.md`. It does **NOT** edit the canonical files. The founder reviews and promotes.
- **Now (staging-file method):** proposals accumulate in `PROPOSED-RULES.md`; founder approves/moves them.
- **Later (PR method, once on GitHub):** Claude Code opens a pull request with the proposed change;
  the founder reviews the diff and merges or closes. Same principle, more formal. The audit loop
  (CLAUDE.md Section 9) can review the PR before merge.

### Source B — Founder adds (from discussions or outside sources)
🟩 You add rules directly — from these discussions, transcripts, or knowledge from anywhere. This is
authoritative (it's your judgment). In practice: state the rule, and it's written into the right
canonical file and committed. (That's exactly how this framework has been built so far.)

### The non-negotiable
🟦 **Canonical files (CLAUDE.md, layers, cross-cutting, reference architectures) are changed only by
founder-approved edits — never silently by a working session.** A working session may PROPOSE
(Source A); only an approved change becomes a rule. This is the same propose→review→approve discipline
as the audit loop, applied to the framework itself.

---

## 4. Versioning & changelog

🟦 Keep a top-level `CHANGELOG.md` (or rely on git history) recording what changed, when, and why.
Every promoted rule notes its source (which project/build or which discussion). When a rule is
reversed, supersede it with a new entry — don't erase history (mirrors decisions.md discipline).

🟩 This means you can always answer "why does this rule exist, and when did we add it?" — and roll
back a rule that turns out to be wrong.
