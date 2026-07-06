# REFERENCE ARCHITECTURE 01 — Self-Hosted AI Voice Calling (Dograh pattern)

**Type:** Reference architecture (a capability blueprint, used only when a build needs AI voice calling)
**Status:** ✅ ACTIVE (enforced by Claude Code) — intended use confirmed: **outbound calling for TheAIOfficers.com consulting clients.**
**Aim (non-negotiable):** When a build needs AI phone/voice agents, it can be done self-hosted, with
data residency under our control and no per-minute SaaS lock-in — matching the proprietary-ownership
principle.

> **Intended use:** delivered as an outbound-calling ("outcalling") solution to consulting clients of
> TheAIOfficers.com. This is a client-facing deliverable, so the self-hosting and data-residency
> guarantees double as a selling point: clients own their stack and their call data, not a SaaS vendor.

---

## Why this is a reference architecture, not a layer

🟩 **FOR THE FOUNDER** — most docs in this framework apply to every build. Voice calling does not —
it is only relevant when a project actually makes or takes phone calls with an AI agent. So it lives
as a self-contained blueprint you pull in when needed, rather than a rule applied everywhere.

This pattern is built on **Dograh** — an open-source (BSD-2), self-hostable voice-agent platform,
positioned as an alternative to proprietary services like Vapi and Retell. It fits your core
principles directly: self-hosted, your-infra-your-rules data residency, bring-your-own models, and
₹0/minute AI billing (you pay only hardware + carrier, not a per-minute SaaS margin).

---

## The trade-off it solves (Dograh vs proprietary like Vapi/Retell)

| Dimension | Dograh (self-hosted OSS) | Proprietary SaaS |
|-----------|--------------------------|------------------|
| License | BSD 2-Clause (open source) | Proprietary |
| Self-hostable | Yes — one Docker command | SaaS only |
| Pricing | Free self-host; usage-based cloud | Per-minute SaaS |
| Bring your own LLM / STT / TTS | Yes, or use Dograh's stack | Only within their integrations |
| Source-level customization | Every line is yours to modify | Closed source |
| Data residency | Your infra, your rules | Their cloud |
| Vendor lock-in | None | Full |

🟩 The right-hand column is exactly what your principles reject. This is the voice equivalent of
owning your stack.

---

## Architecture (how a call flows)

**1. PSTN layer (how phone calls reach the system)** — choose one or more inbound paths:
   - Commercial number via a SIP line from an operator
   - Virtual number via a cloud SIP trunk (e.g. Vobiz)
   - GSM gateway with an inbuilt SIP server (hardware, for direct mobile-network calls)

**2. SIP protocol bridge** — connects whichever PSTN source(s) above into the platform.

**3. Dograh self-hosted server** — four internal components:
   - **SIP stack** — call setup
   - **Voice engine** — STT (speech→text) · TTS (text→speech) · LLM (the reasoning)
   - **Call manager** — routing and call state
   - **AI agent logic** — conversation flows and intents (built in the visual workflow builder)

**4. Billing** — ₹0/minute for the AI itself; you pay only hardware (ATA / GSM gateway / Linux
   server) and carrier charges.

---

## Technology stack (Dograh's own)

**Frontend**
- Next.js 15.3.3 (App Router), React 19.1.0
- @xyflow/react 12.9.2 — the visual workflow builder (drag-and-drop call flows)
- Zustand — state management
- Radix UI — accessible component primitives (supports Layer 1 accessibility aim)
- Tailwind CSS 4

**Backend**
- Python 3.12+ with FastAPI (async) — the API layer
- SQLAlchemy ORM with asyncpg — async Postgres access
- pgvector — vector similarity search (in Postgres)
- Redis via aioredis — caching and pub/sub
- Pipecat (as a Git submodule) — the real-time audio pipeline engine

🟩 **FOR THE FOUNDER — why this fits you well:** the backend is Python + Postgres (asyncpg/pgvector),
which matches both your trading work (Python) and your Supabase/Postgres default. pgvector means the
vector DB lives inside Postgres, so a voice build may not need a separate Pinecone.

