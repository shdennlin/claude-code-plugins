---
name: digest:digest
description: "Summarize AI-generated branches, PRs, diffs, and design docs into structured digests with file breakdown, code walkthrough, and key concepts. Supports audience targeting (-f manager/pm/designer/non-technical/any string) and export (-e md for markdown with Mermaid, -e html for a self-contained HTML explainer). Use when the user asks to summarize, digest, or understand a branch, PR, diff, time range, or design doc — what changed. For explaining a file, symbol, or how/why existing code works, use digest:explain instead."
---

# Digest

Summarize AI-generated changes into structured digests that developers, reviewers, and stakeholders can quickly understand.

## Usage

```
$digest                              # current branch vs main
$digest feat/new-auth                # specific branch
$digest #42                          # PR number
$digest docs/plans/auth.md           # design doc
$digest -f manager                   # impact/risk/decision framing
$digest -f non-technical             # plain language
$digest -e md                        # full markdown report with Mermaid
$digest -e html                      # self-contained HTML explainer
$digest feat/auth -e html -f pm      # combine target, export, audience
```

## Options

| Flag | Description |
|------|-------------|
| `-f, --for <audience>` | Tailor material and language for an audience — free-form string (manager, pm, designer, non-technical, ...). Default: developer/reviewer |
| `-e, --export [md\|html]` | Write a full-depth report file. `md` = markdown with Mermaid (default when no value); `html` = self-contained HTML explainer |

Output rule: terminal output is always the concise card (~1 min); export output is always the full-depth report. Removed flags: `-r` (use `-e md`/`-e html`), `-s` (use `-f non-technical`).

## Process

1. Detect input type (PR, branch, design doc, or current branch)
2. Dispatch the digest agent using the prompt template in `digest-agent.md` (in this skill directory)
3. Analyze changes and produce the audience-calibrated card, plus the full-depth report file if exporting
4. Report the card back to the user (and the written file path when exporting)

## Agent Dispatch

Use the companion `digest-agent.md` in this directory as the agent prompt. Provide it with:
- Input type and target
- Audience (free-form string, default `developer`)
- Export format (`none`, `md`, or `html`)
- For html export: the HTML template at `../../templates/html-explainer.md` relative to this directory

The agent uses `$PROJECT_ROOT` (set by the init hook) or falls back to `git rev-parse --show-toplevel`.
