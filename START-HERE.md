# START HERE — for owners with no technical background

This page takes you from "I have an idea" to "Claude Code is building it properly" — even if you
have never used a terminal before. Everything else in this repository is machinery that runs behind
these steps; you never need to read it unless you want to.

---

## What this framework does for you (30 seconds)

Ask an AI to build software and, by default, it builds a demo: a pretty screen, a database, and none
of the other eleven things a real product needs — security, backups, cost controls, an admin panel
you can actually use. This framework forces the AI to build all of it, to plan before coding, to get
its plans checked by a second AI, and to keep documents you can read — so you always know what
exists and what's missing, without ever reading code.

---

## Step 0 — Get the two things you need (one-time setup)

**1. Get this framework onto your computer.**

The no-tools way:
- On this repository's GitHub page, click the green **Code** button, then **Download ZIP**.
- Unzip it somewhere permanent you won't move it from — for example a folder called `Frameworks`
  in your home folder. (If you move it later, projects that point to it will lose the connection.)
- Remember the location. You'll paste it once in Step 1 and never think about it again.

If you already use git: `git clone https://github.com/TheAIOfficers-com/claude-build-framework.git`
into that same permanent spot. The git way is better long-term — updating the framework later is one
command (`git pull`) instead of re-downloading a ZIP.

**2. Install Claude Code.**

Follow the official instructions at https://claude.com/claude-code — there's a desktop app and a
terminal version. Either works. Sign in when it asks.

That's the whole setup. You never repeat Step 0.

## Step 1 — Create a project (one command)

Open a terminal in the folder where you want the project to live:
- **Windows:** open the folder in File Explorer, click the address bar, type `powershell`, press Enter.
- **Mac:** right-click the folder in Finder → Services → "New Terminal at Folder" (or open Terminal
  and drag the folder onto it).

Then run ONE of these, replacing the path with wherever you unzipped/cloned the framework in Step 0,
and `my-project-name` with your project's name (letters, numbers, and dashes only):

**Windows (PowerShell):**
```powershell
& "C:\path\to\claude-build-framework\scripts\new-project.ps1" -Name "my-project-name"
```

**Mac / Linux:**
```bash
bash /path/to/claude-build-framework/scripts/new-project.sh my-project-name
```

The command does everything technical for you: creates the project folder, copies in the planning
documents (empty, ready to fill), writes the project's rule file so every AI session automatically
follows this framework, records which framework version the project uses, and starts version history.

It ends with a green **DONE** and tells you the next step. If it prints an error instead, read it —
the messages are written in plain language (most common: the folder already exists).

**No terminal at all?** Fallback: create a folder yourself, copy the framework's
`project-docs-template` folder into it, rename the copy `project-docs`, and in Step 2 add one line
to the first prompt: "Also set up this project's CLAUDE.md wired to the framework at [paste the
framework's location], following GOVERNANCE.md."

## Step 2 — Fire it up (the first prompt)

Open Claude Code **inside the new project folder** (desktop app: File → Open Folder; terminal: type
`claude` while in the folder). Then paste this exactly:

> We are starting a new project under the build framework referenced in this project's CLAUDE.md.
> Nothing has been decided yet. Begin at the beginning: brainstorm the product with me under the
> honest-collaborator rule — push back on weak ideas. Then take me through the gate documents one
> at a time (PRD first), in plain language, asking me questions rather than assuming answers. Do
> not write, scaffold, or plan any code until the gate docs are complete and I have approved the
> mockups.

That single prompt puts the AI on rails: brainstorm → mockups (you approve) → planning docs →
audited plan → code. The framework forbids skipping ahead.

## Step 3 — Manage the build by reading, not coding

You steer with three habits:

1. **Read the Gap Report** at the end of each work session. It lists, in plain language, what's
   still missing. That's your radar.
2. **Approve things explicitly.** Mockups, plans, and finished phases wait for your OK. Once you
   approve, the work is committed to version history immediately.
3. **Check `project-docs/todo.md` and `techdebt.md`** whenever you want the truth. If the documents
   don't reflect reality, the work isn't done — that's a rule, and you're allowed to say so.

A feature or phase is only DONE when the builder certifies the `DEFINITION-OF-DONE.md` checklist and
you approve it. If you remember one lever as the owner, it's that one.

---

## Everyday phrases that work

Say these in any session — they trigger framework machinery:

| You say | What happens |
|---|---|
| "Start the session properly" | Re-reads the framework + project memory before doing anything |
| "Give me the Gap Report" | Plain-language list of what's missing across the 13 layers |
| "Is this phase done?" | Runs the Definition of Done checklist and shows you the result |
| "What did we decide about X?" | Checks `decisions.md` and answers with the recorded reason |
| "How much is this costing?" | Walks the cost controls and reports, with breakdown |
| "What tools are you using for this?" | Lists the skills/connectors in play — new ones need your OK (Section 15) |
| "Are we set up to be token-efficient?" | Checks what money-saving options exist right now and recommends a setup — you decide |
| "Propose that as a rule" | The lesson goes to `PROPOSED-RULES.md` for your approval — never straight into the rules |

## If something feels wrong

- Agreeing with everything → say: "You're drifting from the honest-collaborator rule."
- Wants to code before documents/mockups exist → say: "Pre-coding gate. Stop."
- Claims it's done but you're not sure → say: "Certify against the Definition of Done, item by
  item, and show me the evidence."
- Wants to add a new connector or plugin → it must explain, in plain language, what that tool can
  see and do before you say yes. If the explanation is vague, the answer is no.

## Keeping your AI bill small

AI usage is billed by the amount of text the AI reads and writes ("tokens"). The framework keeps
this lean automatically: it makes the AI read only what today's work needs, keep replies short by
default, hand routine typing to cheaper models, and reserve the expensive model for planning,
architecture, and review.

On top of that, when you start a project the AI is required to check what money-saving options
exist in your setup **at that moment** — options change over time, so it checks rather than
assumes — and recommend them to you in plain language, including any trade-off. You say yes or no.
Efficient is always the starting point; if you prefer fuller replies or a heavier setup, that's
your call to switch — you should never discover waste on a bill you didn't choose.

Two habits worth keeping: ask "Are we set up to be token-efficient?" at the start of a new
project, and if a session ever feels slow or bloated, ask "What's eating tokens right now?" —
the AI must name the cause and the fix.

## Keeping the framework up to date

Every change to these rules is recorded in `CHANGELOG.md` with a version number and the reason.
Each project remembers which version it was built under. When the framework moves ahead, the AI
summarises what changed in plain language and asks whether the project should adopt it — nothing
updates silently. (Details: `GOVERNANCE.md` Section 4.)

## For human builders / freelancers

Hiring someone? Send them to `ONBOARDING.md`. Their work passes through the same
Definition-of-Done gate — the framework doesn't care whether the builder is an AI or a person.
