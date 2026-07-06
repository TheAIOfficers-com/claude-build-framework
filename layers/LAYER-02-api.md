# LAYER 02 — APIs & Backend Logic

**Status:** ✅ ACTIVE (enforced by Claude Code)
**Aim (non-negotiable):** A reliable, well-defined contract between the front end and the data, with
all business rules enforced server-side. The server re-checks everything; the client is never trusted.

---

## FOR THE FOUNDER — what this layer is

Your API is the contract between your app's front-end (and any partners) and your "brain" on the
server. Three things prevent expensive disasters: (1) errors that always look the same so problems
are diagnosable; (2) "idempotency keys" so a customer who loses signal mid-payment and retries isn't
charged twice; and (3) the iron rule that the server re-checks everything — because anyone can fake
what the browser or app sends. Start with one well-organized codebase (a "modular monolith"), not a
fleet of microservices: Amazon, Netflix, and Uber all started as monoliths and split later.
Microservices add distributed-systems complexity a small team rarely has capacity to manage; decompose
once you actually know where the boundaries are.

---

## FOR CLAUDE CODE — rules to enforce

1. **Resource modelling & status codes** — model resources as nouns with HTTP verbs (`GET /orders`,
   `POST /orders`), never verbs in URLs (`/createOrder`). Use correct codes: 200/201/204 success,
   400 validation, 401 unauthenticated, 403 unauthorized, 404 missing, 409 conflict, 422 semantic
   error, 429 rate-limited, 5xx server.
2. **Standardised errors (RFC 9457 Problem Details)** — return all errors as `application/problem+json`
   with `type`, `title`, `status`, `detail`, `instance`. (RFC 9457 obsoletes RFC 7807; identical
   structure.) The HTTP status MUST match the `status` member. Never leak stack traces or internal
   details in error bodies (an attack vector).
3. **Idempotency** — every mutating endpoint must be safely retryable. `PUT`/`DELETE` idempotent by
   design. For `POST` that creates resources or moves money, require a client-supplied
   `Idempotency-Key` header; store the first response and return it on replay within a dedup window
   (the window must exceed your p99 client retry timeout).
4. **Pagination** — never return unbounded lists. Use cursor (keyset) pagination for large or
   frequently-changing datasets; offset pagination only for small, stable data (it duplicates/skips
   under concurrent inserts and degrades at depth).
5. **Versioning** — version from day one (URI versioning, e.g. `/v1/`). Once published, never make
   breaking changes to a version: add optional fields, never remove or repurpose existing ones.
   Breaking behaviour goes only in a new version.
6. **Server-side validation & business logic (NEVER TRUST THE CLIENT)** — validate all input
   server-side and enforce all business rules server-side regardless of client checks. Treat
   client-side validation as UX only. Re-verify authorization and ownership on every request.
7. **OpenAPI contract** — define the API as an OpenAPI spec and treat it as the source of truth; keep
   examples, tests, and docs in sync to prevent drift.
8. **Webhooks** — sign outbound webhooks (HMAC-SHA256 over a shared secret) with a timestamp and
   event ID. Retry with exponential backoff + jitter (e.g. 1s, 2s, 4s… capped at 6–12h, total window
   1–3 days). Add a circuit breaker for persistently failing endpoints and a dead-letter queue for
   exhausted retries. Consumers dedupe by event ID (delivery is at-least-once).
9. **Timeouts & circuit breakers** — set explicit timeouts on every outbound call; wrap unreliable
   dependencies in circuit breakers so one slow dependency can't exhaust threads/connections
   (cascading failure).
10. **Eliminate N+1 queries** — eager-load/batch related data. (Cross-refs Layer 3 + Layer 11.)
11. **Async work off the request path** — run long work as background jobs; design jobs to be
   idempotent and resumable. (Cross-refs Layer 11 queue-based load leveling.)

🟦 If any rule is skipped for speed, list it in the Gap Report.

---

## Checklist
- [ ] Noun-based resources, correct HTTP status codes
- [ ] All errors in RFC 9457 Problem Details format; no stack traces leaked
- [ ] Idempotency-Key on money/creation POSTs; PUT/DELETE idempotent
- [ ] Every collection paginated (cursor for large/changing data)
- [ ] API versioned from day one; no breaking changes within a version
- [ ] All input + business logic validated server-side; authz re-checked per request
- [ ] OpenAPI spec is the source of truth, kept in sync
- [ ] Webhooks signed, retried with backoff+jitter, dead-lettered; consumers dedupe
- [ ] Timeouts + circuit breakers on outbound calls
- [ ] No N+1 query patterns
- [ ] Long work runs as idempotent background jobs

---

## Stack note
Default (from STACK.md / REF docs): **Python + FastAPI (async)** is the likely API style, matching
REF-01 (Dograh) and your Python work. An **API gateway** (Layer 9) sits in front of this layer for
auth, validation, and rate limiting — design them together.

## Open questions for the founder (fill in per project)
- Is the API public/partner-facing (needs strict versioning + OpenAPI) or internal only?
- Any money-movement or create endpoints that must be idempotent (payments, orders)?
- Are outbound webhooks part of the product? If so, who consumes them?
