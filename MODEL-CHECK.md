# MODEL-CHECK.md — the founder confirms which model does which job

🟩 **FOR THE FOUNDER** — AI models change every few months, so this framework never fixes model
names in its rules. Instead, Claude asks you four short questions, each with its recommendation and
the trade-off in plain language, and records your answers in the project. Nothing about models is
ever set without your answer. Say **"check my models"** in any session to run it.

🟦 **FOR CLAUDE CODE — when to run it**

Run the model check:
1. at project setup (the `new-project` script points here when no models were given);
2. when a new model is released or one is retired;
3. when usage limits start blocking work (a model out of credits mid-week);
4. whenever the founder asks ("check my models").

**Never** change a project's model routing outside this check.

## Step 1 — Check what exists today (never from memory)

List the models available **right now**: the tool's official docs and the session's own model list.
Rank them best → lightest. State the source and the date. If you cannot verify, say so and stop: no
recommendations from memory (Section 17 rule 1).

## Step 2 — Ask the four questions

Ask one question per role. Use the session's question tool if it has one, otherwise ask in chat.
Put the recommendation first, marked **(Recommended)**. Give every option a one-line trade-off in
plain language: cost, quality, and the risk of running out of credits.

| # | Question | Default recommendation (by rank) |
|---|----------|----------------------------------|
| Q1 | Who builds day-to-day (the main session)? | Section 16: the second-best model. If usage limits are biting, a cheaper model plus an advisor (Section 16 rule 7). |
| Q2 | Who advises the builder (before an approach, on repeated errors, before "done")? | A model stronger than the builder, where the tool offers an advisor feature. "No advisor" is an option. |
| Q3 | Who plans and audits? | The best model. Fallback when it is out of credits: a fresh agent on the next-best model. |
| Q4 | Who searches and maps the code? | The lightest adequate model. On an indexed repo, the code-graph tool comes first (Section 17 rule 10). |

## Step 3 — Record the answers (only what the founder chose)

1. If the builder or advisor answer differs from what is set, write it to `.claude/settings.json`
   in the project. Use the tool's settings keys for the main model and the advisor, and verify the
   key names in the tool's current docs (Claude Code, checked 2026-10-21: `model` and `advisorModel`,
   https://code.claude.com/docs/en/advisor). Merge them into any existing settings; never overwrite
   other keys. The planner/auditor (Q3) and search (Q4) answers can't be enforced by settings; they
   live only in `CLAUDE.md` and are followed by the session.
2. In the project `CLAUDE.md`, replace any existing `## Model routing…` section (whatever its
   heading suffix, including the ones the `new-project` scripts write) with:

   ```
   ## Model routing (confirmed by <founder>, <YYYY-MM-DD>; recheck when models change)
   - Build: <model> · Advisor: <model or none> · Plan + audit: <model> (fallback: <model>) · Search: <model>
   - Source of the model list: <docs URL / session list>, checked <YYYY-MM-DD>
   ```
3. Commit on the staging branch, with the same audit gate as any change.

## Example (illustration only — model names go stale)

```
MODEL CHECK — my-project · <date>
Available today (checked in <docs>): Model-A (best) · Model-B · Model-C · Model-D (lightest)

Q1 Who builds day-to-day?   (founder reported weekly limits biting → cost override recommended)
   ● Model-C (Recommended): lowest cost per build hour; Model-B on call covers hard parts
   ○ Model-B: framework default (second-best); deeper, uses limits faster
   ○ Model-A: best quality; burns credits fastest
Q2 Advisor?   ● Model-B (Recommended)  ○ Model-A  ○ none
Q3 Plan + audit?   ● Model-A, fallback fresh Model-B when Model-A is out of credits (the only
   option the audit gate allows; asked so the founder sees and confirms it)
Q4 Search?   ● Model-D (Recommended), code-graph first where indexed  ○ same as builder
```

🟩 **One line for the founder:** models change; your decision about them is asked for, explained, and
written down — never assumed.
