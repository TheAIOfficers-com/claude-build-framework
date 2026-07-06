# claude-best-practices.md — Token-saving & Claude Code operating practices

Tight, practical practices for building efficiently with Claude Code. (Applies when Claude is builder.)
Kept short on purpose — these are operating habits, not a manual.

---

## Token-saving (lower cost, faster, less context bloat)

1. **Model roles (CLAUDE.md Section 16).** Best available model = Planner/Architect/Auditor (Builder
   only when genuinely needed); second-best = Orchestrator and default Builder, routing routine work
   down to lighter models and escalating hard/security-critical/twice-failed work up. Don't run
   everything on the most expensive model.
1b. **Survey and advise (CLAUDE.md Section 17).** At project setup, check what token-saving
   capabilities actually exist in the environment at that time (brevity modes, model routing,
   compaction, on-demand loading, sub-agent isolation, caching) and recommend a lean setup to the
   founder with trade-offs. Availability changes — check, don't recite tool names from memory.
   Efficient is the default; the founder loosens it knowingly.
2. **Keep context lean.** Skills load only when needed (that's their point) — don't dump everything into
   `CLAUDE.md`. The global file is a *pointer*, not the whole framework. Let Claude read framework docs
   on demand rather than pre-loading all of them.
3. **Scope the task.** Give Claude the specific files/area to work on (the sweep already identifies
   these) rather than letting it scan the whole repo every time.
4. **Use sub-agents for heavy isolated work.** The audit loop and code review run in their own context
   windows — they don't bloat the main session.
5. **Clear/compact context between unrelated tasks** so stale context isn't re-sent each turn.
6. **Batch related changes** in one focused session rather than many tiny disconnected ones.
7. **For AI features in the product itself**, apply CROSS-02 + Layer 10: prompt caching, semantic
   caching, batching, and routing simple work to local/cheap models.

## Claude Code operating practices

8. **Let it read before it writes.** The sweep (Section 9 Step 1) is also a token/quality practice —
   grounded edits beat guessed ones that get redone.
9. **Small, reviewable changes.** Easier for a non-technical owner to verify, easier to roll back.
10. **Review the diff before committing.** Claude shows before/after — look at what changed before you
    accept it. This is your safety habit (see safety hooks).
11. **Use slash commands for anything repeatable** (sweep, Definition-of-Done check, phase close) so the
    standard steps run consistently and cheaply.
12. **Verify hooks and permissions early.** Know what Claude is allowed to do on your machine before you
    let it run unsupervised — never on production (per SETUP.md safety rules).
13. **Propose rule changes, don't auto-edit the framework** (GOVERNANCE.md) — keeps the framework clean
    and avoids re-litigating settled rules every session.

---

🟩 **One line for the founder:** spend the expensive model on thinking, the cheap model on typing, keep
context lean, and always look at the diff before you commit.
