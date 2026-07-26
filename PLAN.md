# PLAN.md

## Goal
- Bring this repo's docs in line with the revised global doctrine in `AGENTS.global.md`.

## Approach
- The doctrine owns the routing table. `AGENTS.md` and the skills defer to it instead of
  restating it.
- `AGENTS.md` keeps only what the config files' own comments do not already say. Where a file
  documents itself, `AGENTS.md` points at it rather than repeating it.

## Rejected
- Moving the "classification table, then a diff" gate into the update-agentsmd skill: Codex /
  Gemini / Copilot cannot invoke skills, so three of the four tools would lose the guard.
- Splitting the Codex/execpolicy entries out to `docs/codex-permissions.md`: the extra hop makes
  it likelier the content goes unread, and anything touching `.codex/` has to read it anyway.
- Cutting `AGENTS.md` down to the doctrine's ~100-line target: the 2026-07-26 audit found the
  remaining entries genuinely tacit, so the cut would discard accident-preventing text.
  161 lines is accepted deliberately.

## Next
- Decide, one by one, whether the four items under `AGENTS.md`'s `Open Issues` become GitHub
  Issues. `gh` works; the repo currently has zero issues.

## Undecided
- `custom.rules`'s header points at `AGENTS.md`, and `AGENTS.md` now points back at the config
  files. Whichever side gets edited, the other can go stale. No fix chosen.
