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

## AGENTS.md / CLAUDE.md Doctrine

When creating or maintaining project `AGENTS.md` / `CLAUDE.md`, apply the lightweight doctrine:

**Pruning rule**: For every line, ask "Would removing this cause the agent to make a mistake?" If no, remove it.
Target: ~100 lines / ~2,500 tokens — these files are loaded on every turn.

**Keep only**:
- Build / test commands
- Directory layout
- Code conventions
- Hard constraints (red lines)
- Incident log

**Move to skills**: multi-step "how-to" procedures. Do not write them inline.

**Important rules are placed first.**

**Before any update**: show a classification table (keep / remove / move-to-skill) with reasons, then a diff.
Never overwrite without user confirmation.

**Incident log** — add a `## Incidents` section to the project AGENTS.md:
`YYYY-MM-DD | what went wrong | one-sentence prevention`
