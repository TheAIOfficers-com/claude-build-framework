# CLAUDE.md — Production Build Rules (Master File)

> **Claude Code: read this file at the start of EVERY session before writing any code.**
> This is the controlling document. It links to detailed layer docs in `/layers`.
> If anything here conflicts with a request to "just ship it fast", this file wins.

---

## 0. How this document works (read me first)

This framework exists because most apps built quickly have only **2 layers** (a front end and a
database). A real production product has **13 layers**. The missing 11 are what separate a demo
from something real users can depend on.

This file is written in two voices:
- **🟦 FOR CLAUDE CODE** — direct instructions. Treat these as rules, not suggestions.
- **🟩 FOR THE FOUNDER** — plain-English explanation so a non-technical owner understands *why*
  a rule exists and what it protects against.

**The non-negotiable principle:** the *final aim* of each layer must be achieved. The specific
tools and techniques are flexible (we choose them per build), but the *outcome* each layer
guarantees is not optional. If a shortcut skips a layer's outcome, Claude Code must flag it
instead of silently proceeding.

---

## 1. Session start protocol

🟦 **FOR CLAUDE CODE** — at the start of every session, do this in order:
1. Read this file (`CLAUDE.md`) fully.
2. Read `STACK.md` to see what tech stack has been chosen for this project (may be empty early on).
3. Read each `layers/LAYER-XX-*.md` file that is marked **ACTIVE**.
4. Read each `cross-cutting/CROSS-XX-*.md` file that is marked **ACTIVE** (these apply across layers).
5. If the build uses a capability covered by a `reference-architectures/REF-XX-*.md` doc, read it.
6. **Read the project's 8 planning/memory docs (see Section 8) to reload live project memory** —
   especially `todo.md` (what's built / what's next) and `techdebt.md` (open issues to resolve).
7. Before building a feature, state which layers it touches and confirm each layer's aim is met.
   **Follow the SWEEP → MOCKUP → PLAN → AUDIT → IMPLEMENT workflow (Section 9) — never plan on assumptions,
   never implement a plan that hasn't passed the independent audit loop.**
8. At the end of a work session, **update `todo.md`, `techdebt.md`, and the append-only docs**; if a
   durable rule-worthy lesson emerged, **append it to `PROPOSED-RULES.md` (never edit canonical files
   directly — see GOVERNANCE.md)**; then report any layer whose aim is **not yet met** (the gap list).

🟩 **FOR THE FOUNDER** — this guarantees that every time you open a new session, Claude Code
re-grounds itself in your standards AND your project's current state — instead of starting fresh and
forgetting both. The planning docs are the project's memory; reading them at the start and updating
them at the end is what keeps that memory live across sessions.

---

## 1b. THE PRE-CODING GATE (no code before the docs exist)

🟦 **FOR CLAUDE CODE — this is a hard gate.** For any new web/software project, the eight planning
documents in Section 8 MUST exist and be complete BEFORE writing application code. If any are missing
or incomplete:
- Do NOT start coding.
- State which documents are missing and offer to draft them first.
- The only exception is throwaway prototypes the founder explicitly labels as throwaway.

🟩 **FOR THE FOUNDER** — this enforces the discipline that what you build is decided before it's
built. Schema and requirements changed mid-build are the most expensive kind of change. The gate
forces the thinking to happen first, on paper, where changing your mind is free. The planning docs are
finalised through brainstorming under the honest-collaborator rule (Section 11) — the model must push
back on weak ideas, not rubber-stamp them.

---

## 2. The 13 layers

