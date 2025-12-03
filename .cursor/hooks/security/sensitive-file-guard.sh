#!/bin/bash
# Sensitive File Guard for Cursor
# Prevents reading sensitive files like .env, credentials, keys
#
# Input: JSON via stdin with { "path": "..." }
# Output: JSON with { "permission": "allow|deny", "agent_message": "..." }
#
# Debug: Set CURSOR_HOOK_DEBUG=1 to enable verbose logging

DEBUG="${CURSOR_HOOK_DEBUG:-0}"

debug() {
    if [ "$DEBUG" = "1" ]; then
        echo "[sensitive-file-guard] $1" >&2
    fi
}

# Read JSON input from stdin
INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | grep -o '"path"[[:space:]]*:[[:space:]]*"[^"]*"' | sed 's/"path"[[:space:]]*:[[:space:]]*"//' | sed 's/"$//')

debug "Checking file: $FILE_PATH"

# Default to allow
PERMISSION="allow"
AGENT_MESSAGE=""

# Get filename
FILENAME=$(basename "$FILE_PATH" | tr '[:upper:]' '[:lower:]')

# Allow .example, .sample, .template files
if echo "$FILENAME" | grep -qiE "\.(example|sample|template)$"; then
    debug "Allowing template file: $FILENAME"
    PERMISSION="allow"
# Block sensitive filenames
elif echo "$FILENAME" | grep -qiE "^\.env$|^\.env\.|credentials|secrets?\."; then
    PERMISSION="deny"
    AGENT_MESSAGE="BLOCKED: Sensitive file (environment/credentials). Use .env.example for documentation."
    debug "BLOCKED: env/credentials file"
elif echo "$FILENAME" | grep -qiE "^id_rsa|^id_ed25519|^id_ecdsa|\.pem$|\.key$"; then
    PERMISSION="deny"
    AGENT_MESSAGE="BLOCKED: Private key file detected."
    debug "BLOCKED: private key"
elif echo "$FILENAME" | grep -qiE "^\.npmrc$|^\.pypirc$"; then
    PERMISSION="deny"
    AGENT_MESSAGE="BLOCKED: Package registry credentials."
    debug "BLOCKED: registry credentials"
# Block sensitive directories
elif echo "$FILE_PATH" | grep -qiE "\.ssh/|\.gnupg/|\.aws/|\.kube/|\.docker/|\.terraform/"; then
    PERMISSION="deny"
    AGENT_MESSAGE="BLOCKED: Sensitive directory (credentials/keys)."
    debug "BLOCKED: sensitive directory"
fi

debug "Result: $PERMISSION"

# Output JSON response
cat << EOF
{
  "permission": "$PERMISSION",
  "agent_message": "$AGENT_MESSAGE"
}
EOF
