# implementation.md — Build phases

**Project:** The Corner Table   **Status:** ✅ COMPLETE (gate passed 2026-05-04)

## Phase 1 — Booking core (DONE 2026-05-18)
- Booking form + capacity check (DB-enforced) + confirmation screen + email.
- Layers touched: 1, 2, 3, 5, 12. DoD certified 2026-05-18; owner approved.

## Phase 2 — Owner admin (IN PROGRESS)
- Owner login (MFA), Today view, any-date view, edit/cancel with blast-radius confirm + audit log,
  slot blocking, health strip.
- Layers touched: 1, 2, 3, 4, 8, 12. Admin plan per CROSS-03 recorded in decisions.md ADR-003.

## Phase 3 — Hardening & launch
- Rate limiting on the public form (Layer 9), backup + restore drill (Layer 13), security pass
  (Layer 8 Section D: scan + auth tampering test), cost alerts wired (Layer 6), DoD full pass.

## Phase boundaries
- techdebt.md drawn down before each phase closes; productdebt.md reviewed at each boundary
  (that's where SMS reminders waits).

> 📝 Teaching note: three phases, each independently shippable and each naming the layers it
> touches — that's what makes the session-start "which layers does today touch?" question fast to
> answer. Phases that can't name their layers aren't planned yet.
