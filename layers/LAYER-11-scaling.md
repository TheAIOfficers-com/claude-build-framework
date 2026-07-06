# LAYER 11 — Load Balancing & Scaling

**Status:** ✅ ACTIVE (enforced by Claude Code)
**Aim (non-negotiable):** The system stays responsive as users grow from tens to thousands —
no "scaling cliff" where it works at 10 users, slows at 100, and dies at 1,000.

---

## FOR THE FOUNDER — what this layer is

Apps built quickly are usually written to *work*, not to *work at scale*. So they hit a cliff:
fine with a handful of users, slow with a crowd, dead under real load. The transcripts name the
exact failure modes and the cheap fixes:

- **Connection pooling** — every request opening its own database connection is like every
  customer demanding their own private cashier. The database has a limit; you hit it, the app dies.
  Pooling lets many requests share a small set of connections.
- **Queries that scale** — a query that is fast on 100 rows can take 30 seconds on 100,000 rows.
  Fast-at-small is not fast-at-large.
- **Async / background processing** — do not make a user wait while you send an email or build a
  report. Queue heavy work and do it in the background.
- **Load testing before launch** — simulate the crowd *before* real users arrive. "If it breaks
  in the test, fix it quietly. If it breaks in production, you lose customers loudly."

These are described as ~30-minute fixes each — cheap insurance against the most expensive kind of
surprise (launch day).

---

## FOR CLAUDE CODE — rules to enforce

The aim is met only when ALL of the following hold:

1. **Connection pooling** is enabled for the database. Requests must not each open a fresh
   unmanaged connection — running out of *connections* (not compute) causes timeouts that look like
   a broken app (e.g. 50 users, 20-connection limit → users 21–50 time out). Specifics:
   - **1a. Use the pooler** — on Supabase, use the built-in Supavisor pooler: switch the connection
     string from the direct port **5432** to the pooled port **6543**. (Self-hosted Postgres: use
     PgBouncer.) The pooler multiplexes hundreds of app connections into a handful of DB connections.
   - **1b. Transaction mode for serverless** — poolers have session mode (holds a connection for the
     whole client session) and transaction mode (releases it after every query). Serverless
     functions spin up/down constantly, so session mode exhausts connections in minutes. For
     serverless, **always use transaction mode.**
   - **1c. Set the pool-size math correctly** — set the client/ORM pool size (Prisma:
     `connection_limit` in the DB URL; Drizzle: `max` in pool config) so that
     **(connections per instance) × (number of instances) ≤ database connection limit.**
     Example: 10 × 3 = 30, with a plan allowing 32. If the math does not fit, you get timeouts
     under load.
2. **Queries are written to stay fast as data grows** — no unbounded `SELECT *`, targeted queries,
   and indexes on columns used to filter/sort/join. (Indexing detail also belongs to Layer 3 —
   cross-reference it.)
3. **Heavy or slow operations run asynchronously** — emails, report generation, exports, AI
   batch jobs, and other long tasks are queued and processed in the background, not in the
   request that the user is waiting on.
4. **Load testing is performed before launch** — use k6 or Artillery (both free) to simulate the
   expected concurrent users, identify the bottleneck, and fix it before release.
5. **Horizontal scaling readiness** — the app must not store critical state only in one server's
   memory in a way that prevents running multiple instances behind a load balancer.

If any of these is skipped, do NOT certify the build as production grade — list it in the Gap Report
along with the user-count at which it is likely to fail.

---

## Checklist (verify before calling this layer done)
- [ ] DB connection pooling enabled (Supabase Supavisor / PgBouncer)
- [ ] Pooled port used (Supabase 6543, not direct 5432)
- [ ] Transaction mode used for any serverless functions
- [ ] Pool-size math fits: (per-instance × instances) ≤ DB connection limit
- [ ] No unbounded SELECT *; queries targeted; needed indexes present
- [ ] Heavy operations (email, reports, exports, AI) run async / queued
- [ ] Load test run with k6 or Artillery at target concurrency; bottleneck fixed
- [ ] App can run as multiple instances (no critical in-memory-only state)

---


### Audited gaps (from research) — additional rules
6. **Horizontal vs vertical framework** — vertical (bigger machine) is the fast first step with a hard
   ceiling; horizontal (more instances behind a load balancer) is more complex but effectively
   unbounded and more resilient. Staged: scale up to clear the bottleneck, then make stateless and
   scale out.
7. **Stateless design (prerequisite for scaling out)** — no in-memory sessions or local-disk files;
   sessions in a shared cache/DB, files in object storage. Any instance handles any request;
   termination is graceful (health checks + connection draining).
8. **Database scaling progression** — vertical first → read replicas for read-heavy load (accept
   replication lag; read-after-write goes to primary) → caching → sharding only as last resort.
9. **Queue-based load leveling** — put bursty/expensive work on a queue, process with worker pools, so
   spikes don't crush the synchronous path. Workers idempotent and resumable. (Ties to Layer 2 async.)
10. **Autoscaling policy** — scale on demand-reflecting metrics (request rate, latency, queue depth —
   not just CPU). Pair scale-out with scale-in, use cooldowns to prevent flapping, cap max instances to
   bound cost, review regularly.

## Open questions for the founder (fill in per project)
- What is the realistic peak concurrent-user target for launch, and 6 months out?
- Is the database Supabase (pooling built in) or self-hosted (needs PgBouncer)?
- Which operations are heavy enough to push to background queues?
- What is the acceptable response time under peak load (e.g. under 1s)?
