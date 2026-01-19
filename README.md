# Claude Code Plugins

A collection of plugins for [Claude Code](https://docs.anthropic.com/en/docs/claude-code) - Anthropic's official CLI for Claude.

## Quick Install

```bash
# Install a specific plugin
curl -fsSL https://raw.githubusercontent.com/shdennlin/claude-code-plugins/main/install.sh | bash -s -- mermaid-validator

# List all available plugins
curl -fsSL https://raw.githubusercontent.com/shdennlin/claude-code-plugins/main/install.sh | bash -s -- --list

# Install all plugins
curl -fsSL https://raw.githubusercontent.com/shdennlin/claude-code-plugins/main/install.sh | bash -s -- --all
```

## Plugin Catalog

| Plugin | Description | Prerequisites |
|--------|-------------|---------------|
| [mermaid-validator](./plugins/mermaid-validator) | Validates Mermaid diagram syntax in Markdown files when session ends | `mmdc` ([Mermaid CLI](https://github.com/mermaid-js/mermaid-cli)) |

## Installation Methods

### Method 1: One-Liner Install (Recommended)

```bash
# Install specific plugin
curl -fsSL https://raw.githubusercontent.com/shdennlin/claude-code-plugins/main/install.sh | bash -s -- mermaid-validator

# The script will:
# 1. Clone the repo to ~/.claude-plugins/
# 2. Show you the plugin path
# 3. Provide usage instructions
```

After installation, use with:
```bash
claude --plugin-dir ~/.claude-plugins/shdennlin-claude-plugins/plugins/mermaid-validator
```

### Method 2: Manual Clone

```bash
# Clone this repository
git clone https://github.com/shdennlin/claude-code-plugins.git

# Load a specific plugin
claude --plugin-dir ./claude-code-plugins/plugins/mermaid-validator
```

### Method 3: Add to Claude Code Settings

Add to your `~/.claude/settings.json`:

```json
{
  "plugins": [
    "~/.claude-plugins/shdennlin-claude-plugins/plugins/mermaid-validator"
  ]
}
```

### Method 4: Load Multiple Plugins

```bash
claude \
  --plugin-dir ./plugins/mermaid-validator \
  --plugin-dir ./plugins/another-plugin
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

## Updating Plugins

```bash
# Update all installed plugins
curl -fsSL https://raw.githubusercontent.com/shdennlin/claude-code-plugins/main/install.sh | bash -s -- --update

# Or manually
cd ~/.claude-plugins/shdennlin-claude-plugins && git pull
```

## Registry

This repository includes a machine-readable `registry.json` that contains metadata about all available plugins. This enables:

- Programmatic plugin discovery
- Version checking
- Prerequisite validation
- Future integration with plugin managers

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
3. Add your plugin to `registry.json`
4. Update this README's plugin catalog
5. Submit a pull request

## License

MIT License - see [LICENSE](./LICENSE) for details.

## Author

**shdennlin** - [GitHub](https://github.com/shdennlin)
