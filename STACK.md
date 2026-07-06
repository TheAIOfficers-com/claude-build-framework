# STACK.md — Tech Stack (default reference + per-project choices)

> Tools are chosen here; the layer aims in `CLAUDE.md` stay fixed regardless of what we pick.

🟩 **FOR THE FOUNDER** — this records *what* we build with. There are two parts:
1. **Recommended default stack** — a proven, mostly-free starting set. Adopt it as-is or override.
2. **This project's stack** — the actual choices for the current build (fill in per project).

🟦 **FOR CLAUDE CODE** — if a "this project" field is blank, fall back to the recommended default.
If neither is set for a production-critical decision, ask before assuming. Map each tool to the
layer(s) it serves so the rules in those layers apply concretely.

---

## 1. Recommended default stack

| Function | Tool | Cost | Serves layer(s) |
|----------|------|------|-----------------|
| AI coding | Claude | $20/mo | (build tool) |
| Backend (DB + API + auth) | Supabase | free tier | 2, 3, 4 |
| Auth (alternative/dedicated) | Clerk | free tier | 4 |
| Deployment / hosting | Vercel | free tier | 5 |
| Domain registration | Namecheap | ~$12/yr | 5 |
| DNS / CDN | Cloudflare | free tier | 5, 10 |
| Payments | Stripe | 2.9% per transaction | (feature) |
| Version control | GitHub | free | 7 |
| Transactional email | Resend | free tier | (feature) |
| Product analytics | PostHog | free tier | 12 (adjacent) |
| Error tracking | Sentry | free tier | 12 |
| Cache / Redis | Upstash | free tier | 10, 11 |
| Vector DB | Pinecone | free tier | 10 (semantic caching) |

🟩 Most of this is free at startup scale — the recurring costs are Claude ($20/mo), a domain
(~$12/yr), and Stripe's per-transaction fee. This matches the cost-discipline theme across the
layer rules (especially Layer 6 and Layer 10).

### Alternative tools & ecosystems (swap in per project)

The default stack above is one proven path, not the only one. These alternatives serve the same
layer aims with different trade-offs:

| Default tool | Alternative | When to prefer the alternative |
|--------------|-------------|--------------------------------|
| Vercel (Layer 5) | **Railway** | Always-on backend services, containers, or a hosted DB. Vercel is best for front-end/serverless (Next.js, edge); Railway suits long-running backends. Railway scales to zero on its hobby plan (cross-links to Layer 6 cost control). Some builds use both — Vercel front end + Railway backend. |
| Supabase ecosystem (2,3,4) | **Google Cloud + Firebase** | A whole alternative ecosystem — see note below. |

🟩 **FOR THE FOUNDER — Supabase vs the Google/Firebase ecosystem.** This is a bigger choice than a
single tool swap; it is choosing a *foundation family*. The two are philosophically different:

- **Supabase** = managed **PostgreSQL** (a relational/SQL database). Structured tables, rows, and
  relationships; strong row-level security; you can take your data and run because it is standard
  Postgres. Fits apps with structured, related data (most business apps — including the CAIO Tracker,
  which already assumes Postgres).
- **Firebase (Firestore)** = a **NoSQL document** database in Google's ecosystem. Stores flexible
  JSON-like documents, real-time sync out of the box, very fast to start, deep ties to Google Auth,
  Cloud Functions, and Google Cloud. Trade-off: less structured querying, weaker relational
  modelling, and more lock-in to Google.

🟦 **FOR CLAUDE CODE** — these ecosystems are mutually exclusive foundations; do not mix Supabase and
Firebase as the primary datastore in one build. If a project chooses Firebase/Google Cloud, the
database (Layer 3), API (Layer 2), and auth (Layer 4) rules must be written for the NoSQL/Firestore
model, NOT the Postgres model the current notes assume. Flag this so the right rule-set is used.

Practical guidance: **Supabase is the default** because your existing work (CAIO Tracker) assumes
relational Postgres, and most of the drafted rules (pooling, RLS, indexing) are Postgres-shaped.
Choose Firebase only for a project that genuinely wants real-time document sync and is happy inside
Google's ecosystem.


### When to outgrow the default (unbundling signals)

🟩 **FOR THE FOUNDER** — Supabase (and any all-in-one platform) is a great *starting* point, but
there's a moment when bundled infrastructure becomes the ceiling. Knowing when to leave is an
operator skill, not a failure. Three signals it's time to unbundle:

1. **Auth outgrows the built-in** — when you need SSO, custom claims, or complex multi-tenant
   permission logic, move auth to a dedicated identity layer (Auth0, Clerk, WorkOS). (Ties to the
   Supabase-vs-Clerk decision already flagged, and to Layer 4.)
2. **The database engine no longer fits the workload** — Supabase is Postgres, which is excellent
   for most apps. But if the workload is time-series, graph, or edge-first, you fight the
   architecture. Match the engine to the workload: e.g. Neon (serverless Postgres, scales to zero),
   Turso (SQLite at the edge), PlanetScale (MySQL, zero-downtime migrations). (Ties to Layer 3.)
3. **Storage, functions, and database need to scale independently** — when one bundled layer
   bottlenecks another, separate them and scale each on its own, connected via APIs.

🟦 **FOR CLAUDE CODE** — treat these as *triggers to reassess*, not reasons to over-engineer early.
The default stack stays the default until one of these signals actually appears in a project; then
record the change in section 2 and re-derive the affected layer rules.

### Decisions to make (flagged tensions)
- **Auth: Supabase vs Clerk.** Supabase already includes auth; Clerk is a dedicated auth product.
  Using both is redundant. Pick one per project: Supabase auth (fewer moving parts, one vendor) or
  Clerk (richer auth UX/features). Record the choice in section 2.
- **Foundation family: Supabase/Postgres vs Firebase/Google Cloud.** Relational vs NoSQL — decided
  per project, affects how Layers 2, 3, and 4 are written. Default is Supabase/Postgres.
- **Hosting: Vercel vs Railway (vs both).** Front-end/serverless vs always-on backend.
- **Layer 8 network isolation (Section E)** is NOT served by this stack — that high-security
  private-VPC pattern is a separate AWS-based architecture, used only when data-isolation is required
  (e.g. CAIO Tracker private intelligence). The default stack above is the standard SaaS path.

---

## 2. This project's stack (fill in per project)

| Decision | Choice | Notes |
|----------|--------|-------|
| Project name | _TBD_ | |
| Front-end | _TBD_ | |
| Backend / API | _TBD (default: Supabase)_ | |
| Database | _TBD (default: Supabase/Postgres)_ | |
| Auth | _TBD (choose: Supabase OR Clerk)_ | resolve the tension above |
| Hosting | _TBD (default: Vercel)_ | |
| DNS/CDN | _TBD (default: Cloudflare)_ | |
| Payments | _TBD (default: Stripe, if needed)_ | |
| Email | _TBD (default: Resend, if needed)_ | |
| CI/CD | _TBD (default: GitHub)_ | |
| Error tracking | _TBD (default: Sentry)_ | needed for Layer 5 canary monitoring |
| Cache | _TBD (default: Upstash)_ | |
| Vector DB | _TBD (default: Pinecone, if AI/semantic caching)_ | |
| Analytics | _TBD (default: PostHog)_ | |
