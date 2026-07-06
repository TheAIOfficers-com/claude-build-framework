# LAYER 07 — CI/CD & Version Control

**Status:** ✅ ACTIVE (enforced by Claude Code)
**Aim (non-negotiable):** Every release is safe, repeatable, reviewable, and reversible — no
unreviewed code reaches production, and any change can be undone.

---

## FOR THE FOUNDER — what this layer is

This is how code changes get checked and shipped without breaking what already works, and how a bad
change gets undone. The transcript tackled a problem specific to AI-built software: the AI wrote the
code, you shipped it without reading it, and three months later you own tech debt you do not
understand. The fix is to make the AI review the AI's own work, with you as the orchestrator making
the final call. Three moves:

1. **AI reviewer on every pull request** — a PR is a proposed change. Tools like CodeRabbit,
   Sourcery, or a custom GitHub Action calling Claude automatically review each PR for security,
   performance, and logic problems, and post inline comments you read before merging.
2. **Review for architecture, not typos** — the default AI review catches formatting, which is
   nearly useless. Customise it to focus on business-logic correctness, SQL-injection vectors,
   unhandled edge cases, and N+1 queries, and to flag anything touching auth, payments, or data
   deletion. Catch what breaks in production, not what breaks a linter.
3. **Gate merges on review** — make passing review a required check in GitHub. Critical issues block
   the merge; warnings are informational only. Combined with canary deployment (Layer 5), you get
   two safety nets: AI catches problems before merge, canary catches them after deploy.

---

## FOR CLAUDE CODE — rules to enforce

### A. AI code review & merge gating (ACTIVE — promoted by founder approval, 2026-07-06)
1. **Every PR triggers an automated AI review** (CodeRabbit / Sourcery / custom GitHub Action
   calling Claude) that posts inline comments before merge.
2. **Review prompt targets architecture, not style** — focus on business-logic correctness,
   SQL-injection vectors, unhandled edge cases, N+1 queries; ignore style/formatting preferences.
3. **Mandatory flags** — the reviewer must explicitly flag any change touching authentication,
   payments, or data deletion for human attention.
4. **Merges are gated on review** — a required GitHub status check; the PR cannot merge until review
   passes. Critical issues block the merge; warnings are informational.
5. **Human is the final approver** — the AI advises; the human orchestrator makes the merge call.

### B. CI security scanning (ACTIVE — promoted by founder approval, 2026-07-06; jointly with Layer 8 Section D)
6. Dependency/code scanning on every push (Snyk / GitHub code scanning) via GitHub Actions.
7. Secret scanning on every PR (GitGuardian / TruffleHog) to catch hard-coded secrets.

### C. Version control, testing & rollback (ACTIVE — promoted by founder approval, 2026-07-06)
8. **Branching strategy** — prefer trunk-based development (short-lived branches merged to main
   frequently behind feature flags) for fast-moving teams; git-flow suits slower release-versioned
   products. Keep pull requests small; use conventional commit messages.
9. **Test strategy (concrete, enforceable)** — the test pyramid with numbers, not vibes:
   - **Unit tests:** every business-logic function (pricing, permissions, calculations, state
     transitions) has unit tests. **Coverage floor: 80% of business-logic modules.** UI glue,
     generated code, and config files are excluded from the floor — chasing 80% of everything
     produces junk tests.
   - **Integration tests:** one per API endpoint contract (happy path + main failure path + an
     unauthorized-access attempt). Database queries with RLS get an integration test proving a
     wrong-tenant read returns nothing (ties to Layer 8 Section B).
   - **End-to-end tests:** one per critical user journey only (sign-up, the core paid action,
     admin kill-switch). Target 5–10 E2E tests per product, not hundreds — E2E suites that take
     an hour stop being run.
   - **AI-build pitfall — mocks that lie:** when a test mocks an external service, there must be
     at least one integration test hitting the real service (or its official test mode, e.g.
     Stripe test keys) per feature. A green suite of pure mocks proves nothing about production.
   - **AI evals (CROSS-02):** model-as-judge evals run on every PR that touches a prompt, model
     choice, or AI-output handling — not nightly, not "sometimes." Failed evals block merge like
     failed tests. Every production AI failure becomes a new eval case (failure-driven regression).
   - **Merges are gated on ALL of the above** — tests + evals are required status checks alongside
     the AI review (Section A).
10. **Build reproducibility** — pinned dependencies and lockfiles; versioned, immutable artifacts
   tagged by commit SHA that flow unchanged through environments.
11. **Rollback procedures** — define and rehearse rollback for every deploy (revert in ~2 min — ties
   to Layer 5 + CROSS-02 deploy checklist).
12. **Coordinate migrations with deploys** — use expand-contract so new code + old schema (and vice
   versa) are always compatible during the rollout window. (Ties to Layer 3.)

If any Section A, B, or C rule is unmet, list it in the Gap Report with the risk it leaves open.

---

## Checklist — Sections A & B
- [ ] Every PR gets an automated AI review with inline comments
- [ ] Review prompt tuned for architecture/logic/security, not style
- [ ] Auth / payments / data-deletion changes always flagged
- [ ] Merge blocked until AI review passes (required status check)
- [ ] Critical = block, warning = informational thresholds set
- [ ] Human makes the final merge decision
- [ ] Dependency/code scanning on every push (Snyk / GitHub)
- [ ] Secret scanning on every PR (GitGuardian / TruffleHog)

## Checklist — Section C
- [ ] Branching strategy chosen (trunk-based preferred); small PRs; conventional commits
- [ ] Unit tests on all business logic; 80% coverage floor on business-logic modules
- [ ] Integration test per API contract (happy + failure + unauthorized); RLS cross-tenant test
- [ ] 5–10 E2E tests covering the critical user journeys only
- [ ] Every mocked external service has ≥1 real-service (test-mode) integration test
- [ ] AI evals run on every PR touching prompts/models/AI handling; failures block merge
- [ ] Reproducible builds (lockfiles); immutable SHA-tagged artifacts
- [ ] Rollback procedure defined + rehearsed (~2 min revert)
- [ ] DB migrations coordinated with deploys (expand-contract)

---

## Open questions for the founder (fill in per project)
- Which AI reviewer do we standardise on (CodeRabbit, Sourcery, custom Claude action)?
- What counts as "critical" (auto-block) vs "warning" for this project?
- Is GitHub the version-control host, so required status checks apply directly?
- Canary deployment (Layer 5) is referenced as the second safety net — confirm it is in scope.