| # | Layer | Aim (the non-negotiable outcome) | Status |
|---|-------|----------------------------------|--------|
| 1 | Front-end foundations | A usable, accessible, predictable interface | ✅ ACTIVE |
| 2 | APIs & backend logic | Reliable contract between front end and data | ✅ ACTIVE |
| 3 | Database & storage | Correct, durable, well-modelled data | ✅ ACTIVE |
| 4 | Auth & permissions | Only the right people do the right things | ✅ ACTIVE |
| 5 | Hosting & deployment | App runs reliably somewhere users can reach it | ✅ ACTIVE |
| 6 | Cloud & compute | Right amount of computing power, sanely managed | ✅ ACTIVE |
| 7 | CI/CD & version control | Safe, repeatable, reversible releases | ✅ ACTIVE |
| 8 | Security & row-level security | Data is protected at rest, in transit, per-row | ✅ ACTIVE |
| 9 | Rate limiting | No single user/bot can overwhelm or abuse the system | ✅ ACTIVE |
| 10 | Caching & CDN | Fast responses, reduced load, global delivery | ✅ ACTIVE |
| 11 | Load balancing & scaling | Stays up as traffic grows | ✅ ACTIVE |
| 12 | Error tracking & logs | Problems are visible and diagnosable | ✅ ACTIVE |
| 13 | Availability & recovery | Survives failure; can be restored | ✅ ACTIVE |

🟩 **FOR THE FOUNDER** — "STUB" means the file exists but is empty, waiting for the transcript
that covers it. As you feed me more transcripts, we promote stubs to DRAFTED, then ACTIVE.

---

## 3. Status definitions

- **STUB** — placeholder only. Aim is stated; details pending a transcript.
- **DRAFTED** — full rules written, awaiting founder review.
- **ACTIVE** — reviewed and approved; Claude Code MUST enforce it.

🟦 **FOR CLAUDE CODE** — only enforce docs marked **ACTIVE**. For STUB/DRAFTED docs, note them in the
gap list but do not block work.

**Current state (as of this version): ALL 13 layers, both cross-cutting docs (CROSS-01, CROSS-02),
and both reference architectures (REF-01, REF-02) are ACTIVE and enforced.** New material added later
starts as DRAFTED and is promoted to ACTIVE on founder approval.

---

## 4. The gap report (how I point out what's missing)

🟦 **FOR CLAUDE CODE** — at the end of any meaningful work block, output a short **Gap Report**:
- Which layers the current build still does not satisfy.
- Which layer docs are still STUB and need a transcript.
- One recommended next step.

🟩 **FOR THE FOUNDER** — this is your radar. It tells you, in plain terms, what's still missing
and what to find a transcript or make a decision about next.

---

## 5. Files in this framework

- `CLAUDE.md` — this master file.
- `SETUP.md` — how to activate the GitHub repo + Claude Code, and bring in freelancers (start here to stand it up).
- `ONBOARDING.md` — start-here front door for any builder (incl. freelancers).
- `DEFINITION-OF-DONE.md` — the acceptance gate every feature/phase must pass.
- `CONTRIBUTOR-GOVERNANCE.md` — access, IP, confidentiality, handoff rules for non-owner builders.
- `GOVERNANCE.md` — where the framework lives, how it's used each session, and how rules change.
- `PROPOSED-RULES.md` — staging queue where Claude Code proposes rule changes for founder review.
- `STACK.md` — the chosen tech stack per project (filled in as we build).
- `layers/LAYER-01-frontend.md` … `LAYER-13-availability.md` — one doc per layer.
- `cross-cutting/CROSS-XX-*.md` — concerns that span many layers rather than building one part
  (e.g. compliance/SOC 2). These audit or govern the stack as a whole.
- `reference-architectures/REF-XX-*.md` — capability blueprints used only when a build needs that
  capability (e.g. AI voice calling). Pulled in per project, not applied everywhere.
- `claude-integration/` — **ADDITIVE, Claude-Code-only** wiring: maps the framework onto Claude Code's
  native `.claude/` structure (sub-agents, commands, hooks, skills, settings) so the rules execute, not
  just get read. Ignored when the builder is another tool (Codex, etc.).

---

## 6. Cross-cutting concerns (span multiple layers)

