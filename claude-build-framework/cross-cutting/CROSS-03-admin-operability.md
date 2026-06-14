# CROSS-CUTTING 03 — Admin & Operability (the non-technical operator's window)

**Type:** Cross-cutting concern (applies to every build; pulls data from many layers)
**Status:** ✅ ACTIVE (enforced by Claude Code)
**Aim (non-negotiable):** A non-technical operator can SEE everything the system is doing and SAFELY
control the routine things — without touching code — while dangerous actions are gated, explained in
plain language, and reversible. Visibility is unlimited; control is tiered by blast radius.

---

## Why this is cross-cutting

🟩 **FOR THE FOUNDER** — the 13 layers are engineering layers; they assume a technical operator. This
concern guarantees that YOU — non-technical — can monitor and control your own running systems without
reading code or depending on whoever built them. It pulls its data FROM the layers (Layer 12 metrics,
Layer 6 cost, Layer 9 usage, Layer 4 access, REF-03 tickets) and presents them in a form you can act
on. It is the difference between owning your products and being dependent on them.

---

## The governing principle: see everything, control by blast radius

🟩 The more control a panel gives a non-technical operator, the more damage a wrong click can do. So:
- **Monitoring (read) is unlimited** — you can see anything; reading never breaks anything.
- **Control (write) is tiered by blast radius:**
  - **Routine actions** (toggle a non-critical setting, acknowledge a ticket) — available directly.
  - **Powerful/irreversible actions** (cost kill-switch, feature toggle affecting core flows, user
    deletion) — require confirmation, **show their blast radius in plain language** ("this stops all
    AI calls; users will see errors"), are logged, and are reversible wherever possible.

🟦 **FOR CLAUDE CODE** — never expose a powerful action as a bare button. Every powerful action shows
its consequence in plain language before execution, is logged (Layer 12), and has an undo/restore path
unless truly impossible (then it says so explicitly).

---

## The four admin jobs

1. **Monitor** — system health, usage, errors, user activity, ticket status. Read-only, always available.
2. **Cost visibility & control** — live operating cost, broken down per service/feature/(client), with
   alerts and caps. (Ties to Layer 6 cost control + Layer 9 spend caps.)
3. **Feature & config control** — toggle features/flags/settings without a redeploy. (Ties to Layer 5
   feature flags.) Tiered by blast radius.
4. **Operational actions** — approve PRs/tickets (REF-03), manage users, trigger jobs. High-risk;
   gated, logged, role-restricted.

---

## RULE A — Every feature ships with its admin visibility (build requirement)

🟦 **FOR CLAUDE CODE — non-negotiable:** no feature is "done" until it exposes its admin visibility.
Every feature must ship with the read endpoints/views that let the operator see what it's doing
(its usage, its errors, its cost contribution, its key state). Admin visibility is part of the
feature's definition of done — not a later bolt-on. A feature with no operator visibility is incomplete.

- Expose **read endpoints at the relevant levels** so nothing the system does is invisible to the
  operator. (This is the "endpoints at various levels" requirement.)
- The feature's admin view is built and verified in the same phase as the feature.

---

## RULE B — Admin needs are discussed PER FEATURE, at build stage (not up front)

🟩 **FOR THE FOUNDER** — admin needs can't be fully visualised at the start; you don't know what you'll
need to monitor or control until the feature takes shape. So admin design is a recurring conversation,
not a one-time document.

🟦 **FOR CLAUDE CODE — at each feature's build stage, before building it, discuss with the founder and
record decisions on:**
1. **What to monitor** for this feature (metrics, states, errors worth surfacing).
2. **What to control** for this feature, and each control's blast radius / tier.
3. **Multi-tenancy** — does this feature's admin view need per-tenant separation? (Multi-tenant by
   default for client-facing builds — see Tenancy below.)
4. **Role-based access** — which admin roles can see vs. act on this feature. (Ties to Layer 4 RBAC.)
5. **Auth-controlled options** — what requires step-up auth / extra confirmation.

Present the options; do not silently choose. (Reinforced by the cost rule below and Section 11
honest-collaborator conduct.)

---

## RULE C — Cost control options are discussed, never auto-decided

🟦 **FOR CLAUDE CODE — for any cost control (caps, alerts, kill-switches), present the options to the
founder and let them choose; do not pick silently.** At minimum present:
- **Hard auto-cap** (system stops spending at $X without intervention — protects the bill, but can
  take the product offline).
- **Soft alert** (notify the founder at thresholds — protects uptime, but costs can run if unattended).
- **Both, tiered** (alert at lower thresholds, hard-cap at a ceiling).

Per service/feature/client where relevant. Show the trade-off (bill protection vs uptime) in plain
language so the founder decides with eyes open. (Ties to Layer 6 + Layer 9 + CROSS-02 cost caps.)

---

## Tenancy, roles & auth (presented per feature)

🟦 For client-facing builds, default to **multi-tenant admin** — each consulting client sees their own
system's data and cost, isolated (Layer 4 tenant isolation + Layer 8 RLS). Admin is **role-based**
(e.g. founder/super-admin, client-admin, viewer) and **auth-controlled** (powerful actions may need
step-up auth). The exact tenancy/role/auth shape is presented and discussed per feature (Rule B),
since needs differ by feature.

---

## FOR CLAUDE CODE — rules to enforce (summary)
1. Every feature ships with its admin visibility (read endpoints/views) — part of definition of done.
2. Monitoring is unlimited (read); control is tiered by blast radius (write).
3. Powerful actions: plain-language blast-radius warning + confirmation + logging + reversibility.
4. Discuss admin needs per feature at build stage (monitor/control/tenancy/roles/auth) — don't assume.
5. Present cost-control options (hard cap / soft alert / both); founder chooses.
6. Multi-tenant + role-based + auth-controlled options presented per feature for client-facing builds.
7. Operating cost is visible live, broken down, and controllable from the panel.

---

## Checklist (per feature and per build)
- [ ] Feature ships with admin read-visibility (usage/errors/cost/state) — done-definition met
- [ ] Read endpoints exposed at the relevant levels; nothing invisible to the operator
- [ ] Powerful actions gated: plain-language blast radius + confirm + log + reversible
- [ ] Admin needs discussed at this feature's build stage (monitor/control/tenancy/roles/auth)
- [ ] Cost-control options presented and founder-chosen (cap / alert / both), per service/feature/client
- [ ] Multi-tenant + RBAC + auth options presented for client-facing features
- [ ] Live operating-cost view with breakdown and controls

---

## Cross-references
- **Layer 4** — RBAC + tenant isolation for admin access.
- **Layer 6 / Layer 9** — cost data and spend caps surfaced and controlled here.
- **Layer 12** — metrics/logs feed the monitoring views; admin actions are logged here.
- **Layer 5** — feature flags are the mechanism for safe feature/config control.
- **Layer 8** — RLS for per-tenant admin data; access control for the panel.
- **CROSS-02** — AI cost-per-request surfaces in the cost view.
- **REF-03** — the help-desk admin approval panel is one instance of operational actions here.

---

## Open questions for the founder (revisited per feature)
- What does THIS feature need to expose for monitoring, and what controls (with what blast radius)?
- Cost: hard cap, soft alert, or both — and at what thresholds, per what unit (service/feature/client)?
- Tenancy/roles/auth for this feature's admin view?
