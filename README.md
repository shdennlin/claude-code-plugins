# Claude Code Plugins

A collection of plugins for [Claude Code](https://docs.anthropic.com/en/docs/claude-code) - Anthropic's official CLI for Claude.

## Plugin Catalog

| Plugin | Description | Prerequisites |
|--------|-------------|---------------|
| [mermaid-validator](./plugins/mermaid-validator) | Validates Mermaid diagram syntax in Markdown files when session ends | `mmdc` ([Mermaid CLI](https://github.com/mermaid-js/mermaid-cli)) |

## Installation

### Option 1: Load a Single Plugin

```bash
# Clone this repository
git clone https://github.com/shdennlin/claude-code-plugins.git

# Load a specific plugin
claude --plugin-dir ./claude-code-plugins/plugins/mermaid-validator
```

### Option 2: Load Multiple Plugins

```bash
claude \
  --plugin-dir ./claude-code-plugins/plugins/mermaid-validator \
  --plugin-dir ./claude-code-plugins/plugins/another-plugin
```

### Option 3: Add to Claude Code Settings

Add to your `~/.claude/settings.json`:

```json
{
  "plugins": [
    "/path/to/claude-code-plugins/plugins/mermaid-validator"
  ]
}
```

## Plugin Details

### mermaid-validator

Automatically validates Mermaid diagram syntax in all Markdown files when your Claude Code session ends.

**Features:**
- Scans all `.md` files in your project
- Reports syntax errors with file path and line numbers
- Non-blocking (reports only, doesn't prevent session completion)

**Prerequisites:**
```bash
npm install -g @mermaid-js/mermaid-cli
```

**Usage:**
```bash
claude --plugin-dir ./plugins/mermaid-validator
```

[View full documentation](./plugins/mermaid-validator/README.md)

## Contributing

Contributions are welcome! Please see [CONTRIBUTING.md](./CONTRIBUTING.md) for guidelines.

### Adding a New Plugin

1. Create a new directory under `plugins/`
2. Follow the standard plugin structure:
   ```
   plugins/your-plugin/
   ├── .claude-plugin/
   │   └── plugin.json
   ├── hooks/           # (optional)
   ├── commands/        # (optional)
   ├── agents/          # (optional)
   ├── scripts/         # (optional)
   └── README.md
   ```
3. Update this README's plugin catalog
4. Submit a pull request

## License

MIT License - see [LICENSE](./LICENSE) for details.

## Author

**shdennlin** - [GitHub](https://github.com/shdennlin)