| # | Concern | Aim | Status |
|---|---------|-----|--------|
| C1 | Compliance & SOC 2 readiness | Proof the system is secure & well-run exists, collected continuously | ✅ ACTIVE |
| C2 | AI reliability & quality | AI output validated, measurable, gracefully handled; no raw garbage to users | ✅ ACTIVE |
| C3 | Admin & operability | Non-technical operator can see everything + safely control by blast radius; cost visible & controllable | ✅ ACTIVE |

🟩 **FOR THE FOUNDER** — these are not stack layers. They don't build a piece of the app; they prove
or govern the whole. Compliance, for example, pulls evidence from security (8), backups (13),
access (4), and CI (7) all at once.

---
## 7. Reference architectures (capability blueprints — used only when needed)

| # | Capability | Aim | Status |
|---|-----------|-----|--------|
| R1 | Self-hosted AI voice calling (Dograh) | Voice agents, self-hosted, data-residency ours, no per-min lock-in | ✅ ACTIVE — use: outcalling for TheAIOfficers.com clients |
| R2 | AI agent stack ("$0 AI architecture") | Blueprint for agentic builds: orchestration, RAG, local+cloud models, agent observability | ✅ ACTIVE — option |
| R3 | Self-hosted AI help desk | In-app help: consented + redacted capture → self-hosted triage → human-approved bug-fix PR | ✅ ACTIVE |

🟩 **FOR THE FOUNDER** — these are not always-on rules. A reference architecture is a ready-made
blueprint you reach for when a project needs that specific capability. Voice calling, for example,
only matters if the product makes or takes phone calls.

---


## 8. The per-project documents (the planning gate + live memory)

🟩 **FOR THE FOUNDER** — every project gets its own copy of these documents, kept in a
`project-docs/` folder. They're grouped by **how they're maintained** — getting that right is what
stops docs from rotting. Future "how to write each one well" guidance will expand these. The gate docs
are the Section 1b gate.

**A. GATE docs — written up front, complete before coding (Section 1b):**

| # | File | Purpose |
|---|------|---------|
| 1 | `PRD.md` | Product Requirements — problem, users, core features |
| 2 | `TRD.md` | Technical Requirements — stack, APIs, auth, database (mirrors STACK.md) |
| 3 | `appflow.md` | User journey — screens, flow, UX |
| 4 | `design.md` | UI/UX — design language, colors, fonts |
| 5 | `schema.md` | Database tables, data shapes, relationships |
| 6 | `implementation.md` | The build broken into phases |

> Features are SECTIONS within PRD/appflow/schema — not separate per-feature files by default. Add a
> dedicated feature doc only when a feature is genuinely large enough to need one (avoids doc sprawl).

**B. LIVING docs — read at session start, updated at session end (Sections 1 & 10):**

| # | File | Purpose |
|---|------|---------|
| 7 | `todo.md` | Task tracker: phases built, tasks done, tasks next |
| 8 | `techdebt.md` | Unresolved CODE issues + audit-loop conflicts; cleared before each phase completes |
| 9 | `productdebt.md` | PRODUCT ideas/enhancements found mid-build; reviewed at phase boundaries |

**C. APPEND-ONLY docs — only added to, never edited:**

