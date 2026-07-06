# CHANGELOG — claude-build-framework

Versioning: semantic (MAJOR.MINOR.PATCH) — see `GOVERNANCE.md` Section 4 for what each level means
and how projects pin/upgrade. Newest entries first. Entries are never deleted; reversed rules are
superseded by a new entry.

---

## v1.4.0 — 2026-07-06

**Source:** founder-approved review of the framework's beginner experience (five gaps identified
and closed).

### Added
- `example-project/` — a complete worked example ("The Corner Table," a single-restaurant booking
  page) with all 14 project docs filled in at teaching scale, annotated with 📝 notes, frozen
  mid-build (Phase 2 in progress) so living docs are shown in their real state. Demonstrates:
  feature objectives, an audit-loop conflict caught on paper (capacity race condition), cost
  controls chosen by the owner, parked product ideas, append-only memory. **Why:** beginners
  learn what "good" looks like from examples, not rules — empty templates can't teach specificity.
- `TROUBLESHOOTING.md` — twelve common problems with plain-language fixes and paste-ready recovery
  prompts, starting with the Windows script-blocking error most first-time users will hit.
  **Why:** the first failure a beginner meets decides whether they continue.
- `START-HERE.md` practice-run track — a 30-minute throwaway project (using the framework's
  existing throwaway exception) so the first taste of the gates happens at zero stakes, plus a
  pointer to the worked example. **Why:** first contact with the full gate on a real project reads
  as bureaucracy; at toy scale it reads as machinery.
- `START-HERE.md` cost-expectations section — honest ballparks for build and running costs and the
  two protections (alerts + hard cap). **Why:** without an anchor, even a normal first bill is a
  shock.
- `GOVERNANCE.md` Section 6 — the monthly compliance spot-check: a standing prompt for a DIFFERENT
  AI to verify the process was actually followed (sweeps done, audits real, certifications backed
  by evidence, docs matching history), with builder-side rules for handling findings. **Why:**
  cross-model audit covered plans; nothing verified the process itself, and a non-technical owner
  cannot detect quiet drift.

### Changed
- `README.md` and `CLAUDE.md` Section 5 list the new files; START-HERE error guidance points to
  TROUBLESHOOTING.md.

---

## v1.3.0 — 2026-07-06

**Source:** founder decision (moving framework changes to pull-request review on the public repo).

### Added
- `GOVERNANCE.md` Section 5 — the owner's pull-request review process, written for a
  non-technical owner: the five-step review ritual (read the description, AI audit with a
  copy-paste prompt, verdict-based decision, cross-model second opinion for substantial changes,
  owner-only merge), the one-way rule (changes may harden the framework, never soften it), and
  instant red flags. **Why:** on a public repo anyone can propose changes, and these documents
  are executable policy for AI builders — a one-line softening disarms a gate on every future
  build, so review is a governance act, not a formality.
- `CONTRIBUTING.md` — rules for outside contributors: one topic per PR, plain-language
  descriptions, changelog entry required, house style, what gets accepted vs rejected.

### Changed
- `GOVERNANCE.md` Section 3 Source A: the pull-request method is now the standard for all
  canonical-file changes (direct pushes to main retired); `PROPOSED-RULES.md` remains the quick
  capture queue during builds.
- `README.md` license/contributions line points to `CONTRIBUTING.md`.

---

## v1.2.0 — 2026-07-06

**Source:** founder decision.

### Added
- `CLAUDE.md` Section 16 — model roles. The best available model is the Planner, Architect, and
  Auditor (Builder only when the job genuinely needs it: novel/hard problems, security-critical
  code, twice-failed work). The second-best model is the Orchestrator and default Builder, routing
  routine work down to lighter models and escalating on defined triggers. Audit independence
  (Section 9) still applies at every tier. **Why:** running everything on the strongest model
  wastes money on typing; running everything on a light model produces shallow plans.
- `CLAUDE.md` Section 17 — token economy. Key rule: **survey and advise** — at project setup the
  AI checks which token-saving capabilities exist in the environment at that point in time and
  recommends a lean configuration with trade-offs; the founder decides. Efficient is the default;
  loosening it is the founder's prerogative. Plus standing habits: concise output, on-demand
  loading, scoped reads, context resets between tasks, model right-sizing, and surfacing unusual
  spend as a Gap Report item. Deliberately names no specific tools — availability changes, so the
  rule is to check at the time, not recite from memory. **Why:** newcomers overspend silently;
  efficiency must be the starting point, not a lesson from the first bill.
- `START-HERE.md` — "Keeping your AI bill small" section in plain language, plus the
  "Are we set up to be token-efficient?" steering phrase.
- `claude-integration/claude-best-practices.md` — token-saving items updated to reference
  Sections 16 and 17.

---

## v1.1.0 — 2026-07-06

**Source:** founder-approved framework review, July 2026.

