# LAYER 03 — Database & Storage

**Status:** ✅ ACTIVE (enforced by Claude Code)
**Aim (non-negotiable):** Data is correctly modelled, durable, consistent, and never silently lost
or corrupted. The database itself enforces integrity, not just the application.

---

## FOR THE FOUNDER — what this layer is

Your database is the company's memory; corruption or loss here is existential. "Migrations" are
version-controlled instructions for changing the database's shape — done carelessly, a single one can
lock your tables and take the whole product down (a real scenario: a 45-minute outage from adding an
index the wrong way on a 50-million-row table). The safe technique is small, additive, reversible
steps that work with both the old and new code at once. Let the database itself enforce rules (a
customer can't have two accounts with the same email) so an app bug can't quietly corrupt data. And
treat uploaded files as hostile until proven safe.

---

## FOR CLAUDE CODE — rules to enforce

1. **Normalize first, denormalize on evidence** — avoid duplicated data that can drift; denormalize
   only for a *measured* read-performance problem, and document the trade-off.
2. **Indexing strategy** — index columns used in `WHERE`, `JOIN`, `ORDER BY`, and always index
   foreign keys. Every index slows writes and costs storage — don't over-index. Use composite indexes
   for multi-column filters (column order matters), partial indexes for filtered subsets, covering
   indexes to satisfy a query from the index alone. (Cross-refs Layer 11 scale-safe queries.)
3. **Zero-downtime migrations (expand-contract)** — all schema changes via versioned, reviewed
   migration files in source control, each with a tested rollback. Every migration must be
   backward-compatible with the currently running code: add nullable column → backfill → switch code
   → enforce/clean up later. Never add `NOT NULL` in one step on a populated table. Build indexes
   without locking (`CREATE INDEX CONCURRENTLY` in Postgres); set statement timeouts. (Coordinates
   with Layer 7 deploys.)
4. **Transactions & isolation** — wrap multi-step writes in transactions; choose isolation level
   deliberately and document it where it matters (e.g. financial operations).
5. **Constraints as integrity** — enforce foreign-key, unique, and check constraints in the database,
   not only in app code. Constraints are the last line of defence against corrupt data.
6. **Audit columns & trail** — add `created_at` and `updated_at` to every table. For
   sensitive/regulated data, keep an append-only audit trail of who changed what and when. (Ties to
   CROSS-01 compliance.)
7. **Soft vs hard deletes** — prefer soft deletes (`deleted_at`) for recoverable/audit-relevant data;
   hard-delete when law or retention policy requires actual erasure (GDPR/DPDP — CROSS-01).
8. **Primary keys** — UUIDs (or random IDs) for anything exposed in URLs (avoid enumeration);
   sequential keys are compact/fast but guessable and leak volume.
9. **Connection management** — use a connection pool; never open unbounded connections. Cap pool size
   against the DB connection limit; route many instances through a pooler. (Detailed in Layer 11.)
10. **Query analysis & ORM pitfalls** — analyze slow queries with `EXPLAIN` before optimizing. Watch
   ORM traps: hidden N+1 queries, accidental full-table scans, loading whole objects when a few
   fields suffice.
11. **Object/file storage safety** — never trust uploads: validate content type and size, scan for
   malware, store in object storage (not the app server's disk), and serve via time-limited signed
   URLs, not public buckets.
12. **PII at rest & retention** — encrypt PII at rest (e.g. AES-256), minimize what you store, apply a
   retention/deletion schedule (CROSS-01).

🟦 If any rule is skipped, list it in the Gap Report.

---

## Checklist
- [ ] Schema normalized; any denormalization measured + documented
- [ ] Indexes on filter/sort/join columns + all FKs; not over-indexed
- [ ] Migrations versioned, reviewed, reversible, expand-contract (zero downtime)
- [ ] Multi-step writes in transactions; isolation chosen deliberately
- [ ] FK/unique/check constraints enforced in the DB
- [ ] created_at/updated_at everywhere; audit trail on sensitive data
- [ ] Soft deletes where recoverable; hard deletes where law requires
- [ ] UUIDs for URL-exposed IDs
- [ ] Connection pooling; pool size capped to DB limit
- [ ] Slow queries EXPLAINed; ORM N+1 / full-scans checked
- [ ] Uploads validated, malware-scanned, stored off-server, served via signed URLs
- [ ] PII encrypted at rest, minimized, on a retention schedule

---

## Stack note
Default (from STACK.md): **Supabase / Postgres** (relational). The framework's rules are Postgres-
shaped (pooling, RLS, indexing). REF-01 uses asyncpg/pgvector; REF-02 considers Qdrant/Chroma — pick
ONE vector store per project (see STACK.md), don't run several.

## Open questions for the founder (fill in per project)
- What data is PII/regulated, and what's its retention period?
- Any workload that doesn't fit Postgres (time-series, graph, edge)? (See STACK.md unbundling signals.)
- Does the product accept file uploads? If so, what types/sizes are allowed?
