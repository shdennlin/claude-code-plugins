# Mermaid Validator Plugin

A Claude Code plugin that automatically validates Mermaid diagram syntax in **git changed/staged** Markdown files when a session ends.

## Features

- 🔍 Scans only **git changed/staged** Markdown files (not entire project)
- ✅ Validates syntax using the official Mermaid CLI
- 📍 Reports errors with file path and line numbers
- 🚫 Non-blocking - reports errors but doesn't prevent session completion
- ⚡ Fast - only validates files you've modified

## Prerequisites

You need to have the Mermaid CLI installed:

```bash
npm install -g @mermaid-js/mermaid-cli
```

Verify installation:

```bash
mmdc --version
```

## Installation

```bash
# Add marketplace
/plugin marketplace add shdennlin/claude-code-plugins

# Install plugin
/plugin install mermaid-validator@shdennlin-plugins
```

## How It Works

This plugin uses a `Stop` hook that triggers when your Claude Code session ends. The hook:

1. Detects git changed files (staged + modified + untracked `.md` files)
2. Extracts Mermaid code blocks (` ```mermaid ` ... ` ``` `)
3. Validates each block using `mmdc` (Mermaid CLI)
4. Reports any syntax errors with file location and context

## Example Output

### All Valid

```
🔍 Validating Mermaid diagrams in changed files...
   Files to check: 2
────────────────────────────────────────
✅ All 3 Mermaid diagram(s) are valid
```

### With Errors

```
🔍 Validating Mermaid diagrams in changed files...
   Files to check: 2
✗ Error in docs/architecture.md:45
  Mermaid block #2:
    graph TD
        A[Start --> B[End]
    ...
  Error: Syntax error in graph

────────────────────────────────────────
🔴 Found 1 Mermaid syntax error(s) in 3 diagram(s)
```

### No Changes

```
ℹ️  No changed Markdown files to validate
```

## What Files Are Validated

The plugin validates `.md` files that are:

| Status | Included |
|--------|----------|
| Staged (git add) | ✅ Yes |
| Modified (unstaged) | ✅ Yes |
| Untracked (new files) | ✅ Yes |
| Unchanged | ❌ No |

This means validation only runs on files you've worked on during the session.

## Troubleshooting

### "Mermaid CLI (mmdc) not found"

Install the Mermaid CLI:

```bash
npm install -g @mermaid-js/mermaid-cli
```

### "Not a git repository"

This plugin requires a git repository. Initialize one with:

```bash
git init
```

### Hook not running

Use debug mode to see hook execution:

```bash
claude --debug
```

## License

MIT
