#!/bin/bash
# Claude Code Plugins Installer
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/shdennlin/claude-code-plugins/main/install.sh | bash -s -- <plugin-name>
#   curl -fsSL https://raw.githubusercontent.com/shdennlin/claude-code-plugins/main/install.sh | bash -s -- --all
#   curl -fsSL https://raw.githubusercontent.com/shdennlin/claude-code-plugins/main/install.sh | bash -s -- --list

set -euo pipefail

# Configuration
REPO_URL="https://github.com/shdennlin/claude-code-plugins.git"
REPO_RAW_URL="https://raw.githubusercontent.com/shdennlin/claude-code-plugins/main"
INSTALL_DIR="${CLAUDE_PLUGINS_DIR:-$HOME/.claude-plugins}"
REPO_NAME="shdennlin-claude-plugins"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

print_header() {
    echo -e "${CYAN}"
    echo "╔══════════════════════════════════════════════════════════╗"
    echo "║          Claude Code Plugins Installer                   ║"
    echo "║          github.com/shdennlin/claude-code-plugins        ║"
    echo "╚══════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

print_usage() {
    echo "Usage:"
    echo "  install.sh <plugin-name>    Install a specific plugin"
    echo "  install.sh --all            Install all plugins"
    echo "  install.sh --list           List available plugins"
    echo "  install.sh --update         Update installed plugins"
    echo "  install.sh --help           Show this help"
    echo ""
    echo "Examples:"
    echo "  install.sh mermaid-validator"
    echo "  install.sh --all"
}

list_plugins() {
    echo -e "${BLUE}Available plugins:${NC}"
    echo ""

    # Fetch registry.json and parse with basic tools
    if command -v curl &> /dev/null; then
        registry=$(curl -fsSL "$REPO_RAW_URL/registry.json" 2>/dev/null)
    elif command -v wget &> /dev/null; then
        registry=$(wget -qO- "$REPO_RAW_URL/registry.json" 2>/dev/null)
    else
        echo -e "${RED}Error: curl or wget required${NC}"
        exit 1
    fi

    # Parse plugins using grep/sed (works without jq)
    echo "$registry" | grep -E '"name"|"description"|"version"' | \
        sed 's/.*"name": *"\([^"]*\)".*/  \1/; s/.*"description": *"\([^"]*\)".*/    \1/; s/.*"version": *"\([^"]*\)".*/    v\1\n/' | \
        head -20

    echo ""
    echo -e "${YELLOW}Install with:${NC} install.sh <plugin-name>"
}

clone_or_update_repo() {
    local repo_dir="$INSTALL_DIR/$REPO_NAME"

    if [ -d "$repo_dir/.git" ]; then
        echo -e "${BLUE}Updating repository...${NC}"
        (cd "$repo_dir" && git pull --quiet)
    else
        echo -e "${BLUE}Cloning repository...${NC}"
        mkdir -p "$INSTALL_DIR"
        git clone --quiet "$REPO_URL" "$repo_dir"
    fi

    echo "$repo_dir"
}

install_plugin() {
    local plugin_name="$1"
    local repo_dir="$2"
    local plugin_path="$repo_dir/plugins/$plugin_name"

    if [ ! -d "$plugin_path" ]; then
        echo -e "${RED}Error: Plugin '$plugin_name' not found${NC}"
        echo -e "Run ${YELLOW}install.sh --list${NC} to see available plugins"
        exit 1
    fi

    echo -e "${GREEN}✓${NC} Plugin '$plugin_name' installed at:"
    echo -e "  ${CYAN}$plugin_path${NC}"
    echo ""
    echo -e "${YELLOW}To use with Claude Code:${NC}"
    echo -e "  claude --plugin-dir $plugin_path"
    echo ""
    echo -e "${YELLOW}Or add to ~/.claude/settings.json:${NC}"
    echo -e '  {"plugins": ["'$plugin_path'"]}'
}

install_all_plugins() {
    local repo_dir="$1"
    local plugins_dir="$repo_dir/plugins"

    echo -e "${GREEN}✓${NC} All plugins installed at:"
    for plugin in "$plugins_dir"/*/; do
        plugin_name=$(basename "$plugin")
        echo -e "  ${CYAN}$plugin${NC}"
    done

    echo ""
    echo -e "${YELLOW}To use specific plugin:${NC}"
    echo -e "  claude --plugin-dir $plugins_dir/<plugin-name>"
}

check_prerequisites() {
    local plugin_name="$1"
    local repo_dir="$2"

    # Read registry.json and check prerequisites
    local registry_file="$repo_dir/registry.json"
    if [ -f "$registry_file" ]; then
        # Basic check for mermaid-validator
        if [ "$plugin_name" = "mermaid-validator" ]; then
            if ! command -v mmdc &> /dev/null; then
                echo -e "${YELLOW}⚠️  Prerequisite missing: mermaid-cli (mmdc)${NC}"
                echo -e "   Install with: ${BLUE}npm install -g @mermaid-js/mermaid-cli${NC}"
                echo ""
            fi
        fi
    fi
}

# Main
print_header

if [ $# -eq 0 ]; then
    print_usage
    exit 0
fi

case "$1" in
    --help|-h)
        print_usage
        ;;
    --list|-l)
        list_plugins
        ;;
    --update|-u)
        repo_dir=$(clone_or_update_repo)
        echo -e "${GREEN}✓${NC} Plugins updated"
        ;;
    --all|-a)
        repo_dir=$(clone_or_update_repo)
        install_all_plugins "$repo_dir"
        ;;
    --*)
        echo -e "${RED}Unknown option: $1${NC}"
        print_usage
        exit 1
        ;;
    *)
        plugin_name="$1"
        repo_dir=$(clone_or_update_repo)
        check_prerequisites "$plugin_name" "$repo_dir"
        install_plugin "$plugin_name" "$repo_dir"
        ;;
esac
