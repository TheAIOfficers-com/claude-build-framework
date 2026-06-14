# project-docs/ — per-project planning & memory

Copy this folder into each new project as `project-docs/`. See `CLAUDE.md` Sections 1, 1b, 8, and 9
for the rules. Code-building rules are NOT duplicated here — they live in the parent framework
(CLAUDE.md + the 13 layer docs). This folder references them.

Documents are grouped by **how they're maintained** — this matters, because a doc maintained the wrong
way rots and becomes misleading.

## A. GATE docs — written up front, complete BEFORE coding (Section 1b)
| File | Role |
|------|------|
| PRD.md | Product requirements (problem, users, core features) |
| TRD.md | Technical requirements (stack, APIs, auth, DB) |
| appflow.md | User journey, screens, UX flow |
| design.md | UI/UX, design language, colors, fonts |
| schema.md | DB tables, data shapes, relationships |
| implementation.md | Build phases |

> Features live as SECTIONS within PRD / appflow / schema — NOT as separate per-feature files, until a
> feature is large enough to genuinely warrant its own doc. Avoid per-feature doc sprawl by default.

## B. LIVING docs — read at session start, updated at session end (Section 1)
| File | Role |
|------|------|
| todo.md | Task tracker: phases built, tasks done, tasks next |
| techdebt.md | Unresolved CODE issues + audit-loop conflicts; cleared before each phase completes |
| productdebt.md | PRODUCT ideas/enhancements found mid-build; reviewed at phase boundaries |

## C. APPEND-ONLY docs — only ever added to, never edited
| File | Role |
|------|------|
| prompts.md | Every meaningful prompt used (the AI build's real source) |
| build-log.md | Chronological record of what was done each session/phase |
| decisions.md | ADR log — why each choice was made (pairs with the audit loop) |
| glossary.md | Project-specific terms and entity names |

## D. GENERATED-ON-DEMAND docs — regenerated at the moment of use, never hand-maintained
| File | Role |
|------|------|
| handover.md | Point-in-time snapshot, regenerated from the live + append-only docs at each handover |

## Freshness
Doc staleness is policed by a session-start check (CLAUDE.md Section 10), not by editing docs blindly.
