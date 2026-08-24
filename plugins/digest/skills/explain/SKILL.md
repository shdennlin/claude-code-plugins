---
name: digest:explain
description: "Explain what a file, module, or symbol is, how it works end-to-end, why it was designed this way, or where a bug comes from — code reading plus git archaeology (log, blame, PR history), output as a self-contained HTML explainer with inline SVG diagrams. Use for state questions about existing code: a path, a symbol, a free-form how/why question, or no arguments to explain the current conversation's findings. For summarizing a branch, PR, diff, or time range — what changed — use digest:digest instead."
---

# Explain

Turn unfamiliar code or a finished investigation into a visual explainer. `digest` covers **delta** (what changed); `explain` covers **state** (what is this, how does it work, why is it like this, where's the bug from).

## Usage

```
$explain                              # explain the current conversation's findings
$explain src/auth/                    # how this module works
$explain handleRetry                  # this function's role in the flow
$explain "why saga pattern here?"     # design rationale via git archaeology
$explain src/ -f "new teammate"       # onboarding tour
```

## Options

| Flag | Description |
|------|-------------|
| `-f, --for <audience>` | Tailor for an audience — free-form string (manager, non-technical, "new teammate", ...). Default: developer |

Output is always a self-contained HTML explainer written to the project root (`explain-<slug>-<YYYY-MM-DD>.html`), plus a one-paragraph conclusion in the terminal.

## Process

1. **No arguments → conversation mode (inline, no dispatch)**: the findings live in the current conversation, so build the explainer directly — read the visual spec at `../../templates/html-explainer.md` (relative to this directory), assemble sections from the section library, write the file. If the conversation holds no investigation yet, say so in one line and stop.
2. **Arguments → investigation mode (dispatch)**: classify the target (existing path → file/module; identifier-like → symbol; else → question) and dispatch the explain agent.

## Agent Dispatch (investigation mode only)

Use the companion `explain-agent.md` in this directory as the agent prompt. Provide it with:
- Target and target kind (file/module | symbol | question)
- Audience (free-form string, default `developer`)
- Output slug (path → basename; symbol → kebab; question → first ~5 significant words, kebab)
- The HTML template at `../../templates/html-explainer.md` relative to this directory

The agent uses `$PROJECT_ROOT` (set by the init hook) or falls back to `git rev-parse --show-toplevel`.
