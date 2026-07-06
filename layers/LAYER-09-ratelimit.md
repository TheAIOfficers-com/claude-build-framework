# LAYER 09 — Rate Limiting

**Status:** ✅ ACTIVE (enforced by Claude Code)
**Aim (non-negotiable):** No single user, bot, or mistake can overwhelm the system or run up a
runaway bill — limits sit between the public internet and anything expensive, enforced at the
gateway, not left to application code.

---

## FOR THE FOUNDER — what this layer is

If an AI endpoint is public, anyone with the URL can send it requests — and every request costs real
money. The transcript's nightmare: one bot, one loop, one weekend you're not watching, and a
four-figure bill lands on Monday. This layer is the set of gates that stop that. Three gates:

1. **API gateway in front of every AI endpoint** — a checkpoint (Kong, AWS API Gateway, Cloudflare
   API Shield) that authenticates *before* a request reaches your model. No valid API key → no
   request → no tokens burned. This is treated as infrastructure, not an optional add-on.
2. **Request validation at the gateway** — check payload size, reject oversized context windows,
   validate the input schema before it touches the model. A 100k-token prompt from a free user
   should never reach your most expensive model.
3. **Per-user spend tracking and caps** — tag every request with a user ID, log token use per user,
   and set daily/monthly caps per tier (e.g. free = small daily token allowance; pro = much higher).
   Crucially, **the gateway enforces the cap, not your application code** — so a bug in the app can't
   bypass it.

The principle: gateway, validation, spend caps — three layers between the internet and a big bill.

---

## FOR CLAUDE CODE — rules to enforce

The aim is met only when ALL of the following hold:

1. **API gateway on every public/expensive endpoint** — authentication happens at the gateway before
   the request reaches the model or other costly compute. No valid credential → rejected. (Kong /
   AWS API Gateway / Cloudflare API Shield, or equivalent.)
2. **Request validation at the gateway** — enforce max payload size, max context/token length, and
   input-schema validation before the request hits the model. Oversized or malformed requests are
   rejected at the edge, not after they cost money.
3. **Per-user identification & logging** — every request is tagged with a user ID; token/resource
   consumption is logged per user. (Ties to Layer 12 observability.)
4. **Per-tier spend/rate caps enforced at the gateway** — daily and monthly caps by user tier,
   enforced in infrastructure, NOT only in application code (so an app bug cannot bypass them).
5. **Standard rate limiting** — beyond AI cost, apply request-per-second / per-minute limits per
   user/IP to prevent abuse and denial-of-service against any endpoint.
6. **Runaway/loop protection** — caps must also catch a single user (or our own buggy code) looping
   on an expensive call. (Reinforces Layer 6 rule 4.)

If any AI/expensive endpoint is exposed without gateway auth, validation, and a hard spend cap, treat
it as a hard failure — this is a direct financial-risk exposure, not a soft gap.

---

## Checklist (verify before calling this layer done)
- [ ] API gateway authenticates before requests reach the model (no key → no request)
- [ ] Gateway validates payload size, context/token limits, and input schema
- [ ] Every request tagged with user ID; per-user consumption logged
- [ ] Daily + monthly spend/rate caps per tier, enforced at the gateway (not just app code)
- [ ] Per-user/IP request rate limits in place against abuse/DoS
- [ ] Runaway-loop protection on expensive calls (also Layer 6)

---


### Audited gaps (from research) — additional rules
7. **Algorithm choice** — token bucket (default for public APIs; allows controlled bursts), sliding
   window (smoother/fairer), fixed window (simplest but boundary-burst bugs). Many systems layer both.
8. **429 semantics** — on breach return HTTP 429 with `Retry-After` plus `RateLimit-Limit`/`-Remaining`/
   `-Reset` headers.
9. **Distributed limiting** — for multi-instance, enforce in a shared store (e.g. Redis) with atomic
   operations; decide fail-open vs fail-closed explicitly.
10. **Well-behaved clients** — on 429, back off with exponential backoff + jitter; without Retry-After,
   back off aggressively (avoid synchronized retry storms / thundering herd).
11. **Differentiate + roll out safely** — different limits for authenticated vs anonymous, paid vs
   free; roll out in logging-only mode first, then enforce.

## Cross-references
- **Layer 2 (APIs)** — the gateway sits in front of the API layer; design them together.
- **Layer 6 (Cloud & Compute)** — spend caps here and cost control there are the same defence against
  a runaway bill, from two sides.
- **Layer 12 (Observability)** — per-user token logging is also the data observability needs.
- **REF-01 (Voice calling)** — per-client outbound concurrency/volume caps depend on this layer.

---

## Open questions for the founder (fill in per project)
- Which gateway do we standardise on (Kong / AWS API Gateway / Cloudflare API Shield)?
- What are the user tiers, and the daily/monthly token (or cost) cap for each?
- What request-per-minute limit is reasonable per user/IP for this app?
- What should happen when a user hits their cap — hard block, queue, or upgrade prompt?
