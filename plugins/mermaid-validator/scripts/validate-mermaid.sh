#!/bin/bash
# Mermaid Diagram Validator
# Validates Mermaid syntax in all Markdown files at session end

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

# Create temp directory for validation
TEMP_DIR=$(mktemp -d)
trap "rm -rf $TEMP_DIR" EXIT

# Find all markdown files
mapfile -t md_files < <(find "$PROJECT_DIR" -name "*.md" -type f 2>/dev/null | grep -v node_modules | grep -v .git)

if [ ${#md_files[@]} -eq 0 ]; then
    echo -e "${BLUE}ℹ️  No Markdown files found in project${NC}"
    exit 0
fi

errors_found=0
files_with_mermaid=0
total_diagrams=0

echo -e "${BLUE}🔍 Validating Mermaid diagrams...${NC}"

for file in "${md_files[@]}"; do
    # Skip if file doesn't exist or is empty
    [ -f "$file" ] || continue

    # Check if file contains mermaid blocks
    if ! grep -q '```mermaid' "$file" 2>/dev/null; then
        continue
    fi

    ((files_with_mermaid++))

    # Extract mermaid blocks with line numbers
    # Using awk to get content between ```mermaid and ```
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
    echo -e "${BLUE}ℹ️  No Mermaid diagrams found in project${NC}"
elif [ $errors_found -gt 0 ]; then
    echo -e "${RED}🔴 Found ${errors_found} Mermaid syntax error(s) in ${total_diagrams} diagram(s)${NC}"
else
    echo -e "${GREEN}✅ All ${total_diagrams} Mermaid diagram(s) are valid${NC}"
fi

# Always exit 0 (non-blocking)
exit 0
