# TROUBLESHOOTING — when something goes wrong (plain-language fixes)

Problems are listed by how early you'll likely meet them. Each has the symptom, the fix, and —
where the fix is a conversation — the exact words to paste.

---

## 1. Windows blocks the new-project command (the most common first-run failure)

**Symptom:** you run `new-project.ps1` and get red text like *"…cannot be loaded because running
scripts is disabled on this system"* or mentioning *"execution policy."*

**What it means:** Windows ships with a safety setting that blocks downloaded scripts. Sensible
default; you just need to allow scripts for your own account.

**Fix:** in the same PowerShell window, run:

```powershell
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
```

Answer `Y` if asked, then run the new-project command again. One-time fix. (`RemoteSigned` means
"run local scripts; require signatures on downloaded ones" — if the script still won't run because
it arrived inside a downloaded ZIP, also run: `Unblock-File "C:\path\to\claude-build-framework\scripts\new-project.ps1"`.)

## 2. "ERROR: … already exists"

The script refuses to overwrite an existing folder — deliberately. Pick a new name, or delete the
old folder yourself first if it was a false start.

## 3. "ERROR: framework CLAUDE.md not found"

The script can't find the framework because the folder was moved or the path was mistyped. Check
the path in your command points at the folder that contains `CLAUDE.md` and `scripts\`. If you
moved the framework after creating projects, either move it back or update each project's
`CLAUDE.md` framework path.

## 4. The AI starts coding without documents or mockups

**Symptom:** you asked for a feature and it's already writing files, no PRD, no mockups.

**Paste:** *"Pre-coding gate. Stop. Which gate documents are complete, which are missing? Follow
CLAUDE.md Section 1b."* If it keeps drifting in later sessions, start each session with:
*"Start the session properly."*

## 5. The AI agrees with everything you say

**Symptom:** every idea is accepted, nothing gets challenged.

**Paste:** *"You're drifting from the honest-collaborator rule (CLAUDE.md Section 11). Re-evaluate
my last three requests critically and tell me which ones deserve pushback."*

## 6. The AI says it's done but you're not sure

**Paste:** *"Certify against the Definition of Done, item by item, and show me the evidence for
each item. Unmet items go to techdebt.md — never ticked."* No evidence = not done. That's the rule,
and you're allowed to hold the line.

## 7. The session feels slow, rambling, or "full"

Long sessions accumulate history that gets re-read constantly. **Paste:** *"What's eating tokens
right now? Then compact the context, keeping the current task and open items."* Between unrelated
tasks, start a fresh session — cheaper and sharper. Also ask: *"Are we set up to be
token-efficient?"* (CLAUDE.md Section 17 makes the AI check and advise.)

## 8. Costs look higher than expected

**Paste:** *"Walk me through this month's costs by service and by feature (Layer 6 / CROSS-03),
and tell me the single biggest saving available."* If cost alerts were never set up, that's a Gap
Report item — say: *"Give me the Gap Report."*

## 9. Git asks who you are, or the first commit fails

**Symptom:** messages about `user.name` / `user.email` during project creation.

**Fix:** run these two lines once (your name and email, used only to label your own history):

```
git config --global user.name "Your Name"
git config --global user.email "you@example.com"
```

Then in the project folder: *"Initialise git and make the first commit."*

## 10. A session "forgot" everything from last time

Sessions don't share memory — the PROJECT DOCS are the memory. If a session seems lost,
**paste:** *"Start the session properly — re-read the framework and the project docs, then tell me
where we left off per todo.md."* If todo.md is stale, that's the real problem: sessions must update
it at session end (CLAUDE.md Section 1). Say so.

## 11. The AI wants to add a plugin/connector/tool

It must first explain, in plain language, what the tool can see and do and where it comes from
(CLAUDE.md Section 15). Vague explanation = no. Approved additions get recorded in `decisions.md`.

## 12. The framework updated and your project is on an older version

Not an emergency — the project is pinned on purpose. **Paste:** *"The framework has moved past our
pinned version. Read its CHANGELOG, summarise what changed in plain language, and recommend
whether we adopt it (GOVERNANCE.md Section 4)."* You decide; nothing updates silently.

---

**Still stuck?** Describe the symptom to the AI and add: *"Diagnose the root cause before
proposing any fix, and label what you know versus what you're assuming."* That sentence prevents
most bad fixes.
