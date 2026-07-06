# _dot-claude-template/ — copy into a Claude-built project as `.claude/`

This is a starter Claude Code native structure pre-wired to the framework. When Claude Code builds a
project, copy this into the project root as `.claude/` (and the two root files alongside it), then adapt
per project. See ../CLAUDE-NATIVE-MAPPING.md.

Also create at project root (not in this folder):
- `CLAUDE.md` — references the framework (per the global pointer)
- `.mcp.json` — the MCP integrations this project needs (decided at planning)

Verify each piece works (run a command, invoke the auditor, trip a hook) before real building.
