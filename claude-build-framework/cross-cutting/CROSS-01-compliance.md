# CROSS-CUTTING 01 — Compliance & SOC 2 Readiness

**Type:** Cross-cutting concern (not a stack layer — it audits across many layers)
**Status:** ✅ ACTIVE (enforced by Claude Code)
**Aim (non-negotiable):** When an enterprise prospect asks for proof the system is secure and well-run,
that proof exists and is continuously collected — not scrambled together manually after the fact.

---

## Why this is cross-cutting, not a layer

🟩 **FOR THE FOUNDER** — the 13 layers each BUILD a part of the product. Compliance does not build
anything; it PROVES that the parts were built and run correctly. SOC 2 pulls evidence from your
security layer (8), availability/backups (13), access/auth (4), and CI/CD (7). So it lives in its
own doc that points across the stack, rather than as a 14th layer.

The trigger in plain terms: your first serious enterprise prospect asks for a SOC 2 report. If you
do not have one, they tell you to come back when you do. SOC 2 is not a wall — it is a door — and the
key is automating the evidence, not keeping manual spreadsheets.

---

## FOR CLAUDE CODE — rules to enforce (when ACTIVE)

1. **Continuous compliance monitoring** — use a platform (Vanta, Drata, or SecureFrame) that connects
   directly to the infrastructure (AWS, GitHub, Google Workspace) and automatically collects evidence:
   who has access, what is encrypted, when backups run. It watches 24/7 and alerts on drift.
2. **Automated evidence collection** — SOC 2 needs proof of everything, generated automatically, not
   by hand:
   - Quarterly access reviews (e.g. via Vanta). [Ties to Layer 4 Auth & Layer 8 Security.]
   - Monthly vulnerability scans (e.g. GitHub Dependabot). [Ties to Layer 7 CI/CD scanning.]
   - Backup restoration tests on a schedule (e.g. a cron job that proves backups actually restore).
     [Ties to Layer 13 Availability & Recovery.]
3. **Sequence the certification** — start with **SOC 2 Type 1** (controls are correctly *designed* at
   a point in time; achievable in ~60 days for most startups with automation), then begin the 6–12
   month observation period for **Type 2** (controls have *operated effectively* over time).

If enterprise clients are a target and none of this exists, flag it in the Gap Report — it is a
deal-blocker, not a nice-to-have.

---


---

## Governance & data-privacy rules (from research — broader than SOC 2)

🟦 **FOR CLAUDE CODE — enforce when the relevant users/markets are in scope:**

- **GDPR (any EU users)** — data minimization, purpose limitation, storage limitation (Art. 5); honor
  the right to erasure (Art. 17) on request/consent withdrawal; encryption + pseudonymization (Art.
  32); notify the supervisory authority within 72 hours of a risky breach (Art. 33); consent must be
  freely given, specific, informed, unambiguous (Art. 7). Fines reach €20M or 4% of global turnover.
- **India DPDP Act 2023 (users in India; compliance deadline 13 May 2027)** — free, specific, informed,
  unambiguous consent preceded by an itemized notice; withdrawal as easy as giving consent; honor
  access/correction/erasure/grievance rights; erase on consent withdrawal or purpose completion;
  notify the Data Protection Board + affected individuals of breaches (detailed report within 72h
  under the 2025 Rules); verifiable parental consent for children. Penalties to ₹250 crore. Applies
  extra-territorially. **Directly relevant to the CAIO Tracker (India + global personnel data).**
- **Data retention & PII (NIST SP 800-122)** — documented retention schedules with automated
  deletion/archival; minimize collection; encrypt PII in transit + at rest; pseudonymize/tokenize
  direct identifiers (note: pseudonymized data is still personal data under GDPR); separate duties so
  de-identified-data handlers don't hold the re-identification keys; securely destroy at end of life.
- **Audit trails** — append-only records of security-relevant and data-changing events (who/what/when);
  required for SOC 2, useful for forensics, hard to add retroactively. (Built in Layer 3 rule 6.)

🟩 **FOR THE FOUNDER** — privacy laws give users real rights (see/correct/delete their data) and impose
a 72-hour breach-reporting clock with company-ending fines. The cheapest time to handle this is now:
collect less, encrypt what you keep, schedule deletion, and keep an audit trail. For you specifically,
**DPDP is the priority** given the CAIO Tracker handles Indian + global personnel data.

## Checklist (verify when compliance is in scope)
- [ ] Continuous compliance platform connected (Vanta / Drata / SecureFrame)
- [ ] Automated quarterly access reviews
- [ ] Automated monthly vulnerability scans (Dependabot or equivalent)
- [ ] Scheduled backup-restoration tests that prove restores work
- [ ] SOC 2 Type 1 targeted first, then Type 2 observation period started

---

## Open questions for the founder (fill in per project)
- Are enterprise clients a target for this product? (If no, this doc stays informational.)
- Which compliance platform do we standardise on (Vanta / Drata / SecureFrame)?
- Which frameworks beyond SOC 2 may apply (e.g. GDPR/DPDP given India + global CAIO data)?
- Who owns the compliance evidence and alerts day-to-day?
