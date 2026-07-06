# claude-integration/ — Claude Code wiring (ADDITIVE — only if Claude Code is the builder)

> ⚠️ **This entire folder applies ONLY when the builder is Claude Code.** The core framework (CLAUDE.md,
> layers, cross-cutting, reference architectures, project-docs) is builder-agnostic and works with any
> builder (Codex, Cursor, hand-coding, etc.). If you are using another builder, IGNORE this folder and
> apply the equivalent in your tool — the *rules* are the same, only the *wiring* differs.

🟩 **FOR THE FOUNDER** — the core framework is a set of documents any builder can follow. This folder
translates those documents into Claude Code's *native* structure so that, when Claude Code is the
builder, the rules don't just get read — they get **executed automatically** (sub-agents run the audit
loop, hooks block unsafe operations, skills load on demand, settings control permissions).

## What's in here
| File | Purpose |
|------|---------|
| `CLAUDE-NATIVE-MAPPING.md` | How the framework maps onto Claude Code's `.claude/` structure |
| `claude-best-practices.md` | Token-saving + Claude Code operating practices |
| `_dot-claude-template/` | A ready-to-copy `.claude/` folder to drop into a Claude-built project |

## The rule
🟦 **FOR CLAUDE CODE** — when you are the builder on a project, set up the project's native `.claude/`
structure from `_dot-claude-template/` (adapted per project), so the framework's rules, audit loop,
and safety hooks are wired into your native behavior. Confirm the wiring works before building.
