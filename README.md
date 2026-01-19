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

| Plugin | Description | Type |
|--------|-------------|------|
| [mermaid-validator](./plugins/mermaid-validator) | Validates and fixes Mermaid diagram syntax in Markdown files | Skill + Agent |

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

Validates and **fixes** Mermaid diagram syntax in Markdown files.

**Components:**
- 🔍 **Skill** (`/mermaid-check`): On-demand validation with fix capability
- 🤖 **Agent**: Proactive validation after editing `.md` files

**Usage:**
```bash
# Check mermaid diagrams
/mermaid-check

# Check and auto-fix
/mermaid-check --fix

# Check specific file
/mermaid-check README.md
```

**Optional (for deep validation):**
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
   ├── skills/          # (optional)
   ├── agents/          # (optional)
   ├── hooks/           # (optional)
   ├── commands/        # (optional)
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
