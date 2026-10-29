# PROPOSED-RULES.md — Rule Change Staging (review queue)

> Claude Code proposes rule additions/changes HERE. It must NOT edit the canonical files
> (CLAUDE.md, layer docs, cross-cutting, reference architectures) directly. The founder reviews this
> queue and promotes approved items into the canonical files. This keeps the framework deliberate.

🟦 **FOR CLAUDE CODE** — when you discover something during a build that *should* become a durable
rule (a recurring failure, a better pattern, a gap in a layer), append a proposal below. Do NOT change
the canonical files yourself. One proposal per entry. Be specific about which file/layer it targets.

🟩 **FOR THE FOUNDER** — this is the inbox. Review entries, and for each: **approve** (you or Claude
move it into the canonical file and delete it here), **reject** (delete with a note), or **defer**
(leave it). Nothing here is in force until you move it into a canonical doc.

---

## Pending proposals

### (template — copy for each proposal)
- **Proposed by:** Claude Code / [model] / founder
- **Date:**
- **Target file/layer:** e.g. LAYER-03-database.md, or CROSS-02, or new doc
- **Type:** new rule / amend existing rule / new doc
- **Proposal:** the rule text, written in instruction-mode
- **Why (evidence):** what triggered it — the failure, pattern, or source that justifies it
- **Status:** PENDING → APPROVED / REJECTED / DEFERRED
- **Founder note:**

### A fallback exit that completes on weak signals counts only the weak ones
- **Proposed by:** Claude Code (builder), audited by two independent auditor models, from Project A
- **Date:** 2026-10-29
- **Target file/layer:** a cross-cutting reliability doc (data pipelines / AI reliability), or `GLOBAL-AUDIT-LESSONS.md`
- **Type:** new rule
- **Proposal:** A guard that refuses an empty read must state its exit: either a count call on the service, or a ruled number of consecutive empty reads with a logged note. Without an exit, a position that really goes to zero stays "pending" for ever and the page shows a stale value. A fallback that completes after N weak signals counts only the occurrences where the stronger check was unavailable; an occurrence the stronger check contradicted breaks the streak.
- **Why (evidence):** Project A lesson (3 hits as of 2026-10-29): three audit rounds found positions stuck pending, and one fallback promoting on day N what the stronger check had refused on days 1 to N-1. Check: walk one position from more than 0 rows to 0 rows across runs; the chain reaches "complete" by a stated rule.
- **Status:** PENDING
- **Founder note:**

### A task list counts only what the run can land that day
- **Proposed by:** Claude Code (builder), audited by two independent auditor models, from Project A
- **Date:** 2026-10-29
- **Target file/layer:** CROSS-03 (admin/operability)
- **Type:** new rule
- **Proposal:** A status stamp that says "x of y tasks complete" derives `y` from the run's own steps. A kind of data that is only produced on some days (weekly checks) enters the total only on the days it runs. Every task in the total has a step that writes it on an ordinary day.
- **Why (evidence):** Project A lesson (4 hits as of 2026-10-29): four audit rounds found totals that counted weekly-only items in the daily figure. Check: recompute `total` from the chain's steps; each task maps to a step.
- **Status:** PENDING
- **Founder note:**

### Removing credentials from a child process is not a barrier
- **Proposed by:** Claude Code (builder), audited by two independent auditor models, from Project A
- **Date:** 2026-10-29
- **Target file/layer:** the acceptance gate / proof rules (`DEFINITION-OF-DONE.md`, audit loop)
- **Type:** new rule
- **Proposal:** A proof that runs a real entry script must block every outward call structurally in every child run: a stand-in program, a refusal that comes before the sign-in check, the feature switched off in scratch settings, a marker assertion. Scrubbing environment variables is not enough when the code falls back to user-level or machine-level stored credentials. The first run starts from a stop point that cannot reach the network. A proof that defuses a dangerous command by text edit is not safe (parameter prefixes and `-Flag:$true` forms bind). A planted copy of a script that touches a real outside system (scheduler, host, API) runs only under a mock or a name the proof owns.
- **Why (evidence):** Project A incident (2 hits as of 2026-10-29, severe despite the count): a proof made 144 read-only calls to the real system because the chain fell back to the saved user-level login. Check: for each proof that starts a real script, list its barriers; plant the removal of each; the run must still stop before any call.
- **Status:** PENDING
- **Founder note:**

