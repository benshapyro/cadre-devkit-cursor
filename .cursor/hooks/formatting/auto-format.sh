#!/bin/bash
# Auto-Format Hook for Cursor
# Runs Prettier/Black after file edits
#
# Input: JSON via stdin with { "path": "..." }
# Output: JSON with { "message": "..." } (informational)
#
# Debug: Set CURSOR_HOOK_DEBUG=1 to enable verbose logging

DEBUG="${CURSOR_HOOK_DEBUG:-0}"

debug() {
    if [ "$DEBUG" = "1" ]; then
        echo "[auto-format] $1" >&2
    fi
}

# Read JSON input from stdin
INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | grep -o '"path"[[:space:]]*:[[:space:]]*"[^"]*"' | sed 's/"path"[[:space:]]*:[[:space:]]*"//' | sed 's/"$//')

debug "Checking file: $FILE_PATH"

# Get extension
EXT="${FILE_PATH##*.}"
MESSAGE=""

case "$EXT" in
    ts|tsx|js|jsx|json|md|yaml|yml)
        debug "Running prettier"
        if command -v npx &> /dev/null; then
            OUTPUT=$(npx prettier --write "$FILE_PATH" 2>&1)
            if [ $? -eq 0 ]; then
                MESSAGE="Formatted with Prettier"
                debug "Prettier success"
            else
                MESSAGE="Prettier failed: $OUTPUT"
                debug "Prettier failed: $OUTPUT"
            fi
        fi
        ;;
    py)
        debug "Running black"
        if command -v black &> /dev/null; then
            OUTPUT=$(black "$FILE_PATH" 2>&1)
            if [ $? -eq 0 ]; then
                MESSAGE="Formatted with Black"
                debug "Black success"
            else
                MESSAGE="Black failed: $OUTPUT"
                debug "Black failed: $OUTPUT"
            fi
        fi
        ;;
    *)
        debug "No formatter for extension: $EXT"
        ;;
esac

# Output JSON response
cat << EOF
{
  "message": "$MESSAGE"
}
EOF
