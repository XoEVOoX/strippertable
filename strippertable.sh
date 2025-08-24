#!/bin/bash

# A script to format content into a Markdown table for Obsidian.
# Automatically splits content into columns with optional text styling.

# Default values
MAX_ROWS=10
STYLE=""

# Parse command-line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -r|--rows)
            MAX_ROWS="$2"
            shift 2
            ;;
        -s|--style)
            case $2 in
                code|c)
                    STYLE="code"
                    ;;
                bold|b)
                    STYLE="bold"
                    ;;
                italic|i)
                    STYLE="italic"
                    ;;
                none|n)
                    STYLE=""
                    ;;
                *)
                    echo "Error: Invalid style '$2'. Use: code, bold, italic, or none"
                    exit 1
                    ;;
            esac
            shift 2
            ;;
        -h|--help)
            echo "Usage: $0 [options] < input.txt"
            echo "Options:"
            echo "  -r, --rows NUM      Maximum rows per column (default: 10)"
            echo "  -s, --style STYLE   Text styling: code, bold, italic, none (default: none)"
            echo "  -h, --help          Show this help message"
            echo ""
            echo "Examples:"
            echo "  cat input.txt | $0 -r 15 -s code"
            echo "  $0 --rows 20 --style bold < input.txt"
            exit 0
            ;;
        *)
            # Support legacy positional argument for max rows
            if [[ $1 =~ ^[0-9]+$ ]]; then
                MAX_ROWS=$1
            else
                echo "Error: Unknown option '$1'"
                exit 1
            fi
            shift
            ;;
    esac
done

# Check if input is provided via stdin
if [ -t 0 ]; then
    echo "Usage: $0 [options] < input.txt"
    echo "Use '$0 --help' for more information."
    exit 1
fi

# Read and clean input lines
mapfile -t lines < <(sed -E 's/\(.*?\)//g; s/\[|\]//g; s/^[[:space:]]*//;s/[[:space:]]*$//' -)

# Filter out blank lines
filtered_lines=()
for line in "${lines[@]}"; do
    if [[ -n "$line" ]]; then
        filtered_lines+=("$line")
    fi
done

lines=("${filtered_lines[@]}")
TOTAL_LINES=${#lines[@]}

if [ "$TOTAL_LINES" -eq 0 ]; then
    exit 0
fi

# Calculate number of columns needed
NUM_COLUMNS=$(( (TOTAL_LINES + MAX_ROWS - 1) / MAX_ROWS ))

# Function to apply styling to content
apply_style() {
    local content="$1"
    case $STYLE in
        code)
            # Escape existing backticks
            content=$(echo "$content" | sed 's/`/\\`/g')
            echo "\`$content\`"
            ;;
        bold)
            echo "**$content**"
            ;;
        italic)
            echo "*$content*"
            ;;
        *)
            echo "$content"
            ;;
    esac
}

# Print table header
header_row="|"
separator_row="|"
for ((i=1; i<=NUM_COLUMNS; i++)); do
    header_row+=" Column $i |"
    separator_row+="---|"
done
echo "$header_row"
echo "$separator_row"

# Print table content
for ((i=0; i<MAX_ROWS; i++)); do
    row_content="|"
    for ((j=0; j<NUM_COLUMNS; j++)); do
        line_index=$((j * MAX_ROWS + i))
        
        if [ $line_index -lt $TOTAL_LINES ]; then
            content="${lines[$line_index]}"
            styled_content=$(apply_style "$content")
            row_content+=" $styled_content |"
        else
            row_content+=" |"
        fi
    done
    echo "$row_content"
done