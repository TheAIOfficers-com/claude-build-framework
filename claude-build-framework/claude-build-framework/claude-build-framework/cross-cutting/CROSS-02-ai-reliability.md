# CROSS-CUTTING 02 — AI Reliability & Quality

**Type:** Cross-cutting concern (applies to any build that puts AI/LLM output in front of users)
**Status:** ✅ ACTIVE (enforced by Claude Code)
**Aim (non-negotiable):** AI output is validated, measurable, and gracefully handled — users never
see raw garbage, hallucinations, or blank errors, and "did this prompt change actually help?" is
answered with data, not vibes.

---

## Why this is cross-cutting

🟩 **FOR THE FOUNDER** — traditional software is deterministic: same input, same output. AI is
probabilistic — the same prompt can return a great answer, a wrong answer, or a 10,000-word essay to
a yes/no question. That unpredictability touches many layers (the API that calls the model, testing,
deployment, monitoring), so it lives in its own doc rather than one layer. This is especially
relevant to you, since most of your products are AI-centric (CAIO Tracker, voice agents, agent stacks).

The three disciplines below turn "hope the model behaves" into "guarantee the user is protected."

---

## A. Output validation — never pipe raw model output to users

🟩 Most builders send the model's response straight to the screen. That works until the model
hallucinates a credit card number or over-runs a length limit. The fix is a **validate → retry →
degrade** wrapper around every user-facing AI call.

🟦 **FOR CLAUDE CODE — enforce:**
1. **Validate every AI response before it reaches the user.** Check: does it match the expected
   schema/format? Is it within length/boundary limits? Does it contain prohibited content? If it
   fails any check, it does not pass through.
2. **Retry with feedback on failure** — don't just error out. Add the failure reason to the retry
   prompt ("your previous response exceeded 200 words; respond in under 200"). Give the model 2–3
   attempts to self-correct, no more.
3. **Degrade gracefully when retries fail** — fall back to a simpler model, a cached response, or a
   human handoff. The user always gets a usable experience. Never show a raw error or a blank screen.
4. Build this validate/retry/degrade wrapper **once and reuse it everywhere** an AI call is exposed.

(Ties to Layer 2 backend logic and Layer 1 error/empty states; the degrade step is the AI-specific
form of Layer 13 graceful degradation.)

## B. AI evaluation — make quality measurable

🟩 Eyeballing outputs ("raw dogging it") works until it doesn't, usually at the worst time. Make AI
quality a measurable, automated thing.

🟦 **FOR CLAUDE CODE — enforce:**
5. **Model-as-judge** — send the AI's output through a separate evaluation prompt that scores it on
   defined criteria (accuracy, tone, safety, schema compliance) with pass/fail thresholds. Run these
   evals in the CI pipeline on every push (ties to Layer 7), so AI QA is automated, not manual.
6. **Failure-driven test suite** — every time a user reports a bad response, add that input to the
   eval suite with its expected quality score. Over time this becomes a regression suite of *real*
   edge cases, not synthetic ones.
7. **Version comparison** — run the same inputs across different models and prompt versions to
   quantify whether a change actually improved quality. Data over vibes. (This is the measurement
   half of Layer 10's model-tiering eval gate — same discipline.)

## C. AI deploy checklist — the pre-launch safety net

🟩 For an AI build, certain checks must pass before every deploy. ~15 minutes; the difference
between a launch and a fire drill.

🟦 **FOR CLAUDE CODE — verify before any AI build deploy:**
8. **Safety nets:** env vars loaded from the secrets manager (not hard-coded — Layer 8); model
   fallback chain configured (primary down → backup automatically); token limits and cost caps set
   so a prompt injection or runaway loop can't drain the account overnight (Layer 9 + Layer 6).
9. **Outputs:** output-validation layer active (section A); error handling sends useful messages to
   monitoring, not stack traces to users (Layer 12); CORS and rate limiting configured and tested
   under load (Layer 9).
10. **Rollback:** rollback plan documented, tested, and accessible; revert to previous version in
   under ~2 minutes (Layer 5 + Layer 7); deploy rehearsed in staging with production-equivalent
   traffic; logging captures latency, error rates, and cost per request (Layer 12).

---

## Checklist
- [ ] Every user-facing AI call wrapped in validate → retry (2–3x, with feedback) → degrade
- [ ] No raw model output or raw errors ever reach the user
- [ ] Model-as-judge evals run in CI on every push, with pass/fail thresholds
- [ ] Failure-driven regression suite growing from real bad outputs
- [ ] Prompt/model changes compared on the same inputs before adoption
- [ ] AI deploy checklist (safety nets / outputs / rollback) run before each release
- [ ] Model fallback chain configured (primary → backup)

---

## Cross-references
- **Layer 2 (APIs)** — the validation wrapper lives in backend logic.
- **Layer 5 / 7 (Deploy / CI)** — evals run in CI; deploy checklist gates releases.
- **Layer 6 / 9 (Cost / Rate limiting)** — token/cost caps and fallback prevent runaway spend.
- **Layer 10 (Model tiering)** — eval discipline is shared; degrade step can drop to a cheaper tier.
- **Layer 12 (Observability)** — per-request latency/error/cost logging feeds evals and alerts.
- **Layer 13 (Recovery)** — graceful degradation is the same principle, AI-specific.

---

## Open questions for the founder (fill in per project)
- What are the validation criteria per AI feature (schema, length, prohibited content)?
- What is the fallback chain — which simpler model or cached/human path on failure?
- Where do eval results live, and who reviews regressions before a prompt ships?
