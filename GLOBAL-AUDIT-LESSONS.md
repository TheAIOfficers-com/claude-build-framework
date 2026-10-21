# GLOBAL-AUDIT-LESSONS.md — mistakes one project paid for, so no project pays twice

🟩 **FOR THE FOUNDER** — every audit costs tokens and time. When an audit finds a mistake, that
mistake is "paid for". This file keeps the mistakes that could happen in ANY project, one line each,
so the next builder avoids them and the next auditor checks for them. Each project also keeps its
own `<PROJECT>_Audit_Lessons.md` for project-specific mistakes.

🟦 **FOR CLAUDE CODE**
- **Builder:** read this file and the project's `<PROJECT>_Audit_Lessons.md` before building (Section 1).
  State which lessons apply to today's change.
- **Auditor:** check the change against every live lesson here and in the project file (Section 9,
  Step 4). Append new repeatable mistakes to the PROJECT file. Tag project-agnostic ones `[GLOBAL?]`
  and propose them in `PROPOSED-RULES.md`. Never edit this file directly; it changes by founder-approved PR.
- **Rules for this file:** append-only (mark RETIRED, never delete); about 30 live lines at most;
  project-agnostic wording; **no client names, data or figures** (the Source column uses a neutral label such as "Project A", never the client or project name; this repo may be public).
  A "hit" = one separate audit round where the mistake was found. When a lesson reaches 3+ hits,
  propose turning it into a script check: a script can't forget.

| # | Lesson | Check | Sev | Hits | Source |
|---|--------|-------|-----|------|--------|
| G01 | After any rule or data change, update every note, doc, plan line and code comment that states the old rule, count or date | Search docs, notes, comments for the old rule/counts/dates | Med | 19 | Project A |
| G02 | Audit every plan, runner, builder and shipped data set BEFORE commit and before any external API call, never after | Commit/API-call time is after the audit date in the record | High | 12 | Project A |
| G03 | When copying a file from another module or phase, update every name, title, header and comment | Grep the copy for the old module name, version, title | Low | 8 | Project A |
| G04 | Recompute every figure in an audit record from the output files; list every changed value | Recompute the record's figures; look for omitted changes | Med | 6 | Project A |
| G05 | A proof must FAIL on a planted fault and on empty input; a check comparing 0 with 0 tests nothing | Run an altered copy and an empty input → FAIL; flag 0=0 checks | High | 4 | Project A |
| G06 | State whether totals come from unrounded values or are sums of rounded values | Recompute both ways; the stated basis matches | Med | 4 | Project A |
| G07 | A proof must PASS on correct output; fix false FAILs before trusting the proof | Run the proof on a known-good build → PASS | Med | 3 | Project A |
| G08 | Label an unproven cause as inference, not fact | Look for causes stated without file evidence | Low | 2 | Project A |
| G09 | Cite real file line numbers in plans and docs; recheck them after edits | Open each cited line; the text matches | Low | 2 | Project A |
| G10 | Make long runs resumable after a cut-off, with no duplicate log rows | Re-run after a cut; log rows match files | Low | 2 | Project A |
| G11 | Test and proof folders copy the files they write; never hard-link to real data | No hard links in test/proof roots | High | 1 | Project A (incident) |
