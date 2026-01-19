#!/bin/bash
# Mermaid Diagram Validator
# Validates Mermaid syntax in git changed/staged Markdown files at session end

set -uo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Project directory (fallback to current directory)
PROJECT_DIR="${CLAUDE_PROJECT_DIR:-.}"

# Check if mmdc is installed
if ! command -v mmdc &> /dev/null; then
    echo -e "${YELLOW}⚠️  Mermaid CLI (mmdc) not found.${NC}"
    echo -e "   Install with: ${BLUE}npm install -g @mermaid-js/mermaid-cli${NC}"
    exit 0
fi

# Check if we're in a git repository
if ! git -C "$PROJECT_DIR" rev-parse --git-dir &> /dev/null; then
    echo -e "${YELLOW}⚠️  Not a git repository. Skipping Mermaid validation.${NC}"
    exit 0
fi

# Create temp directory for validation
TEMP_DIR=$(mktemp -d)
trap "rm -rf $TEMP_DIR" EXIT

# Get changed/staged markdown files only
# Combines: staged files + modified files + untracked files
cd "$PROJECT_DIR"

# Staged .md files
staged_files=$(git diff --name-only --cached --diff-filter=ACMR 2>/dev/null | grep '\.md$' || true)

# Modified (unstaged) .md files
modified_files=$(git diff --name-only --diff-filter=ACMR 2>/dev/null | grep '\.md$' || true)

# Untracked .md files (new files not yet added)
untracked_files=$(git ls-files --others --exclude-standard 2>/dev/null | grep '\.md$' || true)

# Combine and deduplicate
all_changed_files=$(echo -e "${staged_files}\n${modified_files}\n${untracked_files}" | grep -v '^$' | sort -u)

# Convert to array
mapfile -t md_files <<< "$all_changed_files"

# Filter out empty entries
md_files=("${md_files[@]//[[:space:]]/}")
md_files=($(printf '%s\n' "${md_files[@]}" | grep -v '^$'))

if [ ${#md_files[@]} -eq 0 ] || [ -z "${md_files[0]}" ]; then
    echo -e "${BLUE}ℹ️  No changed Markdown files to validate${NC}"
    exit 0
fi

errors_found=0
files_with_mermaid=0
total_diagrams=0

echo -e "${BLUE}🔍 Validating Mermaid diagrams in changed files...${NC}"
echo -e "${BLUE}   Files to check: ${#md_files[@]}${NC}"

for file in "${md_files[@]}"; do
    # Skip if empty or file doesn't exist
    [ -z "$file" ] && continue
    [ -f "$file" ] || continue

    # Check if file contains mermaid blocks
    if ! grep -q '```mermaid' "$file" 2>/dev/null; then
        continue
    fi

    ((files_with_mermaid++))

    # Extract mermaid blocks with line numbers
    block_num=0
    in_mermaid=0
    start_line=0
    current_block=""
    line_num=0

    while IFS= read -r line || [[ -n "$line" ]]; do
        ((line_num++))

        if [[ "$line" =~ ^\`\`\`mermaid ]]; then
            in_mermaid=1
            start_line=$line_num
            current_block=""
            continue
        fi

        if [[ $in_mermaid -eq 1 ]]; then
            if [[ "$line" =~ ^\`\`\` ]]; then
                in_mermaid=0
                ((block_num++))
                ((total_diagrams++))

                # Write block to temp file
                temp_file="$TEMP_DIR/block_${block_num}.mmd"
                echo "$current_block" > "$temp_file"

                # Validate with mmdc
                output_file="$TEMP_DIR/output_${block_num}.svg"
                error_output=$(mmdc -i "$temp_file" -o "$output_file" 2>&1)
                exit_code=$?

                if [ $exit_code -ne 0 ]; then
                    ((errors_found++))
                    echo -e "${RED}✗ Error in ${file}:${start_line}${NC}"
                    echo -e "  ${YELLOW}Mermaid block #${block_num}:${NC}"
                    # Show first few lines of the block for context
                    echo "$current_block" | head -3 | sed 's/^/    /'
                    if [ $(echo "$current_block" | wc -l) -gt 3 ]; then
                        echo "    ..."
                    fi
                    # Show error message
                    echo -e "  ${RED}Error: $(echo "$error_output" | grep -i "error" | head -1)${NC}"
                    echo ""
                fi
            else
                current_block+="$line"$'\n'
            fi
        fi
    done < "$file"
done

# Summary
echo -e "${BLUE}────────────────────────────────────────${NC}"
if [ $files_with_mermaid -eq 0 ]; then
    echo -e "${BLUE}ℹ️  No Mermaid diagrams in changed files${NC}"
elif [ $errors_found -gt 0 ]; then
    echo -e "${RED}🔴 Found ${errors_found} Mermaid syntax error(s) in ${total_diagrams} diagram(s)${NC}"
else
    echo -e "${GREEN}✅ All ${total_diagrams} Mermaid diagram(s) are valid${NC}"
fi

# Always exit 0 (non-blocking)
exit 0
