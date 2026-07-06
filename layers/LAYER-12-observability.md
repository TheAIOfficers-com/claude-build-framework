# LAYER 12 — Error Tracking & Logs

**Status:** ✅ ACTIVE (enforced by Claude Code)
**Aim (non-negotiable):** Problems are detected, recorded, and diagnosable after the fact — and no
PII or secrets ever leak into logs.

---

## FOR THE FOUNDER — what this layer is

Logs are how your software explains itself at 3 a.m. when something's wrong. Two rules make them
priceless instead of useless: write them as structured data (so you can query "how many failed
payments in the last hour?" instantly) and stamp every related log line with the same "correlation ID"
so you can trace one customer's request across your whole system. Critically, **never let personal
data or passwords into logs** — logs get copied everywhere and are a common source of leaks and fines.
"SLOs" turn reliability into a budget: as long as you're meeting your target, ship fast; when you're
burning the budget, slow down and fix things.

---

## FOR CLAUDE CODE — rules to enforce

1. **Structured JSON logs** with a stable shared schema. Required on every entry: ISO-8601 UTC
   timestamp, level, service name, environment, version, event name, and a correlation/trace ID.
   Useful: `tenant_id`, internal `user_id`, `duration_ms`, structured error details.
2. **Consistent log levels** — DEBUG (dev only), INFO (events), WARN (risk), ERROR (failures), FATAL
   (shutdown). Don't ship DEBUG to production (cost and noise).
3. **Never log PII or secrets** — no passwords, tokens, API keys, cookies, full payment data, emails,
   or personal data. Redact at the logging layer using an allowlist, not by hoping developers
   remember. (GDPR/PCI/HIPAA requirement — CROSS-01.) Log opaque internal IDs instead.
4. **Correlation IDs** — generate at the edge (accept a valid incoming `traceparent`/`X-Request-Id`
   or create one) and propagate through every service call and async job, so one request can be
   reconstructed end-to-end.
5. **Error tracking** — capture exceptions with context (e.g. Sentry); errors are visible, not silent.
   Error handling returns useful messages to monitoring, not stack traces to users (Layer 2).
6. **Distributed tracing** — adopt OpenTelemetry-style tracing to follow a request across services and
   pinpoint latency/failures.
7. **Health metrics** — RED method (Rate, Errors, Duration) for request-driven services; USE method
   (Utilization, Saturation, Errors) for resources. Report latency as percentiles (p95/p99), never
   averages.
8. **Actionable, severity-rated alerts** — avoid alert fatigue; alert on metric/SLO burn rate over raw
   log pattern-matching. Page humans only for actionable, user-impacting issues.
9. **SLIs / SLOs / error budget** — define SLIs (e.g. % requests under 300ms), SLOs (e.g. 99.9%), and
   error budget (100% − SLO). Use the budget to govern release velocity: healthy → ship; depleted →
   freeze and fix (Google SRE).
10. **Per-user/token consumption logging** — the same data Layer 9 rate limiting and Layer 6 cost
   control depend on; for AI builds, log cost per request.
11. **AI-agent observability** — for agentic builds, trace agent steps, tool calls, and model routing
   (e.g. Phoenix, self-hosted, per REF-02) so behaviour can be inspected. (Supports CROSS-02 evals.)
12. **Deployment health signals** — expose error-rate metrics that Layer 5 canary deployments read to
   auto-promote vs auto-rollback.
13. **Tiered log retention** — set retention by log type and compliance need; sample high-volume
   low-value logs to control cost.

🟦 If any rule is unmet — especially PII in logs — list it in the Gap Report.

---

## Checklist
- [ ] Structured JSON logs with required schema fields + correlation ID
- [ ] Log levels used consistently; no DEBUG in prod
- [ ] No PII/secrets in logs (redaction by allowlist at the logging layer)
- [ ] Correlation IDs generated at edge and propagated everywhere
- [ ] Exceptions captured with context; no stack traces to users
- [ ] Distributed tracing in place
- [ ] RED/USE metrics; latency as p95/p99
- [ ] Alerts actionable + severity-rated; alert on SLO burn rate
- [ ] SLIs/SLOs/error budget defined and govern release velocity
- [ ] Per-user (and per-request cost for AI) consumption logged
- [ ] AI-agent steps/tool-calls/routing traced (agentic builds)
- [ ] Canary-readable error-rate signals exposed (unblocks Layer 5)
- [ ] Tiered log retention to control cost

---

## Stack note
Default (from STACK.md + REF-02): **Sentry** (error tracking), **PostHog** (product analytics),
**Phoenix self-hosted** (AI-agent observability). This layer unblocks Layer 5 (canary needs
error-rate signals) and supplies Layers 9 and 6.

## Open questions for the founder (fill in per project)
- What are the key SLIs/SLOs per product (latency, error rate, availability)?
- What log retention does compliance require, and what's the cost ceiling?
- Who is on the alert/on-call path, and what is genuinely page-worthy?
