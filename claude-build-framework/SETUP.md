# SETUP.md — Activating the Repo & Claude Code

How to stand up this framework on GitHub, set up Claude Code, and bring in freelancers. Written for a
non-technical owner. Where a step uses the command line or install flow, do it with a technical person
on a screen-share the first time if unsure — after that it's routine.

> ⚠️ Install/version details change. The authoritative source is always **claude.com/download** and
> Anthropic's official docs. If anything here differs from the official page, trust the official page.

---

## PART 1 — Set up the GitHub repo (owner, once)

**1. Create a GitHub Organization (not just a personal account).**
github.com → profile → Settings → Organizations → "New organization" → free plan. Name it e.g.
`theaiofficers`. *Why an org:* clean add/remove of freelancers, access control, everything under the
business rather than a personal login.

**2. Create the framework repository.**
In the org → "New repository" → name `claude-build-framework` → **Private** → create. This is the home
for everything in this framework.

**3. Upload the framework files.**
On the repo page → "uploading an existing file" → drag in the whole `claude-build-framework` folder →
commit. The framework now lives on GitHub, versioned.

**4. Protect the main branch (this enforces governance technically).**
Repo → Settings → Branches → add a protection rule for `main` → require a pull request before merging.
*Why:* no one (including freelancers) can change code or rules without review. This makes the
propose→review→approve governance real, not just trust-based.

**5. Per-project repos (as you start each product).**
Each product gets its own **Private** repo in the org (e.g. `caio-tracker`). Copy the
`project-docs-template/` folder into it, renamed to `project-docs/`, so the project carries its own
memory documents.

---

## PART 2 — Set up Claude Code (owner)

**6. Prerequisites.**
- A **paid Claude plan** (Pro / Max / Team / Enterprise). The free Claude.ai plan does NOT include
  Claude Code.
- Install from the official page: **claude.com/download**.
  - **Recommended for a non-technical owner: the Claude Code DESKTOP APP** (macOS/Windows) — avoids the
    terminal.
  - The native installer (terminal) is the other official method; it needs no separate dependencies and
    auto-updates.

**7. Sign in.**
First launch opens your browser, walks you through Anthropic sign-in, and stores your login. You'll see
a "logged in" confirmation.

**8. Connect your repo (the key step that loads the framework automatically).**
Open your project folder (downloaded/cloned from GitHub) in Claude Code. Because **`CLAUDE.md` sits at
the repo root, Claude Code reads the entire framework automatically at the start of every session** —
no extra configuration. That is the whole point of the `CLAUDE.md` design.
- For the framework to apply to a *product* repo, make sure that repo's root has access to these rules
  — either copy `CLAUDE.md` (and the framework folders) in, add the framework as a git submodule, or
  use Claude Code's global memory so the rules load everywhere (see GOVERNANCE.md section 1 for the
  three options; start with the simplest).

**9. Pick your model.**
Use the strongest model for planning/architecture; switch to a lighter model (`/model` command) for
routine edits to stretch usage. This mirrors your own model-tiering rule (Layer 10).

---

## PART 3 — Bring in freelancers (owner)

You don't explain the framework verbally — you point them at the docs. Sequence:

1. **Sign first.** NDA + IP assignment (CONTRIBUTOR-GOVERNANCE.md §3–4) BEFORE any access.
2. **Add to the GitHub org** → People → Invite → grant access to ONLY the specific project repo (least
   privilege, CONTRIBUTOR-GOVERNANCE.md §2).
3. **Point them to `ONBOARDING.md`** — their front door; it tells them everything.
4. **State the mandate:** all work happens on the owner's GitHub, from commit one (CLAUDE.md §13).
5. **Acceptance:** their work is accepted only when they self-certify against `DEFINITION-OF-DONE.md`
   and the owner approves. (Later, an advanced LLM auto-checks the certification.)
6. **On completion:** accept via Definition of Done, regenerate `handover.md`, revoke their access,
   rotate any credentials they held (CONTRIBUTOR-GOVERNANCE.md §6).

---

## PART 4 — Critical safety rules (non-negotiable)

🟦 Claude Code (and similar AI builders) can run real commands on real systems and have direct
filesystem access. Documented cases exist of AI agents destroying data when given unsupervised access
to production. Therefore:
- **Never point an AI builder at a production database or live client system unsupervised.**
- Keep branch protection ON; nothing reaches production without a reviewed PR (Layer 7).
- Keep the human approval gates (Definition of Done, admin yes/no) ON.
- The danger only ever arises when someone bypasses these gates for speed. Don't.

---

## PART 5 — Recommended first move

Do PART 1 and PART 2 (about 30 minutes), then **run ONE small project through the framework yourself,
end to end, before bringing in freelancers.** You'll understand the loop you're asking them to follow —
which makes you much better at approving their work, and will surface the first real improvements to
the framework (file them via PROPOSED-RULES.md).

---

## Quick reference — what each core file is for
| File | For |
|------|-----|
| ONBOARDING.md | Any builder's starting point |
| CLAUDE.md | The master rules (loaded every session) |
| DEFINITION-OF-DONE.md | The acceptance gate |
| CONTRIBUTOR-GOVERNANCE.md | Freelancer access, IP, NDA, handoff |
| GOVERNANCE.md | Where the framework lives + how rules change |
| STACK.md | Default tech stack + when to deviate |
| layers/ | The 13 engineering standards |
| cross-cutting/ | Compliance, AI reliability, admin/operability |
| reference-architectures/ | Voice, agent stack, help desk blueprints |
| project-docs-template/ | Copied into each project as project-docs/ |
