# hooks/ — event-driven safety scripts (set up WITH Claude Code on your machine)

Hooks run shell scripts on tool events (e.g. before a file write or command). Use them to:
- Block writes/commands against production or live client systems (safety).
- Prevent committing secrets (scan staged changes).
- Run lint/format/tests automatically.

⚠️ Hooks execute code on your machine. A non-technical owner should have Claude Code create and
DEMONSTRATE these, not paste them blind. Example intent (pseudocode), to be implemented per environment:

- pre-write: if target path looks like a production config/db → block and warn.
- pre-commit: scan staged diff for secrets/API keys → block if found.
- post-write: run formatter/linter on changed files.

Implement and test these with Claude Code before relying on them.
