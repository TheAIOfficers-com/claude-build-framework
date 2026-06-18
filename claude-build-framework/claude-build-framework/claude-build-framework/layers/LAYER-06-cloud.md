# LAYER 06 — Cloud & Compute

**Status:** ✅ ACTIVE (enforced by Claude Code)
**Aim (non-negotiable):** The right amount of computing power is provisioned, actively managed, and
cost-controlled — so infrastructure spend does not quietly eat the business's margins.

---

## FOR THE FOUNDER — what this layer is

This is the actual computing power (servers, databases, functions) your app runs on, and crucially
how much you PAY for it. The transcript framed it bluntly: 200 users on a $10/month plan, but a
$900/month infrastructure bill, means half your revenue goes to the cloud provider. Margins decide
whether the business survives. Three moves keep this under control:

1. **Audit always-on resources** — a database running 24/7 still costs money at 3 AM when nobody is
   using it. If traffic is zero overnight, you are paying for idle compute. Many platforms can
   "scale to zero" (Neon pauses after 5 min idle; Railway scales to zero on hobby). Pay for compute
   when users are active, not when they sleep.
2. **Spend alerts at every layer** — every provider (Vercel, Supabase, OpenAI, AWS) supports billing
   alerts. Set them at 50%, 75%, 90% of budget, and a hard cap wherever possible. The horror story:
   one misconfigured function calling a top-tier model in a loop can burn $300 an hour.
3. **Right-size resources** — do not pay for a plan you do not use. If your database plan gives 8GB
   RAM but you use 1GB, downgrade. Scale up when metrics demand it, not on a hunch.

The summary: **audit, alert, right-size.** Margins determine whether you survive or bleed out slowly.

---

## FOR CLAUDE CODE — rules to enforce

### A. Cost control & right-sizing (DRAFTED — enforce when ACTIVE)
1. **Identify always-on resources** and check whether they can scale to zero or pause during idle
   periods. Flag any resource billed 24/7 that has predictable zero-traffic windows.
2. **Billing alerts must exist on every paid layer** — set at 50%, 75%, 90% of the agreed budget.
3. **Hard spend caps** must be configured wherever the provider supports them — especially on
   metered AI/API usage that can spiral in a loop.
4. **Loop/runaway protection on AI calls** — any code path that calls a paid model inside a loop or
   recursive flow must have an explicit call-count or cost ceiling. (Reinforces Layer 9 rate limiting.)
5. **Right-size to actual usage** — provision based on observed metrics, not guesses. Recommend
   downgrades when utilisation is well below the plan tier; scale up only when metrics justify it.
6. **No silent over-provisioning** — if the build provisions more than the workload needs, flag it
   in the Gap Report with the monthly cost difference.

### B. Compute architecture & provisioning (DRAFTED — from research)
7. **Choose compute by workload** — serverless for spiky, event-driven, short tasks (scale-to-zero,
   no idle cost); containers for long-running services needing portability/control; VMs for legacy or
   specialized workloads. Default new stateless services to containers or serverless.
8. **Regions close to users** — minimize latency; for global products consider multi-region with
   data-residency obligations in mind (CROSS-01 GDPR/DPDP, Layer 8 Section E).
9. **Manage vendor lock-in** — prefer open standards/portable abstractions where switching cost is
   high; accept managed-service lock-in only where operational savings justify it, and document the
   exit path. (Ties to STACK.md unbundling signals.)
10. **Resource tagging** — tag every resource (owner, environment, service, cost-center) so spend is
   attributable; alert on anomalies. (Supports Section A cost control.)

If any Section A rule is unmet, list it in the Gap Report with the monthly cost exposure.

---

## Checklist — Section A (cost control)
- [ ] Always-on resources audited; idle/scale-to-zero options applied where possible
- [ ] Billing alerts set at 50/75/90% on every paid layer
- [ ] Hard spend caps configured where supported
- [ ] AI calls in loops/recursion have a call-count or cost ceiling
- [ ] Resources right-sized to observed metrics (no paying for unused capacity)
- [ ] No silent over-provisioning

## Checklist — Section B
- [ ] Compute type matched to workload (serverless / container / VM)
- [ ] Regions chosen for latency + data residency
- [ ] Vendor lock-in managed; exit paths documented
- [ ] All resources tagged for cost attribution

---

## Open questions for the founder (fill in per project)
- What is the monthly infrastructure budget for this project, and the per-user economics?
- Which providers are in play (so we map their specific scale-to-zero / alert / cap features)?
- What are the known zero-traffic windows (timezone of the user base)?
- Who should receive billing alerts, and at what thresholds?
