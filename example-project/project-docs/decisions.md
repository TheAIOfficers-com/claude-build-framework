# decisions.md — Decision Record (ADR log, append-only)

**Project:** The Corner Table

## Decisions

### ADR-001 — No customer accounts in v1
- **Date:** 2026-05-02
- **Context:** brainstorming; builder asked whether customers should register.
- **Options considered:** (a) full accounts, (b) magic-link lite accounts, (c) none.
- **Decision:** (c) none — a booking needs a name and phone, not a password.
- **Why:** every added step loses same-day mobile bookers (the primary audience); owner can look
  up any booking by name/phone. Revisit only if repeat-customer features are ever wanted.
- **Layer(s) / docs affected:** Layer 4; PRD §7.
- **Status:** accepted

### ADR-002 — Capacity enforced in a database transaction, not in the API
- **Date:** 2026-05-05
- **Context:** independent plan audit flagged a race condition (two simultaneous submissions could
  both pass an API-level check). Logged as techdebt T-002.
- **Options considered:** (a) API check only, (b) DB transactional check, (c) queue all bookings.
- **Decision:** (b).
- **Why:** the database is the only place both requests meet; (c) is overkill at this scale.
- **Layer(s) / docs affected:** Layers 2, 3; schema.md.
- **Status:** accepted

### ADR-003 — Cost controls: soft alerts + hard cap (owner's choice)
- **Date:** 2026-05-20
- **Context:** CROSS-03 Rule C requires cost options be presented, never auto-decided.
- **Options considered:** hard cap only / soft alerts only / both, tiered.
- **Decision:** both — alerts at 50/75/90% of the agreed monthly budget; hard cap at 2× budget.
- **Why:** owner wanted bill protection but not a site that silently goes offline; at 2× only a
  malfunction (not growth) trips the cap. Framework defaults accepted unchanged.
- **Layer(s) / docs affected:** Layer 6; CROSS-03; admin health strip.
- **Status:** accepted

> 📝 Teaching note: each ADR answers the question a stranger asks six months later: "why is it
> like this?" ADR-002 pairs with techdebt T-002 — conflict logged there, reasoning captured here.
