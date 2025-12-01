#!/bin/bash
# Auto-format hook for Cursor
# Runs formatter after file edits
#
# Input: JSON via stdin with { "file_path": "...", "content": "..." }
# Output: JSON with { "permission": "allow" } (always allow, just format)

# Read JSON input from stdin
INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | grep -o '"file_path"[[:space:]]*:[[:space:]]*"[^"]*"' | sed 's/"file_path"[[:space:]]*:[[:space:]]*"//' | sed 's/"$//')

# Skip if no file path
if [ -z "$FILE_PATH" ]; then
    cat << EOF
{ "permission": "allow" }
EOF
    exit 0
fi

# Get file extension
EXT="${FILE_PATH##*.}"

# Format based on extension
case "$EXT" in
    ts|tsx|js|jsx|json|css|scss|md)
        # Try prettier if available
        if command -v npx &> /dev/null; then
            npx prettier --write "$FILE_PATH" 2>/dev/null
        fi
        ;;
    py)
        # Try black if available
        if command -v black &> /dev/null; then
            black --line-length 100 "$FILE_PATH" 2>/dev/null
        fi
        ;;
esac

# Always allow the edit
cat << EOF
{ "permission": "allow" }
EOF
