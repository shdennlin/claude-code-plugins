---
allowed-tools:
  - Bash
  - Grep
  - Read
  - Edit
  - Task
description: Validate and fix Mermaid diagram syntax in Markdown files
argument-hint: "[file] [--fix] [--all]"
---

# Mermaid Check Command

Validate and fix Mermaid diagram syntax in Markdown files.

## Arguments

- `[file]` - Optional: Specific file to check (e.g., `README.md`)
- `--fix` - Auto-fix common syntax errors
- `--all` - Check all `.md` files in project (not just git changes)

**Default behavior**: Only check git changed/staged/untracked `.md` files.

## Instructions

### Step 1: Determine Files to Check

Based on arguments ($ARGUMENTS):

| Argument | Action |
|----------|--------|
| No args | Get git changed `.md` files |
| `filename.md` | Check only that file |
| `--all` | Check all `.md` files |

**Git commands to find changed files:**
```bash
git diff --name-only --cached --diff-filter=ACMR | grep '\.md$'  # staged
git diff --name-only --diff-filter=ACMR | grep '\.md$'           # modified
git ls-files --others --exclude-standard | grep '\.md$'          # untracked
```

### Step 2: Find Mermaid Blocks

For each file, search for mermaid code blocks:
- Pattern: ` ```mermaid ` ... ` ``` `
- Record file path and line number of each block

### Step 3: Validate Syntax

Check for common errors:
- **Unclosed brackets**: `A[Start --> B` → should be `A[Start] --> B`
- **Missing graph type**: No `graph`/`flowchart`/`sequenceDiagram` declaration
- **Invalid arrows**: `->` instead of `-->`
- **Unquoted special chars**: `A[Hello!]` → `A["Hello!"]`

If `mmdc` is available, use for deep validation:
```bash
echo "diagram content" > /tmp/test.mmd
mmdc -i /tmp/test.mmd -o /tmp/test.svg 2>&1
```

### Step 4: Report Results

Show results in format:
```
📊 Mermaid Validation Results

❌ Error in file.md:15
   graph TD
       A[Start --> B[End]

   Problem: Unclosed bracket in node A
   Fix: A[Start] --> B[End]
```

### Step 5: Fix (if --fix)

If `--fix` flag present or user requests:
1. Propose the fix
2. Ask for confirmation (unless obvious fix)
3. Use Edit tool to apply
4. Re-validate after fixing

## Complex Operations

For `--fix` or `--all` flags, delegate to the `mermaid-validator` agent:

```
Task tool:
- subagent_type: "mermaid-validator"
- description: "Validate mermaid diagrams"
- prompt: "Validate and fix mermaid diagrams. Files: [list]. Flags: [--fix/--all]"
```

## Examples

```bash
# Check git changed files
/mermaid-validator:check

# Check specific file
/mermaid-validator:check README.md

# Check and fix errors
/mermaid-validator:check --fix

# Check all files in project
/mermaid-validator:check --all
```
