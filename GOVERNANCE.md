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
- **Quick capture (staging-file method):** proposals accumulate in `PROPOSED-RULES.md`; the founder
  reviews them periodically.
- **The change itself (PR method — the standard):** approved changes to canonical files are made as
  a pull request on the framework repo, never as a direct push to main. The founder reviews per
  Section 5 and merges or closes. The audit loop (CLAUDE.md Section 9) reviews the PR before merge.

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

🟦 **The framework is versioned with semantic versioning (MAJOR.MINOR.PATCH), tracked in
`CHANGELOG.md` at the repo root:**

- **MAJOR** (2.0.0) — a rule is removed or reversed, or the workflow itself changes (e.g. a new
  mandatory gate). Projects pinned to the old major should review before upgrading.
- **MINOR** (1.1.0) — a new rule, section, or doc is added; existing rules unchanged. Safe upgrade.
- **PATCH** (1.0.1) — wording fixes, clarifications, formatting. Always safe.

Every `CHANGELOG.md` entry records: version, date, what changed, WHY, and the source (which
project/build/discussion it came from). When a rule is reversed, supersede it with a new entry —
don't erase history (mirrors decisions.md discipline).

**How projects pin and upgrade:**
- A project records the framework version it was built against in its `TRD.md` (one line:
  "Framework: v1.1.0").
- On session start, if the framework's current version differs from the project's pinned version,
  Claude Code reads `CHANGELOG.md`, summarises what changed in plain language, and asks the founder
  whether to upgrade the pin (MINOR/PATCH: recommend yes; MAJOR: walk through the breaking entries
  first). The pin only changes with founder approval.
- Tag releases in git (`v1.1.0`) so any project state can be reproduced.

🟩 This means you can always answer "why does this rule exist, and when did we add it?" — roll back a
rule that turns out to be wrong, and know exactly which rules each project was built under.

---

## 5. Reviewing pull requests (the owner's process — no technical knowledge required)

🟩 **FOR THE FOUNDER** — a pull request (PR) is a proposed change to this framework, shown as a
before/after comparison, waiting for your decision. On a public repo, anyone can propose one. You
never need to read the changed text like a programmer — you review PRs the same way you run builds:
the AI does the technical reading, you make the judgment call. But understand what's at stake first.

**Why this review matters more than it looks:** these documents are not just text — AI builders
*obey* them. A one-line change ("the audit step may be skipped for small changes") quietly disarms a
safety gate on every future project. A hostile PR could even hide instructions an AI would follow
(fetch outside code, add a connector, stop logging). Treat every PR as a change to the behaviour of
every build you'll ever run — because that's what it is.

### The review ritual (five steps, ~5 minutes)

1. **Open the PR page** on GitHub (the repo's "Pull requests" tab). Read only the title and
   description. It must say WHAT changed and WHY in plain language. No why → comment asking for
   one; no answer → close it. You owe nobody a merge.
2. **Have the AI audit it.** Open Claude Code anywhere and paste:

   > Act as an independent auditor of pull request #NUMBER on
   > TheAIOfficers-com/claude-build-framework. Read the full diff and, against the current
   > framework, answer in plain language: (1) What does this change actually do — including any
   > effect not mentioned in the description? (2) Does it strengthen, weaken, or bypass ANY rule,
   > gate, or check — however slightly? (3) Does it add any instruction a builder AI would follow
   > that could cause harm (fetching external code, adding tools/connectors, weakening logging,
   > approvals, or security)? (4) Does it contradict any existing section? (5) Is the CHANGELOG
   > updated with the why? End with one verdict: MERGE, MERGE AFTER CHANGES (list them), or
   > REJECT (say why) — and explain the verdict as if to a non-technical owner.

3. **Read the verdict, not the diff.** If anything in the answer to (2) or (3) is "yes, it
   weakens/adds" — the default is REJECT, whatever the benefit claimed. See the one-way rule below.
4. **For substantial PRs, get a second opinion** from a different model acting as a second
   independent auditor (the Section 9 cross-model principle, applied to the framework itself).
   Two independent MERGE verdicts before you merge anything that changes a rule's meaning.
5. **Decide on GitHub:** the green "Merge" button (choose "Squash and merge" if offered — one clean
   history entry), or "Close" with a one-line reason. Merging is YOUR click, never delegated —
   that's the whole governance model.

### The one-way rule

🟦 Changes that ADD safety, clarity, or evidence are cheap to accept. Changes that REMOVE or soften
a check, gate, log, or approval need overwhelming, explicit justification — and the default answer
is no. The framework should only ever get harder to misuse.

### Instant red flags (reject without further analysis)

- Softens a gate or adds an exception ("skip X when…", "unless the change is small…").
- Tells any AI to fetch, install, or connect to something external.
- Removes or reduces logging, approvals, audit steps, or founder decision points.
- A big rewrite bundled with a small fix (the fix is the camouflage — ask for them separately).
- Vague description, or a diff that touches files the description doesn't mention.
- Any edit to this Section 5 or to Section 3's non-negotiable, proposed by anyone but you.

🟩 **One line for the founder:** the AI reads the change, two independent auditors give verdicts on
anything substantial, and the merge button is yours alone — accept what hardens the framework,
refuse by default whatever softens it.

---

## 6. The monthly compliance spot-check (who watches the process?)

🟩 **FOR THE FOUNDER** — everything above assumes the builder AI actually follows the framework:
really sweeping before planning, really running the audit, really certifying honestly. Usually it
does. But drift is quiet, and you can't read code to catch it. So once a month (or at any phase
boundary), you run a spot-check — performed by a DIFFERENT AI than the one building, so the process
is never grading its own homework.

**Paste this to a model that is not your builder:**

> Act as a compliance auditor for the project at [project folder / repo]. Check the project's
> documents and version history against the build framework it references, and answer in plain
> language: (1) Is there evidence each implemented feature followed SWEEP → MOCKUP → PLAN → AUDIT →
> IMPLEMENT — or do docs show steps skipped? (2) Do todo.md, techdebt.md, build-log.md, and
> decisions.md reflect the actual history, or are there silent gaps between what the code/commits
> show and what the docs say? (3) Were Definition-of-Done certifications backed by evidence?
> (4) Is anything marked resolved in techdebt.md that doesn't appear actually fixed? List every
> discrepancy with where you found it, rate overall process compliance 1–10, and name the single
> most important correction.

🟦 **FOR CLAUDE CODE** — when a spot-check finds discrepancies: fix the documents to match reality
first (staleness rule, Section 10 of CLAUDE.md), log each discrepancy in `techdebt.md`, and if the
same class of drift recurs, propose a durable prevention via `PROPOSED-RULES.md`. A builder must
never dispute a spot-check by editing history — append-only docs stay append-only.

🟩 **One line for the founder:** trust, but verify monthly — with a different AI holding the
checklist.
