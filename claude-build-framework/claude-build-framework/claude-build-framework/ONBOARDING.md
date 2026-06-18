# ONBOARDING.md — Start Here (for every builder, incl. freelancers)

Welcome. This framework exists so that ANY builder — employee, freelancer, or AI — produces uniform,
maintainable projects that the (non-technical) owner can manage through documents and the admin panel.
Read this first. It is your front door.

---

## 0. The one rule that matters most
**You build to this framework, and your work is accepted only when it passes the Definition of Done
(`DEFINITION-OF-DONE.md`).** Uniformity is enforced at acceptance, not assumed. However you build
(AI or by hand), the output must meet these standards.

---

## 1. Where you build
🟦 **All work happens on the owner's GitHub account / repositories. This is mandatory.** You do not
build on your own repos and hand over later. Code, branches, and PRs live on the owner's account from
commit one. (See `CONTRIBUTOR-GOVERNANCE.md` for access, IP, and confidentiality terms.)

## 2. Read these, in order
1. `CLAUDE.md` — the master rules (session protocol, the gate, the planning workflow, governance).
2. `STACK.md` — the default tech stack and when to deviate.
3. `GOVERNANCE.md` — how the framework is used and how rules change.
4. The `layers/` docs — the 13 engineering standards every build must meet.
5. The `cross-cutting/` docs — compliance, AI reliability, admin/operability (apply across the build).
6. Any `reference-architectures/` doc relevant to what you're building (voice, agent, help desk).
7. `DEFINITION-OF-DONE.md` — the bar your work must pass. **Know this before you start, not after.**

## 3. How you work (the workflow)
Every piece of work follows **SWEEP → MOCKUP → PLAN → AUDIT → IMPLEMENT** (CLAUDE.md Section 9):
- **Sweep** the existing code first — never plan on assumptions.
- **Mockup** before writing the plan (standard, unless the owner overrode it).
- **Plan** grounded in the sweep + mockups; include the per-feature admin plan (CROSS-03).
- **Audit** — the plan is reviewed (independent LLM / reviewer) before implementation.
- **Implement** to the ACTIVE layer rules; update the project docs.

## 4. The project documents
Every project carries its `project-docs/` folder (copied from `project-docs-template/`). Six are the
up-front plan (gate); the rest are living/append-only memory you keep current every session. The owner
manages and reviews the project THROUGH these docs — keep them honest and current. If the docs don't
reflect reality, the work isn't done.

## 5. How your work gets accepted
You **self-certify** against `DEFINITION-OF-DONE.md` (a checklist), and the owner approves. (Over time,
an advanced LLM may auto-check the certification.) A feature/phase is not "done" until certified AND
approved. See `DEFINITION-OF-DONE.md`.

## 6. The non-negotiables (fast list)
- Build on the owner's GitHub. - Follow the workflow (no skipping sweep/audit). - Every feature ships
with its admin visibility (CROSS-03). - No PII mishandling; respect compliance (CROSS-01). - Don't edit
the canonical framework files; propose changes via `PROPOSED-RULES.md`. - Keep the project docs current.
- Self-certify honestly against the Definition of Done.

## 7. Honest-collaborator expectation
Per CLAUDE.md Section 11: flag problems, push back on weak requirements, don't rubber-stamp. The owner
wants to hear concerns before things are built, not after.
