#!/bin/bash
# Dangerous Command Blocker for Cursor
# Blocks potentially destructive shell commands
#
# Input: CURSOR_COMMAND environment variable contains the command to execute
# Output: Exit 0 to allow, exit 1 to block

COMMAND="${CURSOR_COMMAND:-$1}"

# Patterns that should be blocked
DANGEROUS_PATTERNS=(
    "rm -rf /"
    "rm -rf /*"
    "rm -rf ~"
    "rm -rf \$HOME"
    ":(){:|:&};:"           # Fork bomb
    "mkfs"
    "dd if=/dev/zero"
    "dd if=/dev/random"
    "> /dev/sda"
    "chmod -R 777 /"
    "chown -R"
    "curl.*|.*sh"           # Pipe curl to shell
    "wget.*|.*sh"           # Pipe wget to shell
    "curl.*|.*bash"
    "wget.*|.*bash"
    "--no-preserve-root"
    "sudo rm -rf"
    "git push.*--force.*main"
    "git push.*--force.*master"
    "git push -f.*main"
    "git push -f.*master"
    "DROP DATABASE"
    "DROP TABLE"
    "TRUNCATE"
    "DELETE FROM.*WHERE 1"
    "npm publish"           # Prevent accidental publishing
    "pip upload"
)

# Check against dangerous patterns
for pattern in "${DANGEROUS_PATTERNS[@]}"; do
    if echo "$COMMAND" | grep -qiE "$pattern"; then
        echo "BLOCKED: Command matches dangerous pattern: $pattern"
        echo "Command: $COMMAND"
        exit 1
    fi
done

# Warn about potentially risky commands (but allow)
WARN_PATTERNS=(
    "rm -rf"
    "git reset --hard"
    "git clean -fd"
    "DROP"
    "DELETE FROM"
)

for pattern in "${WARN_PATTERNS[@]}"; do
    if echo "$COMMAND" | grep -qiE "$pattern"; then
        echo "WARNING: Potentially risky command detected"
        echo "Pattern: $pattern"
        echo "Command: $COMMAND"
        # Allow but warn - exit 0 means allowed
    fi
done

# Allow the command
exit 0