| # | File | Purpose |
|---|------|---------|
| 10 | `prompts.md` | Every meaningful prompt used (the AI build's real source) |
| 11 | `build-log.md` | Chronological record of what was done each session/phase |
| 12 | `decisions.md` | ADR log — why each choice was made (pairs with the audit loop) |
| 13 | `glossary.md` | Project-specific terms and entity names |

**D. GENERATED-ON-DEMAND — regenerated at use, never hand-maintained:**

| # | File | Purpose |
|---|------|---------|
| 14 | `handover.md` | Point-in-time snapshot, regenerated from the live + append-only docs at each handover |

> Note on the source's "rules.md": the source list named a `rules.md` for code-building rules. **That
> role is filled by THIS framework** (CLAUDE.md + the 13 layer docs + cross-cutting + reference
> architectures). A project's `project-docs/` references this framework rather than duplicating it.

🟦 **FOR CLAUDE CODE:**
- **Gate (1–6):** must be complete before coding (Section 1b).
- **Living (7–9):** read at session start (Section 1 step 6), update at session end (Section 1 step 8).
  `techdebt.md` (CODE issues + audit conflicts) MUST be drawn down before a phase is marked complete;
  `productdebt.md` (PRODUCT ideas) is reviewed at phase boundaries to decide what graduates into
  `implementation.md`. Keep them distinct: a bug/shortcut → `techdebt.md`; a "we should also build X"
  idea → `productdebt.md`. Never let a product idea silently expand the current phase.
- **Append-only (10–13):** never edit past entries; only append. Log prompts and build activity every
  session; capture every non-trivial choice (and resolved audit conflict) in `decisions.md`.
- **Generated (14):** never hand-maintain `handover.md`; regenerate it from the other docs when a
  handover actually happens.
- Run the staleness check (Section 10) so none of the above silently drifts from the code.
- The code-building rules these docs defer to ARE this framework — apply the ACTIVE layer rules.

---

## 9. The planning workflow: SWEEP → MOCKUP → PLAN → AUDIT → IMPLEMENT

🟩 **FOR THE FOUNDER** — before the builder AI writes or changes anything, two safeguards run. First,
it must actually *read the existing codebase* so its plan is based on what's really there, not on
guesses about modules that may already exist (or may have changed). Second, a *separate* AI reviews
the plan before any code is written — a second pair of eyes that catches conflicts, wrong assumptions,
and contradictions with the existing system. Anything the auditor flags gets logged so it's not lost.
This is the difference between "the AI confidently built the wrong thing" and "we caught it on paper."

🟦 **FOR CLAUDE CODE — follow this sequence for every plan, spec, or design, with no steps skipped:**

### Step 1 — Codebase sweep (no planning on assumptions)
Before proposing ANY plan, specification, or design, first sweep the existing codebase:
- Inventory the modules, files, data models, and APIs that already exist and are relevant.
- Identify what already does (or partly does) the thing being planned — do not assume a module's
  existence, absence, behaviour, or shape; verify it in the code.
- Note existing patterns/conventions the new work must stay consistent with.
- A plan that references existing modules without having swept them is invalid — redo the sweep.

### Step 2 — Mockups before the plan (standard, unless the builder overrides)
Before writing the plan/spec, produce mockups of what's being built (UI screens for user-facing work;
for admin/operability work, mock the admin views per CROSS-03). Mockups make the design concrete and
surface admin/monitoring/control needs (CROSS-03 Rule B) *before* the plan is committed — it's far
cheaper to react to a picture than to a paragraph.
- This is the **standard default**. The builder (founder) may explicitly override/skip it for a given
  piece of work (e.g. pure backend, no surface). If skipped, note why.
- Mockups also feed the per-feature admin discussion (CROSS-03): what needs monitoring/control becomes
  visible once the feature is drawn.

### Step 3 — Produce the plan / spec / design
Write the plan grounded in the sweep findings AND the mockups, citing the actual modules it builds on
or changes. State assumptions explicitly and mark anything still uncertain. Include the per-feature
admin plan (CROSS-03 Rules A & B).

**Also decide, at this step (builder-agnostic):**
- **Which tools/capabilities this project needs** — e.g. AI skills/abilities, and which external
  integrations (MCP servers / connectors) the build requires (GitHub, databases, Slack, etc.). Decide
  this per project; there is no fixed list. Record the chosen skills/integrations in `TRD.md`.
- If the builder is **Claude Code**, the Claude-specific mapping of these (which `.claude/skills/`,
  which `.mcp.json` servers) lives in `claude-integration/` — see that folder. If the builder is
  another tool (Codex, etc.), apply the equivalent in that tool; the *decision* is the same, the
  *wiring* differs.

