---
name: mermaid-check
description: Validate and fix Mermaid diagram syntax in Markdown files. Use when user asks to check mermaid diagrams, validate diagram syntax, fix mermaid errors, or mentions mermaid rendering issues.
allowed-tools:
  - Bash
  - Grep
  - Read
  - Edit
  - Task
---

# /mermaid-check - Mermaid Diagram Validation and Fix

## Triggers
- User asks to "check mermaid", "validate mermaid diagrams", "fix mermaid errors"
- User mentions mermaid syntax issues or diagram problems
- User wants to verify diagram correctness before committing

## Usage
```
/mermaid-check [file] [--fix] [--all]
```

## Behavioral Flow

### 1. Discover Files

**IMPORTANT: By default, only check git changed/staged files, NOT all files.**

Use this logic to find files:

```bash
# Default: Get git changed/staged/untracked .md files
git diff --name-only --cached --diff-filter=ACMR | grep '\.md$'  # staged
git diff --name-only --diff-filter=ACMR | grep '\.md$'           # modified
git ls-files --others --exclude-standard | grep '\.md$'          # untracked
```

| Flag | Files to Check |
|------|----------------|
| (none) | Only git changed/staged/untracked `.md` files |
| `[file]` | Only the specified file |
| `--all` | All `.md` files in project |

If no git changes found, inform user: "No changed Markdown files to validate."

### 2. Quick Check vs Deep Analysis

**For simple validation (1-2 files, quick check):**
- Handle directly using Grep/Read/Edit tools
- Pattern match for common errors

**For complex operations (multiple files, --fix, --all):**
- Delegate to the `mermaid-validator` agent using Task tool:

```
Task tool parameters:
- subagent_type: "mermaid-validator"
- description: "Validate mermaid diagrams"
- prompt: "Validate and fix mermaid diagrams in: [files]. User requested: [--fix/--all flags]"
```

This allows the agent to handle the heavy lifting while the skill provides the user interface.

### 3. Validate Syntax

Check each diagram for common errors:
- Unclosed brackets: `A[Start --> B`
- Missing graph type: diagram without `graph`/`flowchart`/`sequenceDiagram` declaration
- Invalid arrows: `->` instead of `-->`
- Unquoted special characters

If `mmdc` is available, use it for deep validation:
```bash
echo "diagram" > /tmp/test.mmd && mmdc -i /tmp/test.mmd -o /tmp/test.svg 2>&1
```

### 4. Report Results

Show validation results:
- List errors with `file:line` format
- Show the problematic code snippet
- Explain what's wrong

### 5. Fix (if --fix or user requests)

- Propose corrections for common errors
- Use Edit tool to apply fixes
- Re-validate after fixing

## Common Mermaid Errors and Fixes

### Unclosed Brackets
```
# Error
A[Start --> B[End]

# Fix
A[Start] --> B[End]
```

### Missing Arrow Syntax
```
# Error
A -> B

# Fix (for flowcharts)
A --> B
```

### Invalid Node IDs
```
# Error
My Node --> Other

# Fix
MyNode[My Node] --> Other[Other]
```

### Missing Graph Declaration
```
# Error
A --> B --> C

# Fix
graph TD
    A --> B --> C
```

## Tool Coordination

- **Bash**: Run git commands to find changed files, run mmdc for validation
- **Grep**: Find files containing mermaid blocks
- **Read**: Read file contents for validation
- **Edit**: Apply fixes to mermaid diagrams
- **Task**: Delegate to `mermaid-validator` agent for complex operations

## Examples

### Check Git Changed Files (Default)
```
/mermaid-check
# Only validates .md files that are staged, modified, or untracked in git
# Does NOT scan entire project
```

### Check Specific File
```
/mermaid-check README.md
# Validates mermaid diagrams in README.md only
```

### Check and Fix
```
/mermaid-check --fix
# Validates git changed files and offers to fix errors
# Delegates to mermaid-validator agent for fix operations
```

### Check All Files
```
/mermaid-check --all
# Validates ALL .md files in project
# Delegates to mermaid-validator agent for efficiency
```

## Boundaries

**Will:**
- Find and validate mermaid syntax in Markdown files
- Propose and apply fixes for common syntax errors
- Provide clear explanations of what's wrong
- Default to git-changed files only (efficient)
- Delegate to agent for complex multi-file operations

**Will Not:**
- Scan all files by default (use --all for that)
- Fix semantic/logic errors in diagrams (only syntax)
- Modify diagrams without user consent (unless --fix specified)
- Validate non-mermaid diagram formats
