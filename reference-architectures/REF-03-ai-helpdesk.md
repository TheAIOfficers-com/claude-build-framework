# REFERENCE ARCHITECTURE 03 — Self-Hosted AI Help Desk

**Type:** Reference architecture (used only when a build needs an in-app AI help desk)
**Status:** ✅ ACTIVE (enforced by Claude Code) — for help-desk builds
**Aim (non-negotiable):** Users get fast, in-context help from any page; genuine bugs are triaged,
validated, and routed to a human-approved fix — WITHOUT capturing or transmitting personal data in a
way that is legally indefensible anywhere the product operates.

---

## ⚠️ BUILDER CAVEAT — READ BEFORE IMPLEMENTING (non-negotiable)

🟦 **FOR CLAUDE CODE / ANYONE BUILDING THIS:**
This feature captures the user's screen. That is a legal and privacy-sensitive act. The safeguards in
this document (consent, redaction, preview-and-confirm, self-hosting) are **structural requirements,
not options** — the feature may not be built without all of them.

- **This is not legal advice and "legal everywhere" is not guaranteed by this design alone.** Before
  launch, a real legal review against the actual target markets is REQUIRED, not optional.
- **Founder's standing rule for this feature: "if doubtful, remove it."** If any element cannot be
  made clearly defensible for a given deployment/market, that element is cut for that deployment —
  err toward capturing less.
