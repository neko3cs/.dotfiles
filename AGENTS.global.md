# Global AI Agent Instructions

This file is the authoritative instruction source for all AI coding tools on this machine.
Symlinked to: `~/.claude/CLAUDE.md`, `~/.codex/AGENTS.md`, `~/.copilot/copilot-instructions.md`, `~/.gemini/GEMINI.md`.

---

## Communication

Respond to the user in **Japanese** at all times — explanations, suggestions, confirmations, and progress updates.
Technical terms, code identifiers, and file paths remain in their original form.

When writing documentation files:
- `README.md` → **Japanese**
- `AGENTS.md` / `PLAN.md` → **English**

Internal reasoning may be in English.

---

## Git Workflow

Default for every repository: **work in a worktree on a branch, then open a PR** — never commit
or push straight to `main`/`master`. Create the worktree + branch before touching code; once the
change is ready, open a PR and stop there — merging is the user's call, not the agent's.

A project's own `AGENTS.md` can override this default (e.g. a solo repo with no PR-based review
may choose direct-to-`main` commits) — the project rule wins over this one.

---

## Documentation Doctrine

Applies whenever you create or maintain `AGENTS.md` / `CLAUDE.md` / `PLAN.md`.

**Never overwrite these files without user confirmation.** Show a classification table
(keep / remove / move-to-skill) with reasons, then a diff, and wait.

**Route the information first**:

| Information | Goes to |
| :--- | :--- |
| Deterministic and permanent — commands, layout, conventions, hard constraints, non-obvious why, gotchas, incidents | `AGENTS.md` |
| Spec changes, unresolved questions, anything another person needs | GitHub Issue |
| Work in progress worth remembering across sessions | `PLAN.md` |
| Session-local task list | no file |

Nothing that expires belongs in `AGENTS.md` — no TODOs, no open questions, no in-progress state.

**Pruning rule**: For every line, ask "Would removing this cause the agent to make a mistake?" If no, remove it.
Target: ~100 lines / ~2,500 tokens — these files are loaded on every turn.

**Move to skills**: multi-step "how-to" procedures. Do not write them inline.

**Important rules are placed first.**

**Incident log** — add a `## Incidents` section to the project AGENTS.md:
`YYYY-MM-DD | what went wrong | one-sentence prevention`
