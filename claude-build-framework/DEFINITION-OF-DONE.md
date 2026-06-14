# DEFINITION-OF-DONE.md — The Acceptance Gate

This is the bar every feature/phase must pass before it is accepted. **Uniformity is enforced here** —
regardless of who built it or how. The builder self-certifies against this checklist; the owner
approves; later an advanced LLM may auto-verify the certification.

---

## How acceptance works

🟩 **FOR THE OWNER (non-technical)** — you do not need to read code to accept work. You accept based on
(a) the builder's signed certification below, (b) what you can see in the **documents** (do they match
what was built?), and (c) what you can see in the **admin panel** (does the feature's monitoring/cost
visibility actually work?). If the docs and admin panel don't let you verify it, it isn't done.

**The progression you chose:**
1. **Now:** builder self-certifies → **owner approves** manually.
2. **Later:** an **advanced LLM auto-checks** the certification (sweeps the code/docs against this
   checklist) and approves or flags; owner stays in the loop on flags.

🟦 **FOR THE BUILDER** — self-certify honestly. A false certification is the most serious breach of
this framework — it defeats the entire point of the acceptance gate. If something isn't met, say so and
log it in `techdebt.md`; do not tick a box that isn't true.

---

## The certification checklist (builder ticks; owner/LLM verifies)

### A. Process followed
- [ ] Built on the owner's GitHub repo (mandatory)
- [ ] Workflow followed: sweep → mockup → plan → audit → implement (Section 9)
- [ ] Plan was audited by an independent reviewer before implementation; conflicts logged to techdebt

### B. The 13 layers (only those the feature touches)
- [ ] Each ACTIVE layer the feature touches has its aim met (or gaps logged in techdebt with reason)
- [ ] Server-side validation / never-trust-the-client respected (Layer 2)
- [ ] Data integrity + migrations done safely (Layer 3)
- [ ] Auth/permissions correct; tenant isolation where applicable (Layer 4)
- [ ] Security: no secrets in code, encryption, no PII in logs (Layers 8, 12)
- [ ] Cost caps / rate limits in place for anything metered (Layers 6, 9)

### C. Admin & operability (CROSS-03) — the owner's window
- [ ] Feature ships with its admin visibility (the owner can SEE what it does)
- [ ] Cost contribution of the feature is visible; controls present and tier-gated
- [ ] Powerful actions show plain-language blast radius + confirm + are logged + reversible
- [ ] Admin needs for this feature were discussed with the owner at build stage

### D. AI reliability (CROSS-02) — if the feature uses AI
- [ ] AI output validated → retry → degrade; no raw output/errors to users
- [ ] Self-hosted where data residency requires it; cost-per-request logged

### E. Compliance (CROSS-01) — if the feature touches personal data
- [ ] PII handled lawfully; consent where required; retention/erasure respected
- [ ] No legally-risky capture/processing without the safeguards (e.g. REF-03 rules)

### F. Documentation & memory (the owner manages through these)
- [ ] PRD/TRD/appflow/design/schema/implementation updated to match what was actually built
- [ ] todo.md, techdebt.md, productdebt.md current
- [ ] build-log.md, prompts.md, decisions.md appended for this work
- [ ] Anything deferred is in techdebt.md (code) or productdebt.md (product) — nothing silently dropped

### G. Loop closure / handoff
- [ ] A non-technical owner can understand the current state from the docs alone
- [ ] handover.md regeneratable from current docs (it reflects reality)

---

## Certification block (builder fills, per feature/phase)

**Feature / phase:** ____________________
**Builder:** ____________________   **Date:** __________
**I certify the above checklist is honestly met. Exceptions are logged in techdebt.md:**
- Exceptions / known gaps: ____________________
**Signature / handle:** ____________________

**Owner decision:** ☐ Approved   ☐ Returned (reasons): ____________________
**(Later) LLM auto-check:** ☐ Pass   ☐ Flagged: ____________________
