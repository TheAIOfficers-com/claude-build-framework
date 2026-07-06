# build-log.md — Chronological record (append-only)

**Project:** The Corner Table

- **2026-05-02** — Brainstorm session. PRD drafted; SMS reminders and customer accounts challenged
  and cut (ADR-001). Feature objectives agreed.
- **2026-05-03** — 7 mockups produced and reviewed. Owner moved health strip onto Today view.
  Mockups approved.
- **2026-05-04** — Remaining gate docs completed (TRD, design, schema, implementation). Gate
  passed. Framework pinned at v1.3.0.
- **2026-05-05** — Phase 1 plan swept against (empty) codebase, written, audited by a second model.
  One conflict found (capacity race — T-002/ADR-002). Resolved; implementation started.
- **2026-05-10** — Booking form + capacity transaction built; staging deploy; race condition
  test: 20 simultaneous submissions for last slot → exactly 1 success. Evidence in DoD pack.
- **2026-05-17** — Email confirmations wired; silent-failure bug found and fixed (T-001).
- **2026-05-18** — Phase 1 DoD certified item-by-item; owner approved; release tagged.
- **2026-05-21** — Phase 2 start. Owner auth + MFA wired and verified.
- **2026-05-22** — Admin Today view built and verified on staging. Cancel flow UI drafted;
  audit-log write still pending (T-003).

> 📝 Teaching note: one line per meaningful event, newest at the bottom, never edited. Six months
> later this file answers "what actually happened and when" without archaeology.