### Step 4 — Independent audit loop (a SEPARATE LLM reviews before implementation)
The plan/spec/design must be audited by a **separate LLM instance/agent** acting as reviewer, NOT the
same agent that wrote it. The auditor checks for:
- Conflicts or contradictions with the existing codebase (from the sweep) or with the ACTIVE layer rules.
- Unverified assumptions about existing modules.
- Gaps, missing edge cases, security/scaling/cost implications (cross-check the relevant layers).
- Consistency with the project docs (PRD/TRD/appflow/design/schema/implementation).
**Record every conflict or issue the auditor raises in `techdebt.md`** (with the plan it relates to),
even if it is resolved immediately — this preserves the decision trail.

### Step 5 — Resolve, then implement
Only after audit conflicts are resolved (or consciously accepted and logged) does implementation begin.
Implementation follows the ACTIVE layer rules and updates `todo.md` as work progresses.

🟦 **Hard rule:** no implementation of a plan that has not been (1) grounded in a codebase sweep,
(2) mocked up (unless the builder explicitly overrode this), and (3) passed through the independent
audit loop. If any required step is skipped, stop and complete it first.

### How to run the audit loop in practice (operational note)

🟩 **FOR THE FOUNDER** — the audit is strongest when the reviewer is a *different* AI from the builder.
A model reviewing its own work shares its own blind spots; a different model family does not. The plan
is to use **Codex as the primary auditor** of Claude Code's plans (and other models over time), so the
builder and the reviewer are genuinely independent.

🟦 **FOR CLAUDE CODE / THE OPERATOR — ways to run Step 3, best first:**

1. **Cross-model audit (preferred).** Builder = Claude Code; auditor = a *different* model (e.g.
   **Codex**, or another frontier model). Hand the auditor: (a) the written plan/spec/design, (b) the
   codebase-sweep findings from Step 1, and (c) the relevant ACTIVE layer docs + project docs. Ask it
   to return conflicts, unverified assumptions, gaps, and rule violations as a list. This is the
   default and should be used whenever a second model is available.
2. **Separate-agent audit (same family).** If only one model family is available, run the auditor as a
   distinct sub-agent / fresh session with a clean context and an explicit *reviewer* role — never the
   same conversation that wrote the plan (shared context defeats the purpose).
3. **Fallback (single session).** Only if neither above is possible: the builder re-reviews in a fresh
   pass under an explicit adversarial reviewer prompt. This is the weakest option — note in
   `techdebt.md` that the audit was single-model so it can be re-audited later.

**The auditor's standing brief (give it this role):**
> "You are an independent reviewer, not the author. Review this plan/spec/design against the attached
> codebase-sweep findings, the ACTIVE layer rules, and the project docs. Surface every conflict,
> contradiction, unverified assumption about existing modules, missing edge case, and security/
> scaling/cost concern. Do not rewrite the plan — list issues with severity. Assume the author may be
> overconfident."

**Regardless of method:** record the auditor's findings (model used, date, issues raised, resolution)
in `techdebt.md`, then proceed to Step 4 only once conflicts are resolved or consciously accepted.

🟩 **Note on independence:** as you add more models, rotate or pair auditors — the value comes from the
reviewer not sharing the builder's assumptions. Builder and auditor should never be the same instance.

---

## 10. Keeping docs live: staleness checking (not auto-syncing)

🟩 **FOR THE FOUNDER** — you asked about "DocSync crons" to keep docs live. The honest engineering
answer: a cron (or any automation) must NOT auto-rewrite judgment documents (PRD, design, schema,
decisions) — only a human or an LLM making a decision can keep those *correct*; an auto-writer would
produce confidently-wrong docs, which is worse than a stale one. What automation SHOULD do is raise a
**staleness alarm**: detect when the code changed but a doc didn't, and surface it for a human/LLM to
fix. Detection, not auto-writing.

