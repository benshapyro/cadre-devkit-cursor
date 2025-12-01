#!/bin/bash
# Dangerous Command Blocker for Cursor
# Blocks potentially destructive shell commands
#
# Input: JSON via stdin with { "command": "...", "cwd": "..." }
# Output: JSON with { "permission": "allow|deny|ask", "agent_message": "..." }

# Read JSON input from stdin
INPUT=$(cat)
COMMAND=$(echo "$INPUT" | grep -o '"command"[[:space:]]*:[[:space:]]*"[^"]*"' | sed 's/"command"[[:space:]]*:[[:space:]]*"//' | sed 's/"$//')

# Default to allow
PERMISSION="allow"
AGENT_MESSAGE=""

# Patterns that should be blocked
if echo "$COMMAND" | grep -qiE "rm -rf /($|[^a-zA-Z])|rm -rf /\*|rm -rf ~|rm -rf \\\$HOME"; then
    PERMISSION="deny"
    AGENT_MESSAGE="BLOCKED: This command could delete critical system files. Use a safer, more targeted approach."
elif echo "$COMMAND" | grep -qiE ":\(\)\{:\|:&\};:"; then
    PERMISSION="deny"
    AGENT_MESSAGE="BLOCKED: Fork bomb detected. This would crash the system."
elif echo "$COMMAND" | grep -qiE "mkfs\.|dd if=/dev/(zero|random)"; then
    PERMISSION="deny"
    AGENT_MESSAGE="BLOCKED: Disk formatting/overwriting commands are not allowed."
elif echo "$COMMAND" | grep -qiE "chmod -R 777 /|chown -R .* /"; then
    PERMISSION="deny"
    AGENT_MESSAGE="BLOCKED: Recursive permission changes on root are dangerous."
elif echo "$COMMAND" | grep -qiE "(curl|wget).*\|.*(sh|bash)"; then
    PERMISSION="deny"
    AGENT_MESSAGE="BLOCKED: Piping remote scripts directly to shell is a security risk. Download and review first."
elif echo "$COMMAND" | grep -qiE "git push.*(--force|-f).*(main|master)"; then
    PERMISSION="deny"
    AGENT_MESSAGE="BLOCKED: Force pushing to main/master could overwrite team history. Use a feature branch."
elif echo "$COMMAND" | grep -qiE "DROP (DATABASE|TABLE)|TRUNCATE|DELETE FROM.*WHERE 1"; then
    PERMISSION="deny"
    AGENT_MESSAGE="BLOCKED: Destructive SQL commands detected. Review and run manually if intended."
elif echo "$COMMAND" | grep -qiE "npm publish|pip upload"; then
    PERMISSION="ask"
    AGENT_MESSAGE="WARNING: Package publishing detected. Please confirm this is intentional."
elif echo "$COMMAND" | grep -qiE "rm -rf|git reset --hard|git clean -fd"; then
    PERMISSION="ask"
    AGENT_MESSAGE="WARNING: Potentially destructive command. Please review before proceeding."
fi

# Output JSON response
cat << EOF
{
  "permission": "$PERMISSION",
  "agent_message": "$AGENT_MESSAGE"
}
EOF
