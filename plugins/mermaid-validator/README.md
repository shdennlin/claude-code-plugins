# Mermaid Validator Plugin

A Claude Code plugin that validates and **fixes** Mermaid diagram syntax in Markdown files.

## Features

- 🔍 **Skill**: On-demand validation with `/mermaid-check` command
- 🤖 **Agent**: Proactive validation after editing `.md` files
- ✅ Validates syntax and identifies common errors
- 🔧 **Auto-fix**: Can fix common syntax errors
- 📍 Reports errors with file path and line numbers

## Installation

```bash
# Add marketplace
/plugin marketplace add shdennlin/claude-code-plugins

# Install plugin
/plugin install mermaid-validator@shdennlin-plugins
```

## Usage

### Skill: `/mermaid-check`

Use the skill for on-demand validation:

```bash
# Check git changed files (default)
/mermaid-check

# Check specific file
/mermaid-check README.md

# Check and auto-fix errors
/mermaid-check --fix

# Check all .md files in project
/mermaid-check --all
```

### Agent: Proactive Validation

The agent automatically activates when you:
- Edit a Markdown file with mermaid diagrams
- Add a new flowchart or diagram
- Mention mermaid rendering issues

**Examples that trigger the agent:**
- "I just updated the architecture diagram in docs/architecture.md"
- "Added a new flowchart to README.md"
- "The mermaid diagram isn't rendering correctly"

## What It Validates

### Common Errors Detected

| Error | Example | Fix |
|-------|---------|-----|
| Unclosed bracket | `A[Start --> B` | `A[Start] --> B` |
| Missing graph type | `A --> B` (no declaration) | Add `graph TD` |
| Invalid arrow | `A -> B` | `A --> B` |
| Unquoted special chars | `A[Hello!]` | `A["Hello!"]` |

### Example Output

```
📊 Mermaid Validation Results

❌ Error in docs/flow.md:15
   graph TD
       A[Start --> B[End]

   Problem: Unclosed bracket in node A
   Fix: A[Start] --> B[End]

   Would you like me to fix this?
```

## Optional: Deep Validation with mmdc

For more thorough validation, install the Mermaid CLI:

```bash
npm install -g @mermaid-js/mermaid-cli
```

The plugin will use `mmdc` for deep validation when available.

## Plugin Structure

```
mermaid-validator/
├── .claude-plugin/
│   └── plugin.json
├── skills/
│   └── mermaid-check/
│       └── SKILL.md         # /mermaid-check command
├── agents/
│   └── mermaid-validator.md # Proactive agent
└── README.md
```

## License

MIT
