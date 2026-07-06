# example-project/ — a complete worked example (read, don't build)

This folder shows what a finished set of `project-docs/` looks like for one deliberately tiny
product: **The Corner Table**, a table-booking page for a single small restaurant. Customers book a
table; the owner sees and manages bookings in an admin panel. Small on purpose — the point is the
documents, not the product.

## How to use it

- **Owners:** skim these in order — PRD → appflow → design → schema → implementation — and you'll
  understand what "the gate docs are complete" means before your own first project. Then look at
  todo/techdebt/decisions to see what live project memory looks like mid-build.
- **Builder AIs:** when drafting a project's gate docs, match the level of specificity shown here.
  Note what the docs DON'T do: no padding, no repeated boilerplate, no feature without an objective.

Lines starting with **📝 Teaching note** explain why the document says what it says. Your real
docs won't have those.

## What this example demonstrates

| Framework rule | Where to see it |
|---|---|
| Every feature has an objective (CLAUDE.md §11.5) | PRD.md feature table |
| Admin visibility per feature (CROSS-03 Rule A) | appflow.md admin screens; implementation.md Phase 2 |
| Cost controls chosen by the owner (CROSS-03 Rule C) | decisions.md ADR-003 |
| Audit-loop conflicts recorded (CLAUDE.md §9) | techdebt.md item T-002; decisions.md ADR-002 |
| Product ideas parked, not built (§8) | productdebt.md |
| Append-only memory | build-log.md, prompts.md, decisions.md |
| Out-of-scope discipline | PRD.md section 7 |

The example is frozen at "Phase 1 complete, Phase 2 in progress" so you can see documents in their
living state — not a sanitised finished project.