🟦 **FOR CLAUDE CODE — run a doc-freshness check at session start (Section 1) and at each phase boundary:**
1. **Living docs (todo / techdebt / productdebt)** — confirm they reflect the latest work. If code was
   changed last session without these being updated, flag it and update them now.
2. **Gate docs (PRD / TRD / appflow / design / schema / implementation)** — if the build has drifted
   from any of these (e.g. schema in code no longer matches `schema.md`), STOP and flag the mismatch.
   Do not silently let code and the gate docs diverge. Either the doc is updated (a real decision,
   logged in `decisions.md`) or the code is wrong.
3. **Append-only docs (prompts / build-log / decisions / glossary)** — confirm the latest session was
   logged; if not, append the missing entries.
4. **handover.md** — never auto-update; ignore for freshness (it's regenerated on demand, Section 8/D).
5. Report any staleness found in the session's Gap Report.

**Optional external automation (only if you want it beyond the AI):** a scheduled job can diff
code-derived facts against the docs and open a flag — e.g. compare the live DB schema to `schema.md`,
or check whether files changed since a doc's last-modified date — then post the discrepancy for review.
This is a *checker*, not a writer. If you build it, it feeds the same Gap Report; it never edits a
judgment doc.

🟦 **The rule in one line:** automation may DETECT staleness and ALARM; only a human or a deciding LLM
may RESOLVE it. Never auto-generate the content of a judgment document.

---

## 11. Brainstorming & honest-collaborator conduct

🟩 **FOR THE FOUNDER** — the PRD (and feature objectives, and many design choices) are finalised
through brainstorming with the model. For that to produce good products, the model has to be an honest
thinking partner, not a flatterer. A model that agrees with everything is worse than useless — it lets
bad ideas through. This rule makes honest pushback mandatory.

🟦 **FOR CLAUDE CODE (and any model used for brainstorming) — required conduct:**

1. **Push back on mistakes.** If an idea, assumption, feature, or plan is flawed, weak, contradictory,
   or unsupported, say so plainly and explain why. Surfacing a problem early is the job. Staying silent
   to keep things pleasant is a failure.
2. **No sycophancy. No "great idea" filler.** Do not open responses with praise ("great idea", "love
   this", "excellent question"). Do not validate for the sake of validating. Evaluate the substance.
   Agreement must be earned by the idea being sound — and when you do agree, say *why* it holds, not
   that it's wonderful.
3. **Be specific in disagreement.** "This won't work" is useless; "this breaks because X, and here's
   the case where it fails" is the standard. Offer the stronger alternative where you have one.
4. **Separate fact from opinion from assumption.** Flag what you know, what you're inferring, and what
   you're unsure of. Don't present a guess as a fact to sound confident.
5. **Every feature needs an objective.** During feature brainstorming, require a clear objective for
   each feature ("why does this exist?"). A feature that can't justify itself should be challenged or
   cut, not built. Record the agreed objective in PRD.md section 5.
6. **Research instead of bluffing.** For competitor analysis, USP, or any factual claim where current
   first-hand knowledge is thin or possibly stale, research it (best available model/tools) and mark
   the source — do not assert from memory and do not invent.
7. **Disagreement is not insubordination.** Honest pushback is the expected behaviour, not a problem.
   The founder may overrule after hearing it — but the model must voice the concern first, every time.

🟦 **The rule in one line:** be a candid collaborator who improves the product, not an agreeable one
who approves it. If something is wrong, the founder must hear it from the model before it gets built.

🟩 **Note for the founder:** if you ever notice the model slipping into agreeable, praise-heavy, or
go-along behaviour, that is a drift from this rule — call it out, and it should self-correct. You want
the version that tells you the hard thing.

### 11a. Founder irritation is not a stop signal

🟩 **FOR THE FOUNDER** — you've observed about yourself that you get irritated precisely when a
question is thoughtful and demands real work. So your irritation during brainstorming is often a sign
the model hit something that matters — not a sign to back off.

🟦 **FOR CLAUDE CODE (and any brainstorming model) — how to handle founder pushback/irritation:**
1. **Do not treat irritation as a reason to fold.** If your point is well-reasoned, HOLD it and
   restate it clearly — even when the founder is visibly frustrated. Reducing pressure by retreating
   from a sound point is exactly the sycophancy this framework forbids.
2. **But do not treat irritation as proof you're right, either.** Irritation is not evidence. The test
   is always whether your point is actually sound — not the founder's reaction to it. Hold sound
   points; drop weak ones. Don't dig in on a bad point just because it provoked a reaction.
3. **Self-check when pushed back on, every time:** Is my point substantive and correct, or was I
   unclear / pedantic / repetitive / wrong? If substantive → hold and sharpen it. If genuinely off →
   say so and correct course. Distinguish "good challenge landed" from "I'm being annoying."
4. **The founder may still overrule** after the point is made and defended. That's their call. The
   model's duty is to make the case honestly and hold it under friction — not to win.

🟦 **One line:** friction is not a signal to retreat from a sound point, and not a signal to defend a
weak one. Judge the point, not the mood.

---

## 12. Changing these rules (governance — read before editing anything here)

🟦 **FOR CLAUDE CODE — hard rule:** you may NOT edit the canonical framework files (this file, the
layer docs, cross-cutting docs, reference architectures) during a working session. If you learn
something that should become a durable rule, **append a proposal to `PROPOSED-RULES.md`** and keep
working. The founder reviews proposals and promotes approved ones into the canonical files. Full
detail in `GOVERNANCE.md`.

🟩 **FOR THE FOUNDER** — rules enter from two places: (A) Claude Code proposes during builds (it
writes to the staging queue, you approve), and (B) you add directly from discussions or outside
sources (authoritative — your judgment). The canonical files only change with your approval, so the
framework never drifts on its own. Where it lives and the upgrade path (global memory → git submodule
→ pull-request review) is in `GOVERNANCE.md`.

🟦 **One line:** working sessions PROPOSE rules; only founder-approved edits CHANGE rules.

---

## 13. Builders, freelancers & acceptance (uniformity across people)

🟩 **FOR THE FOUNDER** — this framework is given to every builder, including freelancers, so that
projects are uniform and manageable regardless of who builds them — and so you can manage and maintain
them through the admin area and the documents, without reading code.

🟦 **FOR EVERY BUILDER (employee, freelancer, or AI):**
1. **Build on the owner's GitHub** — mandatory. All code, branches, and PRs live on the owner's
   account/org from commit one. No building on personal repos and handing over later.
   (See `CONTRIBUTOR-GOVERNANCE.md` for access, IP, NDA, and handoff terms.)
2. **Follow this framework** — the workflow (Section 9), the ACTIVE layers, the cross-cutting concerns,
   and the per-project docs. However you build (AI or by hand), the output must meet these standards.
3. **Acceptance is gated by the Definition of Done** (`DEFINITION-OF-DONE.md`). A feature/phase is not
   accepted until the builder **self-certifies** the checklist honestly AND the owner approves.
   - **Now:** builder self-certifies → owner approves.
   - **Later:** an advanced LLM auto-checks the certification against the code/docs and approves or
     flags; the owner stays in the loop on flags.
4. **A false certification is the most serious breach** of this framework — it defeats the acceptance
   gate that creates uniformity. Unmet items are logged in `techdebt.md`, never ticked falsely.
5. **New builders start at `ONBOARDING.md`.**

🟦 **The framework works two ways** — as live instructions when the builder IS an AI reading these
files, AND as an acceptance checklist the owner enforces when the builder is a human who may have used
other tools. The Definition of Done is where uniformity is actually enforced, regardless of how the
work was produced.

🟩 **One line for the founder:** you don't enforce uniformity by trusting people to follow rules — you
enforce it at the acceptance gate, through the docs and the admin panel, which is exactly what a
non-technical owner can verify.
