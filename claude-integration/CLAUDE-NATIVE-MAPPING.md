# CLAUDE-NATIVE-MAPPING.md — Framework → Claude Code's native structure

How each part of the framework maps onto Claude Code's native `.claude/` project structure, so the
rules become executable behavior, not just text. (Applies only when Claude Code is the builder.)

---

## Claude Code's native structure (reference)

```
project-root/
├── CLAUDE.md              # loaded at session start: project overview, stack, conventions
├── CLAUDE.local.md        # personal overrides, not committed
├── .mcp.json              # MCP integration configs (GitHub, DBs, Slack…), shared via git
└── .claude/
    ├── settings.json      # permissions, tool access, model selection, hooks
    ├── settings.local.json# personal setting overrides
    ├── rules/             # modular rule files by topic (style, testing, API…)
    ├── commands/          # custom slash commands for repeatable workflows
    ├── skills/            # auto-triggered capabilities, loaded only when needed
    ├── agents/            # specialized sub-agents with isolated context
    └── hooks/             # event-driven scripts (pre/post tool use) — validate, block unsafe ops
```

---

## The mapping (framework → native)

| Framework piece | Native home | What it does when wired |
|-----------------|-------------|--------------------------|
| Framework `CLAUDE.md` (master rules) | Project `CLAUDE.md` + global `~/.claude/CLAUDE.md` pointer | Loaded every session; routes to the full framework |
| The 13 `layers/` + cross-cutting | `.claude/rules/` (as references) | Rules Claude applies while coding |
| **Audit loop** (Section 9 Step 4) | `.claude/agents/` — a `plan-auditor` sub-agent | Independent reviewer with isolated context reviews plans before implementation |
| **Code review / DoD checks** | `.claude/agents/` — `code-reviewer`, `security-auditor` | Specialized review sub-agents (maps to Layer 7/8 + Definition of Done) |
| **Repeatable workflows** (sweep, gate check, phase-complete) | `.claude/commands/` — slash commands | One command runs a standard workflow (e.g. `/sweep`, `/dod-check`) |
| **Project-specific abilities** | `.claude/skills/` | Loaded on demand only when the task needs them (keeps context light) |
| **External integrations** (chosen per project) | `.mcp.json` | Connects GitHub, databases, etc. — decided at planning (Section 9 Step 3) |
| **Safety hooks** (block unsafe ops, validate) | `.claude/hooks/` | Pre/post-tool scripts; e.g. block writes to production, run lint/format, prevent secret commits |
| **Permissions & model choice** | `.claude/settings.json` | Controls what Claude may do; sets model tiering (Layer 10) |

---

## Why this matters (the wiring insight)

🟩 Without this mapping, the framework is a library Claude *reads*. With it, the framework becomes
behavior Claude *runs*: the audit loop is an actual sub-agent, the safety rules are actual hooks that
block dangerous actions, and the model-tiering rule is actual settings. This is the difference between
"Claude was told the rules" and "Claude operates inside the rules."

🟦 **FOR CLAUDE CODE — when setting up a Claude-built project:**
1. Copy `_dot-claude-template/` into the project as `.claude/` and adapt it.
2. Set the project `CLAUDE.md` to reference the framework (per the global pointer).
3. Decide and configure `.mcp.json` integrations for this project (Section 9 Step 3).
4. Wire the `plan-auditor` sub-agent so the Section 9 audit loop runs natively (use a different model
   where possible — e.g. Codex — for genuine independence).
5. Wire safety hooks (block production writes, secret-commit prevention, lint/format).
6. Verify: trigger each (run a command, invoke the auditor, trip a hook) BEFORE real building.

> Note: hooks run shell scripts and settings control permissions — these affect what Claude can do on
> your machine. A non-technical owner should have Claude Code set these up and DEMONSTRATE they work,
> rather than copy-paste them blind. Verify, then trust.
