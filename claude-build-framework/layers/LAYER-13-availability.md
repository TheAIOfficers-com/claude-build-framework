# LAYER 13 — Availability & Recovery

**Status:** ✅ ACTIVE (enforced by Claude Code)
**Aim (non-negotiable):** The system survives failures and can be restored to a known-good state —
and the backups are *proven* by restore, not just assumed.

---

## FOR THE FOUNDER — what this layer is

This layer answers "what happens when something breaks?" — and something always breaks. The biggest
trap is believing you have backups when you've never actually restored one; prove it with a fire-drill
restore. "RTO" is how long you can be down; "RPO" is how much recent data you can afford to lose — and
they cost money to shrink, so set them per system. Note that "99.9% uptime" still means almost 9 hours
of outage a year, so don't promise more nines than you need. When incidents happen, run a calm process
and a *blameless* review (blame makes people hide the next problem). And put up a status page —
customers forgive outages far more readily than silence.

---

## FOR CLAUDE CODE — rules to enforce

1. **3-2-1 backups, automated** — three copies, two media, one offsite; extend to 3-2-1-1-0 (one
   immutable/air-gapped copy, zero verification errors) for ransomware resilience. Automate on a
   schedule.
2. **A backup is not real until a restore is proven** — schedule regular restore drills into a clean
   environment, time them, and have someone who knows the app confirm it works. Untested backups are
   not reliable. (Required evidence for CROSS-01 SOC 2.)
3. **RTO/RPO per workload, not blanket** — RTO = max acceptable downtime (measured forward from
   incident); RPO = max tolerable data loss (measured back to last good backup). Tier systems (e.g.
   Tier 1 <15 min, Tier 2 <4 h, Tier 3 <24 h). Backup frequency defines RPO; restore capability
   defines RTO. (Aligns with NIST SP 800-34.)
4. **Eliminate single points of failure** — redundancy across fault-isolation zones: multi-AZ,
   read replicas with automated failover, multi-region for the most critical paths. Beware hard
   dependencies (a 99.99% service depending on two independent 99.99% services reaches only ~99.98%).
5. **Three health checks (per Kubernetes guidance)** — liveness (restart a stuck process), readiness
   (stop sending traffic when not ready), startup (protect slow-booting apps). Keep liveness
   lightweight and dependency-free — checking a dependency there can cause cascading mass-restarts.
   (Feeds Layer 11 + Layer 5 canary.)
6. **Graceful degradation** — shed non-essential features under load rather than failing entirely;
   serve stale data where acceptable. (Shared principle with CROSS-02 AI degrade.)
7. **Incident-response process** — detection → triage → mitigation → communication → postmortem with
   tracked actions. Define severity levels in advance (SEV1 full outage/breach, SEV2 key feature
   broken, SEV3 minor with workaround). Distinguish severity (impact) from priority (response decision).
8. **Blameless postmortems** — focus on contributing causes, not individuals. Blame culture makes
   people hide problems so root causes never get fixed (Google SRE).
9. **Public status page on independent infrastructure** — stays up when your app is down; real-time
   component status + incident timelines. Reduces duplicate tickets; expected by enterprise buyers.
10. **Chaos engineering (as you mature)** — inject controlled failures to build confidence the system
   withstands turbulent production conditions.
11. **Set uptime target to business impact** — know the cost of each nine:

   | Uptime | Downtime/year | Downtime/month |
   |---|---|---|
   | 99% | ~3.65 days | ~7.3 h |
   | 99.9% | ~8.76 h | ~43.8 min |
   | 99.99% | ~52.6 min | ~4.4 min |
   | 99.999% | ~5.26 min | ~26 s |

   99.9% baseline for most SaaS; 99.99% for revenue-critical paths (checkout, auth); 99.999% only for
   life-critical/regulated systems.

🟦 If any rule is unmet — especially untested backups — list it in the Gap Report.

---

## Checklist
- [ ] 3-2-1 (→3-2-1-1-0) automated backups
- [ ] Restore drills run, timed, and verified — backups proven
- [ ] RTO/RPO defined per workload tier
- [ ] No single points of failure on critical paths (multi-AZ / replicas / failover)
- [ ] Liveness + readiness + startup probes; liveness dependency-free
- [ ] Graceful degradation under load
- [ ] Incident-response process with pre-defined severity levels
- [ ] Postmortems are blameless with tracked actions
- [ ] Independent status page
- [ ] Uptime target matched to business impact (not over-promised)

---

## Stack note
Default (from STACK.md): Sentry feeds incident detection; hosting provider (Vercel/Railway) and DB
(Supabase/Postgres) determine backup + multi-AZ options. CROSS-01 compliance depends on rule 2
(proven restores).

## Open questions for the founder (fill in per project)
- What RTO/RPO does each system actually need (and what will shrinking them cost)?
- What uptime are we committing to customers, if any (SLA)?
- Who is on the incident-response path, and where does the status page live?
