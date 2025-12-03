#!/bin/bash
# Dangerous Command Blocker for Cursor
# Blocks potentially destructive shell commands
#
# Input: JSON via stdin with { "command": "...", "cwd": "..." }
# Output: JSON with { "permission": "allow|deny|ask", "agent_message": "..." }
#
# Debug: Set CURSOR_HOOK_DEBUG=1 to enable verbose logging

DEBUG="${CURSOR_HOOK_DEBUG:-0}"

debug() {
    if [ "$DEBUG" = "1" ]; then
        echo "[dangerous-command-blocker] $1" >&2
    fi
}

# Read JSON input from stdin
INPUT=$(cat)
COMMAND=$(echo "$INPUT" | grep -o '"command"[[:space:]]*:[[:space:]]*"[^"]*"' | sed 's/"command"[[:space:]]*:[[:space:]]*"//' | sed 's/"$//')

debug "Checking command: $COMMAND"

# Default to allow
PERMISSION="allow"
AGENT_MESSAGE=""

# Patterns that should be blocked
if echo "$COMMAND" | grep -qiE "rm\s+-rf\s+/($|[^a-zA-Z])|rm\s+-rf\s+~|rm\s+-rf\s+\*"; then
    PERMISSION="deny"
    AGENT_MESSAGE="BLOCKED: Recursive delete from root/home. Use a safer, more targeted approach."
    debug "BLOCKED: Recursive delete"
elif echo "$COMMAND" | grep -qiE ":\(\)\{:\|:&\};:"; then
    PERMISSION="deny"
    AGENT_MESSAGE="BLOCKED: Fork bomb detected."
    debug "BLOCKED: Fork bomb"
elif echo "$COMMAND" | grep -qiE "mkfs\.|dd if=/dev/(zero|random)"; then
    PERMISSION="deny"
    AGENT_MESSAGE="BLOCKED: Disk formatting/overwriting not allowed."
    debug "BLOCKED: Disk operation"
elif echo "$COMMAND" | grep -qiE "chmod\s+(-R\s+)?777|chmod\s+(-R\s+)?a\+rwx"; then
    PERMISSION="deny"
    AGENT_MESSAGE="BLOCKED: World-writable permissions (777) are dangerous."
    debug "BLOCKED: chmod 777"
elif echo "$COMMAND" | grep -qiE "sudo\s+"; then
    PERMISSION="ask"
    AGENT_MESSAGE="WARNING: Elevated privileges requested. Please confirm."
    debug "ASK: sudo detected"
elif echo "$COMMAND" | grep -qiE "(curl|wget).*\|.*(sh|bash)"; then
    PERMISSION="deny"
    AGENT_MESSAGE="BLOCKED: Piping remote scripts to shell is a security risk."
    debug "BLOCKED: curl|bash"
elif echo "$COMMAND" | grep -qiE "git push.*(--force|-f).*(main|master)"; then
    PERMISSION="deny"
    AGENT_MESSAGE="BLOCKED: Force pushing to main/master."
    debug "BLOCKED: force push main"
elif echo "$COMMAND" | grep -qiE "npm\s+publish|pip\s+upload"; then
    PERMISSION="ask"
    AGENT_MESSAGE="WARNING: Package publishing detected. Please confirm."
    debug "ASK: package publish"
elif echo "$COMMAND" | grep -qiE ">\s*/dev/(?!null|zero|u?random)"; then
    PERMISSION="deny"
    AGENT_MESSAGE="BLOCKED: Write to system device."
    debug "BLOCKED: device write"
fi

debug "Result: $PERMISSION"

# Output JSON response
cat << EOF
{
  "permission": "$PERMISSION",
  "agent_message": "$AGENT_MESSAGE"
}
EOF
