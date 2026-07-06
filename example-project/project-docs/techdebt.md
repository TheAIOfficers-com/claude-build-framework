# techdebt.md — Open CODE issues & audit-loop conflicts

**Project:** The Corner Table   (drawn down before each phase closes)

## Open

- **T-003** — Audit log write not yet wired to the cancel action (UI shows confirm, log row not
  inserted). Blocks Phase 2 close. Found: 2026-05-22.
- **T-004** — Layers 10 & 11 consciously skipped at this traffic level (single venue). Accepted
  gap, revisit if a second venue is ever added. Logged per TRD.

## Resolved (kept for the trail)

- **T-001** — Email send failures were silent. Fixed 2026-05-17: failures now retried once, then
  surfaced in the admin health strip. (Found during Phase 1 DoD check — the checklist working.)
- **T-002** — AUDIT-LOOP CONFLICT (plan audit, 2026-05-05): the independent reviewer flagged that
  the Phase 1 plan checked capacity in the API only; a race between two simultaneous submissions
  could double-book. Resolution: capacity check moved into a database transaction (schema.md
  integrity rules). Decision recorded as ADR-002. Auditor: second model, different family.

> 📝 Teaching note: T-002 is the audit loop earning its keep — a real bug caught on paper before
> any code existed. Conflicts get logged here even when resolved immediately; that's the rule
> (CLAUDE.md §9 Step 4).