- Specialized data (health, children's data, biometrics) carries extra obligations that consent +
  redaction may not clear. For clients in those sectors, default to **text-only help (no screen
  capture)** for that deployment.
- Ties hard to CROSS-01 (GDPR/DPDP/SOC 2) and Layer 8 Section E (data residency). You are the data
  controller; you cannot offload PII responsibility onto the user.

---

## FOR THE FOUNDER — what this is

A help icon on every page. The user clicks it for help. With their explicit consent, the system
captures a screenshot, automatically redacts personal data, shows the user exactly what will be sent
and lets them confirm or cancel, then sends it to SELF-HOSTED models that triage the issue. Genuine
bugs become tickets that an advanced model validates and advises on; a human approves yes/no in an
admin panel; "yes" creates a bug-fix PR that flows through the normal build-and-review workflow.
Non-bugs get the user step-by-step guidance immediately.

The design's whole point: **resolve faster by gathering better information, without ever crossing a
legal line.** Safeguards are built in by construction so the risky version cannot happen.

---

## The flow (end to end)

**1. Help icon (every page)** — a persistent help affordance opens a chat/message box.

**2. Consent notice** — before any capture, a clear notice states: what is captured (a screenshot +
the user's typed description; session-journey only if explicitly opted in — see below), why, and where
it is processed (our own infrastructure). The user must actively consent.

**3. Capture + automatic PII redaction** — capture the screenshot, then redact BEFORE anything leaves
the device / before any model sees it: mask text input fields, emails, numbers, names, faces, and
other detectable identifiers. Redaction is automatic and non-optional.

**4. Preview-and-confirm (the key legal gate)** — show the user the exact REDACTED image and the
session data that will be sent. They confirm or cancel. This converts the basis from "we captured
their screen" to "the user inspected and chose to send this specific information," and is the user's
last check for anything redaction missed. No confirm → nothing is sent.

**5. Triage pipeline — TWO self-hosted models, DIFFERENT JOBS (a pipeline, not a vote):**
   - **Model A — Classifier & extractor:** is this a bug, user confusion, or a feature request? Extract
     reproduction steps and the affected area from the screenshot + description.
   - **Model B — Severity & dedup:** assess severity/priority and check against known/existing issues
     so duplicates don't spawn new work.
   (Two different jobs add real value; two models voting on the same question would just double cost
   for correlated errors.)

**6a. If NOT a bug** — respond to the user immediately with the steps to resolve their issue (guidance,
not a ticket).

**6b. If a bug** — respond "thanks, we'll get back to you," and open an **automated ticket** carrying
the redacted evidence, classification, repro steps, and severity.

**7. Advanced-LLM validation (validator/advisor, NOT actor)** — an advanced model reviews the ticket:
   does the reported behaviour actually conflict with the PRD / intended behaviour? It checks the
   relevant code area against intent, and produces a **diagnosis + recommended action + confidence** —
   advice for the human, not an autonomous change.

**8. Human decision (admin panel)** — a human sees the ticket + the advanced model's diagnosis and
   clicks **yes** (real bug, fix it) or **no** (not a bug / won't fix), with a reason.

**9. On YES → create a PR (into the existing workflow)** — "yes" triggers the fix to enter the normal
   **SWEEP → PLAN → AUDIT → IMPLEMENT workflow (CLAUDE.md Section 9)**, producing a bug-fix PR on a
   branch — exactly like the document/rule PR pattern. The PR still requires normal code review before
   merge (Layer 7). **"Yes" means "create the PR," NOT "merge an unreviewed fix."** Two gates: admin
   yes (worth fixing) + PR review (safe to ship).

**10. Loop closure** — every ticket reaches a defined closed state and the user is informed. See the
   generic ticket-lifecycle section below — closure is not just the happy path.

---

## Generic ticket lifecycle & loop closure

🟩 **FOR THE FOUNDER** — a help desk is only trustworthy if every ticket *ends* somewhere visible and
the user always hears back. This is the generic close-loop: it covers every outcome, not just "bug
fixed." No ticket is allowed to silently vanish.

🟦 **FOR CLAUDE CODE — every ticket moves through defined states and is closed with user notification:**

**Ticket states:**
`OPEN` → `TRIAGED` → `AWAITING_DECISION` → (`IN_PROGRESS` | `CLOSED`) → `RESOLVED_NOTIFIED`

**Closure paths (all must notify the reporter, all must record an outcome):**
1. **Bug fixed** — admin said yes → PR created → merged & shipped (Layer 7) → ticket `RESOLVED`;
   notify the reporter "fixed in this release," with what changed in plain language.
2. **Not a bug (guidance resolved it)** — triage returned steps; ticket auto-closes as `RESOLVED`
   once the user confirms the steps worked (see confirmation gate below).
3. **Won't fix / not a bug (admin said no)** — ticket `CLOSED` with a reason; notify the reporter with
   a clear, respectful explanation (and a workaround if one exists).
4. **Duplicate** — linked to the canonical ticket and `CLOSED` as duplicate; reporter is notified when
   the canonical ticket resolves (they ride along on its closure).
5. **Cannot reproduce / needs info** — ticket parked in `AWAITING_USER`; the user is asked for more
   detail. If no response within a defined window, auto-close as `STALE` with a notification that they
   can reopen anytime.

**Confirmation gate (prevents false closure):** for guidance-resolved tickets, ask the user "did this
solve it?" Yes → close. No → escalate (re-triage, or route to a human). A ticket is NOT closed on the
assumption that guidance worked — only on user confirmation or a defined timeout.

**Reopen path:** any closed ticket can be reopened by the user (e.g. "still broken") within a window;
a reopened ticket returns to `TRIAGED` and carries its history.

**No silent death:** every ticket must reach a closed state with (a) a recorded outcome/reason and
(b) a notification to the reporter. A ticket with no closure and no notification is a system failure —
surface it. (Ties to Layer 12: ticket states, decisions, and resolutions are logged.)

🟦 **One line:** every ticket ends in a recorded outcome and the user always hears back — fixed,
explained, or asked for more — never silence.

---

## Self-hosting & data residency (non-negotiable)

🟦 All models that see user-screen data MUST be **self-hosted** (per Layer 8 Section E, REF-02 local
tier). Redacted screen data must not be sent to a third-party cloud API. This makes the data-residency
story clean ("your infra, your rules") and is itself a selling point to sensitive/enterprise clients.

---

## Session-journey recording (RISKIEST PIECE — opt-in, off by default)

🟩 Recording the user's click-path through the session is closer to behavioral tracking and is more
legally fraught than a single consented screenshot. Therefore:

🟦 Session-journey capture is **OFF BY DEFAULT and strictly opt-in** per deployment, with its own
explicit consent. A single redacted-and-confirmed screenshot + the user's typed description gives the
models most of what they need. If doubtful for a market, this is the first feature cut.

---

## FOR CLAUDE CODE — rules to enforce (when building a help desk)

1. Help affordance on every page; opens chat/message box.
2. Explicit consent BEFORE any capture; no silent/automatic screen capture, ever.
3. Automatic PII redaction before data leaves the device / before any model sees it — non-optional.
4. Preview-and-confirm of the redacted payload; nothing sent without active confirm.
5. All models seeing screen data are self-hosted; no third-party cloud for this data.
6. Triage = two self-hosted models with DIFFERENT jobs (classify/extract; severity/dedup).
7. Bug path opens a ticket with redacted evidence; non-bug path returns guidance immediately.
8. Advanced LLM validates against PRD/intent and ADVISES; it does not act autonomously.
9. Human yes/no in admin panel; "yes" creates a PR via the Section 9 workflow (still needs PR review).
10. Close the loop: every ticket reaches a recorded closed state and the reporter is always notified —
    fixed, explained (won't-fix/not-a-bug), or asked for more info. No silent ticket death. Guidance-
    resolved tickets close only on user confirmation or timeout. Closed tickets are reopenable.
11. Session-journey capture off by default, opt-in only.
12. Surface the builder caveat + require legal review before launch; for health/children/biometric
    data sectors, default to text-only (no screen capture).

If any of safeguards 2–5 is missing, the feature MUST NOT ship — this is a hard failure, not a gap.

---

## Checklist (when building a help desk)
- [ ] Help icon on every page → chat box
- [ ] Explicit consent before any capture (no silent capture)
- [ ] Automatic PII redaction before transmission
- [ ] Preview-and-confirm of redacted payload; cancel works
- [ ] All screen-data models self-hosted (no third-party cloud)
- [ ] Two-model triage pipeline (classify/extract + severity/dedup), different jobs
- [ ] Non-bug → immediate guidance; bug → ticket with redacted evidence
- [ ] Advanced LLM validates vs PRD and advises (does not act)
- [ ] Admin yes/no; yes → PR via Section 9 workflow; PR still reviewed before merge
- [ ] Loop closed: every ticket reaches a recorded closed state + user notified (all outcomes)
- [ ] Guidance-resolved tickets close only on user confirmation or timeout; tickets reopenable
- [ ] Session-journey capture off by default / opt-in only
- [ ] Builder caveat shown; legal review scheduled; text-only fallback for sensitive sectors

---

## Cross-references
- **CROSS-01 (Compliance)** — GDPR/DPDP/SOC 2; you are the data controller.
- **Layer 8 Section E** — self-hosting / data residency for the models.
- **REF-02** — self-hosted local model tier for the triage/validation models.
- **Layer 4 / Layer 8** — admin panel access control (only authorized humans approve).
- **CLAUDE.md Section 9** — "yes" routes the fix through SWEEP→PLAN→AUDIT→IMPLEMENT.
- **Layer 7** — the resulting bug-fix PR still passes normal code review before merge.
- **Layer 12** — tickets, decisions, and resolutions are logged.

---

## Open questions for the founder (fill in per deployment)
- Which self-hosted models run triage (A/B) and validation, and on what hardware (Layer 6)?
- What is the redaction implementation, and how is its accuracy tested before launch?
- Which markets does this deployment serve — and has counsel reviewed it for those?
- Is this sector subject to special-category data rules (→ text-only fallback)?
- Who are the authorized admin approvers, and what is the SLA from ticket to decision?
