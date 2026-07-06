# The Build Framework

A complete rulebook for building production-grade software with Claude Code — written so a
non-technical owner can run real builds and verify the results without reading code.

Most AI-built apps are demos: a front end, a database, and nothing else. Real products need
thirteen layers — security, backups, cost control, deployment safety, an admin panel the owner can
actually use, and more. This framework makes the AI build all thirteen, plan before it codes, get
its plans audited by a second AI, and keep honest documents so you always know what exists and
what's missing.

## New here?

**Read [START-HERE.md](START-HERE.md).** It takes you from download to your first build in three
steps, with zero jargon. If you can unzip a file and paste a prompt, you can use this.

## What's inside

| Part | What it does |
|---|---|
| [CLAUDE.md](CLAUDE.md) | The master rulebook, loaded by every AI session — workflow, gates, conduct |
| [layers/](layers/) | The 13 engineering standards every build must meet |
| [cross-cutting/](cross-cutting/) | Compliance, AI reliability, and admin/operability rules that span all layers |
| [reference-architectures/](reference-architectures/) | Ready-made blueprints for specific capabilities (voice, agents, help desk) |
| [project-docs-template/](project-docs-template/) | The planning and memory documents every project carries |
| [claude-integration/](claude-integration/) | Ready-made Claude Code wiring — sub-agents, slash commands, safety hooks |
| [example-project/](example-project/) | A complete worked example — every planning document filled in and annotated |
| [TROUBLESHOOTING.md](TROUBLESHOOTING.md) | Plain-language fixes for the most common problems, first-run onward |
| [scripts/](scripts/) | One-command project creation (Windows and Mac/Linux) |
| [DEFINITION-OF-DONE.md](DEFINITION-OF-DONE.md) | The acceptance checklist — nothing is "done" until it passes |
| [GOVERNANCE.md](GOVERNANCE.md) | How the rules change (only with the owner's approval) and how versions work |
| [CHANGELOG.md](CHANGELOG.md) | Every change to the framework, with the reason |

## The workflow in one line

**SWEEP → MOCKUP → PLAN → AUDIT → IMPLEMENT** — read the real code first, draw it before building
it, plan on facts, have an independent reviewer check the plan, and only then build.

## For builders and freelancers

Start at [ONBOARDING.md](ONBOARDING.md). Work is accepted through the
[Definition of Done](DEFINITION-OF-DONE.md), whether it was built by an AI or by hand.

## License & contributions

Contributions welcome — read [CONTRIBUTING.md](CONTRIBUTING.md) first. Rules change only through
the review process in [GOVERNANCE.md](GOVERNANCE.md): every pull request is audited independently
and the owner makes the final merge decision.
