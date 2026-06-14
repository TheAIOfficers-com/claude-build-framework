# REFERENCE ARCHITECTURE 02 — AI Agent Stack ("$0 AI Architecture", 2026)

**Type:** Reference architecture (a capability blueprint, used only when a build is an AI-agent system)
**Status:** ✅ ACTIVE (enforced by Claude Code) — kept **on record as an OPTION**, not a mandated default.
**Aim (non-negotiable):** When a build is an AI-agent system, there is a known blueprint for
orchestration, knowledge retrieval, model routing, tool use, and agent observability — favouring
self-hosted / low-cost components where they fit the ownership principle.

> **How to treat this:** an option to reach for when building agentic AI features (e.g. the CAIO
> Tracker's intelligence pipeline). Not every project uses all eight components; take what fits.

---

## FOR THE FOUNDER — what this is

A reference layout for an AI-agent application where most components are free/self-hostable. It is
organised as 8 numbered parts plus a cross-cutting observability layer. It overlaps your default
stack in places (Next.js, Vercel, Supabase) and adds agent-specific pieces your other docs don't
cover (orchestration, RAG, local LLMs).

---

## The 8 components

1. **Frontend layer** — routes user input. Next.js or Streamlit, on Vercel (free tier).
   (Streamlit is notable: fast Python data-app UIs — handy for internal tools / the CAIO Tracker.)
2. **Agent orchestrator** — "the system's brain," runs the end-to-end data flow.
   LangGraph or CrewAI.
3. **RAG pipeline** — for when the agent needs external knowledge:
   - Retrieval/planning source: Notion
   - Storage: Chroma
   - Vector DB: Qdrant (local)
   - A decision point — "Need external knowledge?" — routes YES → RAG, NO → straight to the LLM.
4. **LLM layer** — running locally: Ollama (Gemma), Llama 3.3 70B, Mistral Small. (See model
   strategy below — this is where the local stack lives.)
5. **Tool use via MCP** — agent uses Model Context Protocol to reach external tools (GitHub, Slack,
   databases, file systems).
6. **Code agent** — writes, debugs, generates code: Claude Code CLI, Aider.
7. **Data layer** — application state: SQLite, DuckDB, or Supabase (free tier).
   (DuckDB is notable for fast local analytics — relevant to your trading/backtesting work.)
8. **Deployment layer** — Docker, Cloudflare Workers, Hugging Face.

**Observability layer (cross-cutting in the diagram)** — Phoenix (self-hosted) watches the agent's
behaviour. → This seeds Layer 12; see note there.

---

## Model strategy (per founder direction)

🟩 **FOR THE FOUNDER** — your stated approach: **a stack of local models + a stack of cloud LLMs,
orchestrated by query complexity.** This is the same engine as model tiering in Layer 10 (rule 8),
extended to include local models as the cheapest tier:

- **Local tier** (Ollama / Llama / Mistral, self-hosted) — $0 inference, full data residency. Best
  for simple/medium tasks, privacy-sensitive data, and high volume where per-call cost matters.
- **Cloud tier** (Claude API and others) — for complex reasoning the local models can't match.
- **Orchestration by complexity** — a classifier routes each query: simple → local; complex → cloud.
  Same cache→batch→tier discipline, with "local" sitting below the cheapest cloud tier.

🟦 **FOR CLAUDE CODE** — when REF-02 is in use, implement model selection as a complexity-routed
ladder: local models first, escalating to cloud LLMs only when the task demands it. Keep the routing
logic and the per-tier quality evals from Layer 10 rule 8 (8a–8d). Data that must stay private should
prefer the local tier and never be sent to a cloud provider without an explicit decision. (Ties to
Layer 8 Section E and CROSS-01.)

---

## Relationship to the default stack & other docs

- **Overlaps STACK.md:** Next.js, Vercel, Supabase all appear in both — reuse, don't duplicate.
- **Vector DB difference:** this uses Qdrant/Chroma (local); STACK.md defaults to Pinecone, and
  REF-01 uses pgvector. Pick ONE vector store per project and record it; do not run three.
- **Model tiering:** extends Layer 10 rule 8 with a local tier (see model strategy above).
- **Observability:** Phoenix here partially seeds Layer 12.
- **Ownership fit:** local LLMs + self-hosted observability + Docker deployment align with the
  proprietary-ownership principle — this is why it is worth keeping on record.

---

## FOR CLAUDE CODE — rules to enforce (when REF-02 is in use)
1. Take only the components the project needs; do not adopt all 8 by default.
2. One vector store per project — reconcile Qdrant/Chroma vs Pinecone vs pgvector against STACK.md.
3. Model selection follows the local-first, complexity-routed ladder (above) with Layer 10 evals.
4. Private/sensitive data prefers the local model tier; cloud calls with such data need an explicit decision.
5. Agent behaviour is observable (Phoenix or the Layer 12 choice) — an agent you can't trace is a gap.

---

## Checklist (when building an AI-agent system)
- [ ] Only the needed components adopted (not all 8 by reflex)
- [ ] Single vector store chosen and recorded (no duplication across REF-01/REF-02/STACK)
- [ ] Model routing: local-first ladder, escalate to cloud by complexity, with per-tier evals
- [ ] Sensitive data confined to local tier unless explicitly cleared for cloud
- [ ] Agent observability in place (Phoenix / Layer 12)

---

## Open questions for the founder (fill in per project)
- Which orchestrator — LangGraph or CrewAI — for this build?
- Which single vector store, given REF-01 (pgvector), STACK.md (Pinecone), and this (Qdrant/Chroma)?
- Which local models will be hosted, and on what hardware (ties to Layer 6 compute)?
- Is Streamlit (fast Python UI) preferable to Next.js for internal tools like the CAIO Tracker?
