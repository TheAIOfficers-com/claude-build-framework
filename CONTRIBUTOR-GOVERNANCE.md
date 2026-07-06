# CONTRIBUTOR-GOVERNANCE.md — Access, IP, Confidentiality & Handoff

Rules for anyone building on these projects who is not the owner (freelancers, contractors, agencies).
These are organizational/legal guardrails, not code rules. **Not legal advice — have the IP/NDA terms
reviewed by counsel before engaging contributors, especially where client data is involved.**

---

## 1. Where work happens (mandatory)
🟦 **All work happens on the owner's GitHub account/organization.** Contributors are granted access to
specific repos; they do NOT build on personal repos and hand over later. This keeps the owner in
control of code, history, and IP from commit one. No exceptions.

## 2. Access (least privilege — ties to Layer 4 / Layer 8)
- Grant the **minimum repo access** a contributor needs, for the **duration** they need it; revoke on
  completion.
- Contributors get **no production secrets** and **no access to real client/personal data** unless
  strictly necessary and contractually covered. Prefer test/synthetic data.
- Admin-panel access for contributors is role-limited (CROSS-03 RBAC) — they do not get owner-level
  control.
- Branch protection on main; contributor work lands via PR and review (Layer 7), never direct to main.

## 3. IP ownership
- All work product (code, docs, designs) is **owned by the owner / the owner's business**, assigned in
  writing before work begins. The contributor retains no rights to reuse client-specific work.
- This framework itself is the owner's IP; contributors follow it but do not acquire rights to it.

## 4. Confidentiality / NDA
- Contributors sign an **NDA** before access. Client data, business logic, the CAIO Tracker's
  India-BD logic and any proprietary systems are confidential.
- Proprietary/competitive-moat logic (per the owner's "build proprietary" principle) is shared with
  contributors only as needed, and never to be reused elsewhere.

## 5. Compliance obligations flow down
- Contributors handling personal data must follow CROSS-01 (GDPR/DPDP) and the data-handling rules.
- For client work, the contributor is a processor under the owner's instructions — data stays on
  approved (often self-hosted) infrastructure (Layer 8 Section E).

## 6. Handoff & exit
- On completion, work is accepted via `DEFINITION-OF-DONE.md`, docs are current, and `handover.md` is
  generated.
- Access is revoked. Any contributor-held credentials are rotated (Layer 8 secrets).
- A clean handoff means the owner (or the next builder) can continue from the docs alone.

## 7. Framework changes by contributors
- Contributors do NOT edit canonical framework files. Improvements go to `PROPOSED-RULES.md`
  (GOVERNANCE.md) for owner approval.

---

🟩 **FOR THE OWNER** — points 3, 4, and 5 (IP assignment, NDA, data obligations) are the ones that
protect you legally and are easy to skip in a hurry. Put them in the contractor agreement before anyone
gets repo access. The technical guardrails (sections 1, 2) keep you in control day to day; the legal
ones (3–5) keep you protected if a relationship goes wrong.
