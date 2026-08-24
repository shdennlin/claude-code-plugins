---
allowed-tools:
  - Read
  - Bash
  - Glob
  - Grep
  - Task
  - AskUserQuestion
description: Summarize a branch, PR, diff, or design doc into a structured digest with file breakdown and key concepts
argument-hint: "[target] [-f/--for <audience>] [-e/--export [md|html]] [--help/-h]"
---

# Digest Command

Produce a structured summary of AI-generated changes so developers, reviewers, and stakeholders can quickly understand what changed and why.

## Arguments

Parse the following from `$ARGUMENTS`:

- `[target]` — A branch name, PR number (`#42`), file path, or omit for current branch
- `-f, --for <audience>` — Tailor material and language for an audience. Free-form string (e.g. `manager`, `pm`, `designer`, `non-technical`, `"security auditor"`). Default: developer/reviewer
- `-e, --export [md|html]` — Write a full-depth report file. `md` = markdown with Mermaid diagrams (default when no value given); `html` = self-contained HTML explainer
- `--help` or `-h` — Show usage information and exit

**Output rule**: terminal output is always the concise card; export output is always the full-depth report. The audience flag calibrates both.

## Instructions

### Step 1: Parse Arguments

From `$ARGUMENTS`, extract:

1. **help**: if `--help` or `-h` is present, show usage info below and stop. Do NOT delegate to the agent.
2. **audience**: if `-f` or `--for` is present, the next token is the audience string, taken verbatim — do NOT validate against a list. Default: `developer`.
3. **export format**: if `-e` or `--export` is present:
   - If the very next token is exactly `md` or `html`, that token is the format and is consumed.
   - Otherwise the format is `md` (bare export) and the token is NOT consumed — it stays positional. Example: `-e feat/auth` means "export md" with target `feat/auth`.
   - If the flag is absent, export format is `none`.
4. **target**: the remaining positional argument (branch, `#<number>`, file path, or empty)

**Removed flags — print a migration hint, do NOT error:**

- `-r` / `--report` present → print `Note: -r was removed in 2.0 — full reports now live in exports. Use -e md or -e html.` Strip the flag and continue.
- `-s` / `--simple` present → print `Note: -s was removed in 2.0 — use -f non-technical (or any audience).` Set audience to `non-technical` and continue.

Hints are independent and combinable: `-r -e html` prints the `-r` hint and proceeds with the html export; `-s -r` prints both hints and runs once with audience `non-technical`.

### Help Output

If `--help` or `-h` is present, display this and stop:

```
Usage: /digest:digest [target] [options]

Summarize branches, PRs, diffs, or design docs into structured digests.

Positional arguments:
  target                Branch name, PR number (#42), file path, or omit for current branch

Options:
  -f, --for <audience>  Tailor material and language for an audience (free-form:
                        manager, pm, designer, non-technical, "security auditor", ...)
                        Default: developer/reviewer
  -e, --export [md|html]
                        Write a full-depth report file. md = markdown with Mermaid
                        (default when no value), html = self-contained HTML explainer
  -h, --help            Show this help message

Output:
  terminal              Concise card + file breakdown + walkthrough + key concepts (~1 min)
  -e md                 Full-depth markdown report -> digest-report-<target>-<date>.md
  -e html               Full-depth self-contained HTML explainer -> digest-report-<target>-<date>.html

Input detection:
  #<number>             PR number (uses gh pr view)
  <branch-name>         Branch diff against base
  <file-path>           Design doc summary
  (empty)               Current branch vs auto-detected base

Examples:
  /digest:digest                       # current branch vs main
  /digest:digest feat/new-auth         # specific branch
  /digest:digest #42                   # PR number
  /digest:digest -f manager            # impact/risk/decision framing
  /digest:digest -e html               # shareable HTML explainer
  /digest:digest feat/auth -e          # markdown report for a branch
```

### Step 2: Detect Input Type

Determine the input type from `target`:
- Starts with `#` followed by digits → **PR** (e.g., `#42`)
- Matches a file path that exists on disk → **Design doc**
- Non-empty string → **Branch name**
- Empty / not provided → **Current branch**

### Step 3: Delegate to Agent

If the export format is `html`, first resolve `${CLAUDE_PLUGIN_ROOT}/templates/html-explainer.md` to an absolute path — the agent cannot expand that variable itself, so the resolved path must be embedded in the prompt.

Launch the `digest-agent` agent:

```
Task tool:
- subagent_type: "digest:digest-agent"
- description: "Digest and summarize changes"
- prompt: |
    Produce a digest summary for the following input.

    Input type: <PR | Branch | Design doc | Current branch>
    Target: <target value or "current branch">
    Audience: <audience string, default "developer">
    Export format: <none | md | html>
    HTML template path: <absolute path to templates/html-explainer.md — include this line only when Export format is html>
```

Report the agent's output back to the user verbatim. When an export was requested, the agent's output ends with the written file path — keep it visible.

## Examples

```bash
# Summarize current branch
/digest:digest

# Summarize a feature branch
/digest:digest feat/new-auth

# Summarize a PR
/digest:digest #42

# Summarize a design doc
/digest:digest docs/plans/auth.md

# Digest for your manager — impact, risk, timeline, decisions
/digest:digest -f manager

# Plain-language digest for anyone
/digest:digest -f non-technical

# Full markdown report with Mermaid diagrams
/digest:digest -e md

# Self-contained HTML explainer (shareable single file)
/digest:digest -e html

# Combine: HTML explainer written for a PM
/digest:digest feat/auth -e html -f pm
```
