# Claude Code Plugins

A collection of plugins for [Claude Code](https://code.claude.com/docs/en/) - Anthropic's official CLI for Claude.

## Installation

```bash
# Step 1: Add this marketplace to Claude Code
/plugin marketplace add shdennlin/claude-code-plugins

# Step 2: Install a plugin
/plugin install mermaid-validator@shdennlin-plugins
```

That's it! The plugin is now installed and ready to use.

## Plugin Catalog

| Plugin | Description | Prerequisites |
|--------|-------------|---------------|
| [mermaid-validator](./plugins/mermaid-validator) | Validates Mermaid diagram syntax in Markdown files when session ends | `mmdc` ([Mermaid CLI](https://github.com/mermaid-js/mermaid-cli)) |

## Commands

```bash
# Add this marketplace
/plugin marketplace add shdennlin/claude-code-plugins

# Install a plugin
/plugin install mermaid-validator@shdennlin-plugins

# List available plugins
/plugin list shdennlin-plugins

# Update a plugin
/plugin update mermaid-validator@shdennlin-plugins

# Remove a plugin
/plugin uninstall mermaid-validator@shdennlin-plugins
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
3. Add your plugin to `.claude-plugin/marketplace.json`
4. Update this README's plugin catalog
5. Submit a pull request

## License

MIT License - see [LICENSE](./LICENSE) for details.

## Author

**shdennlin** - [GitHub](https://github.com/shdennlin)

## Resources

- [Claude Code Documentation](https://code.claude.com/docs/en/)
- [Plugin Development Guide](https://code.claude.com/docs/en/plugins)
- [Marketplace Documentation](https://code.claude.com/docs/en/plugin-marketplaces)
