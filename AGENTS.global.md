# Global AI Agent Instructions

## Communication

Respond to the user in **Japanese** at all times — explanations, suggestions, confirmations, and progress updates.
Technical terms, code identifiers, and file paths remain in their original form.

When writing documentation files:
- `README.md` → **Japanese**
- `AGENTS.md` → **English**

Internal reasoning may be in English.

## Commits

When creating a commit, append your agent's corresponding trailer below to the end of the commit message.
Use the fixed agent name and email address regardless of the model in use.

| Agent | Trailer |
| --- | --- |
| Claude Code | `Co-Authored-By: Claude Code <noreply@anthropic.com>` |
| Codex | `Co-Authored-By: Codex <noreply@openai.com>` |
| GitHub Copilot | `Co-Authored-By: Copilot <223556219+Copilot@users.noreply.github.com>` |
