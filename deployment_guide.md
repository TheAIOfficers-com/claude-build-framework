# DEPLOYMENT GUIDE — STANDING INSTRUCTIONS
> How to deploy the two instruction files so every model, in every environment, inherits them automatically. Do this once; after that, updates flow from a single canonical copy.

## The two files
| File | Size | Use |
|---|---|---|
| `standing_instructions.md` | Full doctrine (Tier 0 + Tier 1) | Canonical copy; Claude Code; repos |
| `standing_core.md` | Tier 0 only (~1 page) | Claude.ai projects; Cowork spaces; any tight-context executor |

---

## STEP 1 — Establish the canonical copy (do this first)

1. Commit `standing_instructions.md` to the root of your public repo `TheAIOfficers-com/claude-build-framework`, on the `main` branch.
2. Verify the raw URL opens in a browser:
   `https://raw.githubusercontent.com/TheAIOfficers-com/claude-build-framework/main/standing_instructions.md`
3. If you place it at a different path or branch, update the URL inside BOTH files (it appears in the header of each). The precedence clause only works if the URL is live and correct.
4. Bump the framework repo version (currently v1.4.0) so the addition is tracked.

**Rule from here on: edit only the canonical copy. Never edit a pasted or synced copy directly.**

---

## STEP 2 — Claude Code (all coding projects) — true auto mode

1. Open your global memory file: `C:\Users\rizwa\.claude\CLAUDE.md`
2. Save a local copy of `standing_instructions.md` somewhere stable, e.g.:
   `C:\Users\rizwa\.claude\standing_instructions.md`
3. Add this line near the top of the global CLAUDE.md:
   ```
   @standing_instructions.md
   ```
   (Imports are resolved relative to the CLAUDE.md file's own folder, so the plain filename works when both files sit in `.claude\`.)
4. Verify at your next Claude Code session: ask "summarize the four rules from your standing instructions." If it answers correctly, the import works. If not, check your installed version's import syntax — confirm before trusting.
5. **Refresh discipline:** whenever you edit the canonical GitHub copy, pull/copy it over the local `.claude\standing_instructions.md`. (Optional automation: add this copy step to your DocSync cron so it happens daily without you.)

Result: every Claude Code session, in every project, loads the full doctrine automatically.

---

## STEP 3 — Repos (optional, for agent/CI visibility)

If you want the file physically present in each active repo (so CI agents, Routines, or other tools can read it):

1. Add a step to `scripts/doc-sync.js` that fetches the canonical raw URL and commits it as `standing_instructions.md` to each target repo.
2. Because DocSync already runs daily on Railway, every repo copy self-updates within 24 hours of a canonical edit. Zero manual steps after setup.
3. STOP-trigger note: this touches DocSync (a live scheduled job) — plan it as its own approved chunk on staging first.

---

## STEP 4 — Claude.ai projects — paste Tier 0 once

For every Claude.ai project (this one, client projects, new ones):

1. Open the project → **Project settings / Instructions** (the "Set project instructions" field).
2. Paste the ENTIRE contents of `standing_core.md` at the TOP of the instructions field, above any project-specific instructions.
3. Below it, keep the project-specific block (e.g., SYSTEMS-INSTRUCTIONS-BLOCK.md content for client projects).
4. Order matters: core first, project-specific second. If they ever conflict, the core's own precedence clause tells the model the canonical URL wins.

Why only Tier 0 here: pasted instructions are static and count against every message's context. Tier 0 is small, stable (rarely needs re-pasting), and contains the fetch pointer so capable models pull the full live version themselves.

**Update path:** you only need to re-paste if Tier 0 itself changes — which should be rare by design. Tier 1 changes require nothing; models fetch those from GitHub.

---

## STEP 5 — Cowork spaces and other surfaces

Same pattern as Step 4: paste `standing_core.md` at the top of the space's instructions. Anywhere that accepts a file upload instead, upload `standing_instructions.md` (full version) as a project file AND paste Tier 0 in instructions — the paste guarantees it's always in context; the file gives deep-readers the rest.

---

## STEP 6 — Verify the whole chain (10 minutes, once)

1. **Claude Code:** new session → "What are your four rules?" → should recite Tier 0.
2. **Claude.ai project:** new chat in a project with the paste → same question → same answer.
3. **Precedence:** ask a web-enabled model in a project: "Fetch your canonical standing instructions and confirm they match your pasted copy." It should fetch the GitHub raw URL and compare.
4. **Behaviour spot-check:** give a small build task and watch for: written plan before code, no unasked deletions, staging-first language, and it addressing you by name.

---

## MAINTENANCE RULES (the part that keeps it in "auto mode")

1. **One edit point:** all changes go to the GitHub canonical copy only.
2. **Tier 0 is frozen by intent:** change it only for genuinely fundamental shifts. Everything evolving goes in Tier 1, which propagates automatically via fetch/DocSync.
3. **Version the header:** add a `> Version:` line to the canonical file and bump it on each edit, so any model can detect a stale copy instantly.
4. **Quarterly check:** open the raw URL, confirm it loads, confirm the version matches your latest edit. That's the entire ongoing maintenance burden.
