# LAYER 05 — Hosting & Deployment

**Status:** ✅ ACTIVE (enforced by Claude Code)
**Aim (non-negotiable):** The app runs reliably in a place users can reach, and changes are shipped
in a way that is staged, monitored, and instantly reversible — never all-at-once to everyone.

---

## FOR THE FOUNDER — what this layer is

This is where the app lives on the internet and how new versions get there. The transcript's warning:
if you push to main and every user gets the new code at once, then a bug breaks every user at once —
"that's not a deployment, that's a dice roll." The fix is to release gradually and be able to undo
instantly. Three moves, and together they mean you never ship broken code to everyone:

1. **Canary deployment** — release the new version to ~5% of traffic first; the other 95% stay on
   the stable version. Watch error rates for ~15 minutes. If errors spike, roll back instantly and
   almost nobody noticed. Vercel and Cloudflare support gradual rollouts natively.
2. **Feature flags** — ship new features hidden behind an on/off switch (LaunchDarkly, Flagsmith, or
   even a JSON config in your database). Turn it on for internal users, then beta, then 10%, then
   everyone. If it breaks, kill the flag — the code stays deployed but the feature disappears. No
   rollback needed.
3. **Automated promotion** — let CI watch error rates after a canary. Below threshold for ~30 min →
   auto-promote to 100%. Above threshold → auto-rollback. No human staring at a dashboard at
   midnight; ~20 lines via a GitHub Action plus your error-monitoring API.

These pair with Layer 7: AI review catches problems *before* merge; canary catches them *after* deploy.

---

## FOR CLAUDE CODE — rules to enforce

### A. Safe deployment (DRAFTED — enforce when ACTIVE)
1. **No big-bang deploys** — a new version must not go to 100% of users at once. Use staged/gradual
   rollout (canary) starting at a small slice (~5%) with the rest on the stable version.
2. **Monitor during canary** — watch error rates for a defined window (~15 min minimum) before
   widening the rollout. (Depends on Layer 12 error tracking being in place.)
3. **Instant rollback** — a one-step rollback to the previous stable version must always be available.
4. **Feature flags for new features** — risky or incremental features ship behind a flag
   (LaunchDarkly / Flagsmith / DB config) and are enabled progressively (internal → beta → % → all).
   Killing the flag removes the feature without a redeploy.
5. **Automated promotion/rollback** — CI watches error rates post-canary: auto-promote if below
   threshold for a set window (~30 min), auto-rollback if above. (GitHub Action + monitoring API.)

### B. Environments, IaC & repeatability (DRAFTED — from Twelve-Factor research)
6. **Dev/prod parity** — keep dev, staging, and production as similar as possible: same backing
   services (don't use SQLite locally and Postgres in prod), same OS/runtime. Use containers so the
   same image runs everywhere. (Twelve-Factor X.)
7. **Infrastructure as code** — define all infrastructure in version-controlled, reviewed, repeatable
   files; never configure production by hand. Makes environments reproducible and DR scriptable.
8. **Config in environment variables** — not in code or committed files (Twelve-Factor III). Promote
   the *same* build artifact across environments by changing config only; never rebuild per
   environment (strict build → release → run separation, Twelve-Factor V).
9. **Backing services as attached resources** — DB, cache, queue, mail, storage swappable by config
   alone (Twelve-Factor IV).
10. **Automated DNS + TLS** — automate certificate issuance/renewal (ACME/Let's Encrypt); enforce
   HTTPS everywhere.
11. **One-command, repeatable deploys** — run admin/one-off tasks (migrations) in an identical
   environment using the same codebase and config (Twelve-Factor XII).

If any Section A or B rule is unmet, list it in the Gap Report with the deployment risk it leaves.

---

## Checklist — Section A (safe deployment)
- [ ] No deploy goes to 100% at once; canary starts at ~5%
- [ ] Error rates monitored for a window before widening rollout
- [ ] One-step instant rollback to last stable version available
- [ ] New features ship behind feature flags, enabled progressively
- [ ] CI auto-promotes on healthy metrics / auto-rolls-back on bad ones

## Checklist — Section B
- [ ] Dev/staging/prod parity (same backing services, containerized)
- [ ] Infrastructure defined as version-controlled code; no manual prod config
- [ ] Config in env vars; same build artifact promoted across environments
- [ ] Backing services swappable by config
- [ ] DNS + TLS automated; HTTPS enforced
- [ ] One-command repeatable deploys; migrations run in identical env

---

## Open questions for the founder (fill in per project)
- Which host are we on (Vercel / Cloudflare / other), so we map its native rollout features?
- Which feature-flag tool (LaunchDarkly, Flagsmith, or simple DB config)?
- What error-rate threshold and monitoring window define "healthy" for auto-promotion?
- Is Layer 12 (error tracking) in place yet? Canary monitoring depends on it.