### Added
- `CLAUDE.md` Section 14 — operating rules for the builder AI (verify before asserting, root cause
  before fixes, prove-it-works evidence, honest reporting, smallest-change scope, finish the turn,
  ask only when it matters, docs move with code). **Why:** the framework said WHAT to build; these
  pin down HOW the builder behaves, whatever model is running.
- `CLAUDE.md` Section 15 — skills, plugins & MCP server selection rules (check the toolbox before
  improvising, match tool to workflow step, no new connectors without founder approval, least
  access, name missing capabilities instead of faking them, log tool additions in decisions.md).
  **Why:** connectors are third-party code with data access — choosing tools well is a build
  quality issue AND a supply-chain decision.
- `CHANGELOG.md` (this file) and a defined semver scheme + project pinning/upgrade rules
  (`GOVERNANCE.md` Section 4). **Why:** projects had no way to know which framework version they
  were built under, or when/how to upgrade.
- `START-HERE.md` — plain-English quick start for the non-technical owner, from "download the ZIP
  and unzip it" through the first prompt to fire up a project, plus everyday steering phrases and
  a no-terminal fallback. **Why:** SETUP/ONBOARDING serve builders; the owner needed a zero-jargon
  front door that assumes nothing.
- `scripts/new-project.ps1` and `scripts/new-project.sh` — one-command project bootstrap (copies
  `project-docs-template/`, writes the project `CLAUDE.md` wired to the framework, records the
  framework version pin). **Why:** manual project setup was error-prone for a non-technical owner.
- LAYER-07 Section C rule 9 rewritten as a concrete test strategy: 80% coverage floor on
  business-logic modules, integration test per API contract (incl. RLS cross-tenant test), 5–10
  E2E tests on critical journeys, "mocks that lie" rule (≥1 real-service test per mocked feature),
  AI evals on every prompt-touching PR blocking merge. **Why:** "test pyramid" without numbers
  could be certified without real coverage.
- LAYER-08 Section F — secrets incident runbook (revoke → rotate → purge → audit → log → fix),
  rotation schedule per environment (prod 90d/dynamic, staging 180d, dev gitignored `.env`), and
  the client-side key reality check (keys shipped to browsers are public; secret keys live
  server-side only). **Why:** the framework prevented leaks but had no procedure for when one
  happens anyway.
- CROSS-03 Rule C default cost thresholds: soft alerts 50/75/90% of budget, hard cap at 2× monthly
  budget, per-request AI ceiling of 1% of daily AI budget, per-feature cost attribution via
  resource tags + labelled AI-call logs, and an alert-fatigue rule. **Why:** "present options" had
  no starting numbers, so every discussion started from zero.
- `project-docs-template/README.md` — archival rule for append-only docs (roll to
  `archive/<file>-YYYY.md` past ~1,500 lines; keep last ~200 lines + pointer). **Why:** unbounded
  build-log/prompts/decisions files eventually exceed what a session can read.

### Changed
- Repository restructured: framework files now live at the repo ROOT (previously nested one to
  three folders deep from ZIP uploads, with a stray duplicate tree and packaged zip inside the
  repo). The `claude-integration/` kit (sub-agents, slash commands, hooks, `.claude` template) is
  kept at `/claude-integration/` and is now referenced by `CLAUDE.md` Sections 5 and 15.
  **Why:** one canonical copy of each file; duplicates guarantee drift.
- `README.md` rewritten as the public landing page, pointing newcomers to `START-HERE.md`.
- `CLAUDE.md` Section 1 (session start protocol): replaced "read all 13 layer docs every session"
  with targeted reading — master + STACK + project memory always; layer docs only for the layers
  today's work touches; ALL 13 still read for new projects, Definition-of-Done certification, and
  whole-system audits. **Why:** the mandatory read was ~23,000 words (~18K tokens) per session,
  spending 10–15% of the AI's working memory before any code; the Definition of Done still checks
  all 13 layers, so nothing is lost at acceptance.
- LAYER-06 Sections A & B, LAYER-07 Sections A–C, LAYER-08 Sections A–E: status labels promoted
  from DRAFTED to ACTIVE by founder approval. **Why:** the layer headers said ACTIVE while inner
  sections said DRAFTED, making the enforced set ambiguous — the Definition of Done looked
  stronger than what was actually enforced.
- `CLAUDE.md` Section 5 file list updated with the new files.

---

## v1.0.0 — baseline (pre-2026-07-06)

Initial framework as built from founder transcripts and discussions: master `CLAUDE.md` (session
protocol, pre-coding gate, 13 layers, SWEEP → MOCKUP → PLAN → AUDIT → IMPLEMENT, staleness checking,
honest-collaborator conduct, governance), 13 layer docs, CROSS-01/02/03, REF-01/02/03,
`project-docs-template/`, `DEFINITION-OF-DONE.md`, `GOVERNANCE.md`, `CONTRIBUTOR-GOVERNANCE.md`,
`ONBOARDING.md`, `SETUP.md`, `STACK.md`, `PROPOSED-RULES.md`.
