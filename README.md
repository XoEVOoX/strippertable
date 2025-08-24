# strippertable.sh

A bash script that formats content into Markdown tables, perfect for Obsidian note-taking. Takes a list of items and organizes them into columns with optional text styling.

## Features

- Automatically splits long lists into multiple columns
- Optional text styling (code blocks, bold, italic)
- Cleans input by removing brackets and parentheses
- Configurable number of rows per column
- Works with pipes and input redirection

## Installation

Make the script executable:
```bash
chmod +x strippertable.sh
```

## Usage

### Basic Usage
```bash
# Using pipes
cat mylist.txt | ./strippertable.sh

# Using input redirection  
./strippertable.sh < mylist.txt
```

### Options

| Option | Short | Description | Default |
|--------|-------|-------------|---------|
| `--rows NUM` | `-r` | Maximum rows per column | 10 |
| `--style STYLE` | `-s` | Text styling option | none |
| `--help` | `-h` | Show help message | - |

### Style Options

- `code` or `c` - Wraps items in backticks for inline code
- `bold` or `b` - Makes items bold with `**text**`
- `italic` or `i` - Makes items italic with `*text*`
- `none` or `n` - No styling (default)

### Examples

```bash
# Create a 3-column table with code styling
cat technologies.txt | ./strippertable.sh -r 15 -s code

# Bold styling with 20 rows per column
./strippertable.sh --rows 20 --style bold < features.txt

# Legacy format (backward compatible)
cat list.txt | ./strippertable.sh 12
```

## Input Processing

The script automatically:
- Removes content within parentheses: `Item (description)` → `Item`
- Removes square brackets: `[Tag] Item` → `Item`
- Trims whitespace from line beginnings and ends
- Filters out empty lines

## Sample Input/Output

**Input file (technologies.txt):**
```
JavaScript [Frontend]
Python (Data Science)
React
Node.js
Docker
Kubernetes
```

**Command:**
```bash
cat technologies.txt | ./strippertable.sh -r 3 -s code
```

**Output:**
```markdown
| Column 1 | Column 2 |
|---|---|
| `JavaScript` | `Docker` |
| `Python` | `Kubernetes` |
| `React` | |
| `Node.js` | |
```

## Use Cases

- Converting reading lists into organized tables
- Creating technology stacks or tool inventories
- Organizing research topics or references
- Making comparison tables from simple lists
- Formatting data for Obsidian vaults

## Obsidian Integration

This script is particularly useful for Obsidian users who want to:
- Convert bullet point lists into tables
- Create structured comparisons
- Avoid formatting conflicts with special characters
- Generate consistent table layouts

The `code` style is especially helpful in Obsidian as it prevents certain characters from being interpreted as markdown formatting.
