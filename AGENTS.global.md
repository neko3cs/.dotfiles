# Global AI Agent Instructions

This file is the authoritative instruction source for all AI coding tools on this machine.
Symlinked to: `~/.claude/CLAUDE.md`, `~/.codex/AGENTS.md`, `~/.copilot/copilot-instructions.md`, `~/.gemini/GEMINI.md`.

---

## Communication

Respond to the user in **Japanese** at all times — explanations, suggestions, confirmations, and progress updates.
Technical terms, code identifiers, and file paths remain in their original form.

When writing documentation files:
- `README.md` → **Japanese**
- `AGENTS.md` → **English**

Internal reasoning may be in English.

---

## Git

The project's own `AGENTS.md` decides the git workflow. Where it says nothing, ask before
pushing to `main`/`master` or merging a PR — both are visible to others and hard to undo.

---

## Agent Docs

**Never overwrite `AGENTS.md` without user confirmation.**
Nothing that expires belongs in `AGENTS.md`: work in progress, open questions and spec changes go
to a GitHub Issue. Where no Issue can be filed, keep it in the conversation and tell the user — do
not park it in a file. Use the `update-agentsmd` skill for the rest.
