# LAYER 10 — Caching & CDN

**Status:** ✅ ACTIVE (enforced by Claude Code)
**Aim (non-negotiable):** Responses are fast and load is reduced by computing or fetching
expensive things once and reusing the result, instead of redoing the work on every request.

---

## FOR THE FOUNDER — what this layer is

Caching means: if the same answer is going to be asked for 100 times, work it out once, keep the
answer, and hand out copies. It makes the app faster and cheaper at the same time. There are three
flavours that matter for us:

1. **Data caching** — store results of common database lookups so you do not hit the database
   again and again. (One transcript: an API call dropped from 800ms to 50ms and database load fell
   ~80% just by caching.)
2. **CDN caching** — keep copies of static files (images, scripts) on servers physically close to
   each user worldwide, so they load fast everywhere.
3. **AI provider caching & cost levers** — because you build AI products, this is its own
   money-saver: prompt caching, batch APIs, and model tiering can cut AI bills 70-90% with no
   drop in output quality.

The mental rule from the transcript: **cache anything that does not change every second.**

---

## FOR CLAUDE CODE — rules to enforce

The aim is met only when ALL of the following hold (apply the ones relevant to the build):

### A. Data / application caching
1. Identify read-heavy, slow-changing data and cache it (Redis, Upstash, or in-memory for small
   scale). Do not re-query the database for the same unchanged data repeatedly.
2. Every cached item has an explicit expiry (TTL) or invalidation rule. No cache that can serve
   stale data forever.
3. Caching is never applied to data that must always be real-time correct (e.g. balances,
   live inventory) unless invalidation is explicit and safe.
3b. **Cache the most expensive queries explicitly and invalidate them on write.** Heavy reads (e.g.
   an analytics dashboard doing many joins across several tables) should not recompute on every page
   load — cache the result and clear/refresh it when the underlying data changes. Think in three
   stacked tiers: **memory (API response cache) → edge (CDN) → database (expensive-query cache)**.
   Stacking all three speeds the app up without changing any business logic.

### B. CDN / static delivery
4. Static assets (images, JS, CSS, fonts) are served via a CDN with appropriate cache headers.
5. Cache-busting is in place for updated assets (versioned filenames or hashes) so users do not
   get stale files after a deploy.

### C. AI provider cost levers (apply order: CACHE → BATCH → TIER)
6. **Prompt caching** — if a system prompt or context repeats across requests, enable provider
   prompt caching so repeated tokens are billed at a fraction of the cost.
7. **Batch APIs** — route non-urgent workloads (nightly analysis, content pipelines, bulk
   processing) to batch endpoints for up to ~50% savings.
8. **Model tiering** — match model size to task complexity; do not use the most expensive model
   for simple tasks. Running every prompt through one expensive model is a billing problem, not a
   strategy. Implement tiering as follows:
   - **8a. Complexity classifier** — score each incoming request on token count, task type, and
     reasoning depth. Simple → lightweight model (Haiku class). Moderate → mid-tier (Sonnet class).
     Complex multi-step reasoning → heavy model (Opus class). This can be ~10 lines of code.
   - **8b. Route at the gateway layer** — the app sends every request to ONE endpoint; the gateway
     scores complexity and picks the model automatically. The user never knows which model answered.
   - **8c. Measure quality per tier weekly** — run an evaluation suite against each tier on a
     schedule. Only keep a request on the cheaper tier if its quality score matches the expensive
     tier. (Reported result: lightweight model handling ~85% of requests at equal quality = ~85%
     saving; one builder reported ~80% savings on a three-tier Anthropic setup with no quality drop.)
   - **8d. Never sacrifice output quality for the saving** — the eval gate in 8c is what protects
     quality. If a tier fails the eval, requests move back up to a higher tier.
9. **Semantic caching** — cache by the *meaning* of a query, not its exact wording. Users ask
   similar questions repeatedly. Before calling the expensive model, embed the query into a vector
   and check whether a semantically similar query was answered recently (e.g. last 24 hours); if so,
   reuse that answer. Tools: Upstash Vector, Pinecone. Typical hit rate 40–60% = that many fewer
   model calls. (This is distinct from prompt caching in rule 6, which caches repeated *context*.)
10. **Batch & debounce requests** — reduce per-request overhead:
   - **10a. Debounce** — do not fire a request on every keystroke; debounce (~300ms) so only the
     settled input triggers a call.
   - **10b. Batch** — when processing many items (e.g. documents), send them in one call instead of
     N separate calls. Per-token cost is the same, but per-request overhead drops sharply.

If any relevant lever is skipped, list it in the Gap Report with the estimated cost/perf impact.

---

## Checklist (verify before calling this layer done)
- [ ] Read-heavy slow-changing data is cached with explicit TTL/invalidation
- [ ] No caching of must-be-real-time data without safe invalidation
- [ ] Static assets served via CDN with correct cache headers
- [ ] Cache-busting on asset updates
- [ ] AI: prompt caching enabled where context repeats
- [ ] AI: non-urgent jobs routed to batch endpoints
- [ ] AI: models tiered by task complexity
- [ ] AI: complexity classifier scores requests (tokens / task type / reasoning depth)
- [ ] AI: routing happens at the gateway layer, transparent to the user
- [ ] AI: weekly eval suite run per tier; cheap tier kept only if quality matches
- [ ] AI: semantic caching checks for similar recent queries before calling the model (Upstash Vector / Pinecone)
- [ ] AI: requests debounced (~300ms), not fired per keystroke
- [ ] AI: bulk items batched into one call instead of many

---


### Audited gaps (from research) — additional rules
11. **Explicit invalidation strategy** — TTL expiry, event-based purge, or versioned keys; stale data
    is the classic caching bug.
12. **Cache stampede/dogpile protection** — when many requests recompute an expired value at once, use
    request coalescing/locking so only one worker regenerates, and/or proactive early refresh.
13. **stale-while-revalidate** (RFC 5861) — serve slightly-stale content instantly while refreshing in
    the background. Example: `Cache-Control: max-age=60, stale-while-revalidate=300`.
14. **HTTP caching headers per route** — `Cache-Control` (`max-age`, `no-store` for sensitive data,
    `private` vs public), `ETag`/`If-None-Match` for conditional revalidation, `must-revalidate` where
    freshness is critical. CDN honors origin cache-control.

## Open questions for the founder (fill in per project)
- What is the acceptable staleness for cached data (seconds? minutes?) per data type?
- Which CDN / cache provider do we standardise on (Cloudflare, Upstash, Redis)?
- Which AI provider(s) are in this build, so we map their specific caching/batch features?
