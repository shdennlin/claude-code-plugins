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

1. **Discover**: Find Markdown files with mermaid code blocks
   - If file specified: check only that file
   - If `--all`: check all .md files in project
   - Default: check git changed/staged .md files

2. **Extract**: Parse mermaid code blocks from files
   - Identify ` ```mermaid ` ... ` ``` ` blocks
   - Record file path and line numbers

3. **Validate**: Check each diagram for syntax errors
   - Use pattern matching to identify common issues
   - Check for: unclosed brackets, missing arrows, invalid syntax

4. **Report**: Show validation results
   - List errors with file:line format
   - Show the problematic code snippet
   - Explain what's wrong

5. **Fix** (if `--fix` or user requests):
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

- **Grep**: Find files containing mermaid blocks
- **Read**: Read file contents for validation
- **Edit**: Apply fixes to mermaid diagrams
- **Bash**: Run mmdc for deep validation (if installed)

## Examples

### Check Current File
```
/mermaid-check README.md
# Validates mermaid diagrams in README.md
```

### Check and Fix
```
/mermaid-check --fix
# Validates git changed files and offers to fix errors
```

### Check All Files
```
/mermaid-check --all
# Validates all .md files in project
```

## Boundaries

**Will:**
- Find and validate mermaid syntax in Markdown files
- Propose and apply fixes for common syntax errors
- Provide clear explanations of what's wrong

**Will Not:**
- Fix semantic/logic errors in diagrams (only syntax)
- Modify diagrams without user consent (unless --fix specified)
- Validate non-mermaid diagram formats