### A version moves with its content
- **Proposed by:** Claude Code (builder), audited by two independent auditor models, from Project A
- **Date:** 2026-10-29
- **Target file/layer:** `GLOBAL-AUDIT-LESSONS.md` (documents)
- **Type:** new rule
- **Proposal:** When a note changes after a copy was shared, the repo copy gets the next version number in file name and heading, and the shared copy is replaced or marked superseded. Never two different texts under one version.
- **Why (evidence):** Project A lesson (1 hit as of 2026-10-29). Check: compare the repo copy with every shared copy of the same version.
- **Status:** PENDING
- **Founder note:**

### Calls routed around a shared step keep the step's guarantees
- **Proposed by:** Claude Code (builder), audited by two independent auditor models, from Project A
- **Date:** 2026-10-29
- **Target file/layer:** `GLOBAL-AUDIT-LESSONS.md` (shared wrappers, external calls)
- **Type:** new rule
- **Proposal:** When a plan routes some calls around a shared step (a raw URL, an extra query option), it says how those calls keep the step's retry ladder, fault classification, staging folder and call count. A shim at the step's own seam keeps the module untouched. A call that goes through a shared wrapper is checked against the audited list by its whole URL (filter, apply, select, count, top), never by name and filter alone.
- **Why (evidence):** Project A lessons (1 and 2 hits as of 2026-10-29).
- **Status:** PENDING
- **Founder note:**

### A rulings table separates the owner's words from the session's reading
- **Proposed by:** Claude Code (builder), audited by two independent auditor models, from Project A
- **Date:** 2026-10-29
- **Target file/layer:** `CLAUDE.md` Section 14 (operating rules) or `GLOBAL-AUDIT-LESSONS.md`
- **Type:** new rule
- **Proposal:** Each ruling row quotes the owner. A question the plan marked "needs your ruling" that the owner did not answer stays open; silence is not a ruling. A restated ruling uses the mode's own rules (unattended: retry ladder, then give up for the day), never the interactive rules by habit.
- **Why (evidence):** Project A lesson (2 hits as of 2026-10-29).
- **Status:** PENDING
- **Founder note:**

### "Every setting lives in the settings file" names its exemptions
- **Proposed by:** Claude Code (builder), audited by two independent auditor models, from Project A
- **Date:** 2026-10-29
- **Target file/layer:** `GLOBAL-AUDIT-LESSONS.md` (hand-over notes)
- **Type:** new rule
- **Proposal:** A plan or hand-over note that claims no local assumptions lists, from a text search of every script the chain calls, each shared module that still carries its own default (drive path, host, lock folder) as a named exemption with its line number. A settings key that no script reads is a knob that does nothing.
- **Why (evidence):** Project A lesson (2 hits as of 2026-10-29).
- **Status:** PENDING
- **Founder note:**

### A change to a script breaks the proofs that plant faults by exact text
- **Proposed by:** Claude Code (builder), audited by two independent auditor models, from Project A
- **Date:** 2026-10-29
- **Target file/layer:** `GLOBAL-AUDIT-LESSONS.md` (proofs)
- **Type:** new rule
- **Proposal:** When a change rewrites a line, search every proof for that line as a planted-edit anchor; each anchor must still match exactly once in the final file. A proof result quoted from a run made before the last code fix is not evidence for the final file.
- **Why (evidence):** Project A lesson (1 hit as of 2026-10-29).
- **Status:** PENDING
- **Founder note:**

### A lesson with 3+ hits becomes a script check with a baseline
- **Proposed by:** Claude Code (builder), audited by two independent auditor models, from Project A
- **Date:** 2026-10-29
- **Target file/layer:** `CLAUDE.md` Section 9 (audit loop) / `GLOBAL-AUDIT-LESSONS.md` header
- **Type:** amend existing rule
- **Proposal:** When a lesson reaches 3 hits, the script check that replaces it is written as a read-only checker with a **baseline allow-list** (exact line text + count + reason): a new hit fails, a stale or changed entry fails, so the check can be added to a codebase that already breaks the lesson. The checker has a proof that (1) fails on planted faults and on empty input, (2) removes each guard and each regex alternative of the checker in turn (by script, not by hand) and requires a case to fail every time, naming the few equivalent changes, and (3) runs on a clean clone with the files committed. A check whose scope is empty reports "not checked", never a pass.
- **Why (evidence):** Project A built one such checker for three lessons. Six audit rounds by one auditor model each found new uncovered forms and untested guards until the guard-by-guard sweep was scripted; the scripted sweep then found two vacuous controls the author had missed. The hit counts of the matching Project A lessons (hard-coded date literals 7+, untested guards 3+) show the manual route does not converge.
- **Status:** PENDING
- **Founder note:**

---

## Decided (kept for the trail — append, don't delete)
| Date | Proposal (short) | Decision | Moved to |
|------|------------------|----------|----------|
| | | | |