---

## FOR CLAUDE CODE — rules to enforce (when a voice build is in scope)

1. **Self-hosted by default** — deploy Dograh on our own infrastructure (one Docker command); do not
   default to a per-minute proprietary SaaS, per the ownership principle.
2. **Data residency stays ours** — call data, transcripts, and recordings live on our infra. (Ties to
   Layer 8 Section E network isolation and CROSS-01 Compliance.)
3. **Bring-your-own models** — LLM/STT/TTS providers are swappable; do not hard-wire one vendor.
4. **PSTN path is an explicit choice** — record which inbound path (SIP line / SIP trunk / GSM
   gateway) the project uses; each has different hardware and carrier implications.
5. **The Postgres+pgvector overlap with the default stack** — reuse the project's Postgres rather than
   standing up a second datastore where possible; reconcile with STACK.md.

If a voice build skips self-hosting or sends call data to a third-party cloud, flag it — it breaks the
ownership and data-residency principles.

### Outbound-calling specifics (the TheAIOfficers.com use-case)

🟩 **FOR THE FOUNDER** — outbound ("we call them") raises issues inbound ("they call us") does not.
These are not in the source images but are essential for a client-facing outcalling product:

6. **Telecom compliance & consent** — outbound automated/AI calling is regulated and varies by
   country (India: TRAI/DND rules; US: TCPA; EU: GDPR + ePrivacy). Calling without consent or to
   registered do-not-call numbers carries legal and financial risk. Each client deployment must
   record which jurisdiction it operates in and honour consent and DND lists. (Ties to CROSS-01.)
7. **AI disclosure** — many jurisdictions require disclosing that the caller is an AI. Build this in
   rather than bolt it on.
8. **Outbound dialing path** — the SIP trunk / GSM gateway must support *originating* calls at the
   volume the client needs, and caller-ID must be correctly configured (spoofed or unregistered
   caller-ID gets blocked or flagged as spam).
9. **Rate / concurrency limits per client** — cap simultaneous outbound calls and per-day volume per
   client deployment. (Ties to Layer 9 rate limiting and Layer 6 cost control — carrier charges scale
   with call minutes.)
10. **Per-client isolation** — each consulting client's call data, recordings, and contact lists stay
    separate. If multi-tenant, enforce strict separation; if single-tenant per client, even cleaner.
    (Ties to Layer 8 RLS/isolation.)

If an outbound build lacks consent handling, DND honouring, or AI disclosure where the jurisdiction
requires it, treat it as a hard compliance failure, not a gap.

---

## Checklist (when voice calling is in scope)
- [ ] Dograh self-hosted on our infra (not proprietary per-minute SaaS)
- [ ] Call data / transcripts / recordings stay on our infrastructure
- [ ] LLM / STT / TTS providers are swappable, not vendor-locked
- [ ] PSTN inbound path chosen and recorded (SIP line / SIP trunk / GSM gateway)
- [ ] Postgres+pgvector reconciled with the project's main database (avoid duplication)
- [ ] Hardware accounted for (ATA / GSM gateway / Linux server) + carrier charges budgeted

## Outbound checklist (TheAIOfficers.com client deployments)
- [ ] Jurisdiction recorded; consent + do-not-call (DND) lists honoured
- [ ] AI-caller disclosure built in where required
- [ ] Outbound dialing path supports origination at needed volume; caller-ID correctly registered
- [ ] Per-client concurrency + daily volume caps set (ties to Layer 9 + Layer 6)
- [ ] Per-client data isolation (call data, recordings, contact lists kept separate)

---

## Open questions for the founder (fill in per project)
- Is voice calling actually needed for this project? (If no, this doc stays informational.)
- Which PSTN path(s) — commercial SIP line, cloud SIP trunk (Vobiz), or GSM gateway?
- Which LLM / STT / TTS providers, and are any subject to data-residency limits?
- Does this connect to the CAIO Tracker or trading work, or is it a separate product?
