# Mermaid Validator Plugin

A Claude Code plugin that automatically validates Mermaid diagram syntax in Markdown files when a session ends.

## Features

- 🔍 Scans all Markdown files in your project for Mermaid diagrams
- ✅ Validates syntax using the official Mermaid CLI
- 📍 Reports errors with file path and line numbers
- 🚫 Non-blocking - reports errors but doesn't prevent session completion

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

### Option 1: Load directly

```bash
claude --plugin-dir /path/to/mermaid-validator
```

### Option 2: Add to your Claude Code settings

Add to your `~/.claude/settings.json`:

```json
{
  "plugins": [
    "/path/to/mermaid-validator"
  ]
}
```

## How It Works

This plugin uses a `Stop` hook that triggers when your Claude Code session ends. The hook:

1. Finds all `.md` files in your project directory
2. Extracts Mermaid code blocks (` ```mermaid ` ... ` ``` `)
3. Validates each block using `mmdc` (Mermaid CLI)
4. Reports any syntax errors with file location and context

## Example Output

### All Valid

```
🔍 Validating Mermaid diagrams...
────────────────────────────────────────
✅ All 5 Mermaid diagram(s) are valid
```

### With Errors

```
🔍 Validating Mermaid diagrams...
✗ Error in docs/architecture.md:45
  Mermaid block #2:
    graph TD
        A[Start --> B[End]
    ...
  Error: Syntax error in graph

────────────────────────────────────────
🔴 Found 1 Mermaid syntax error(s) in 5 diagram(s)
```

## Configuration

The plugin scans the entire project directory (`${CLAUDE_PROJECT_DIR}`). Files in `node_modules` and `.git` directories are automatically excluded.

### Hook Configuration

The hook is configured in `hooks/hooks.json`:

```json
{
  "hooks": {
    "Stop": [
      {
        "matcher": "*",
        "hooks": [
          {
            "type": "command",
            "command": "bash ${CLAUDE_PLUGIN_ROOT}/scripts/validate-mermaid.sh",
            "timeout": 60
          }
        ]
      }
    ]
  }
}
```

## Troubleshooting

### "Mermaid CLI (mmdc) not found"

Install the Mermaid CLI:

```bash
npm install -g @mermaid-js/mermaid-cli
```

### Hook not running

1. Ensure the plugin is loaded correctly:
   ```bash
   claude --debug --plugin-dir ./mermaid-validator
   ```

2. Check that `hooks.json` is in the correct location

3. Verify the script is executable:
   ```bash
   chmod +x scripts/validate-mermaid.sh
   ```

## License

MIT
