# CHANGELOG — claude-build-framework

Versioning: semantic (MAJOR.MINOR.PATCH) — see `GOVERNANCE.md` Section 4 for what each level means
and how projects pin/upgrade. Newest entries first. Entries are never deleted; reversed rules are
superseded by a new entry.

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
