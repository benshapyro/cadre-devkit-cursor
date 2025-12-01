#!/bin/bash
# Sensitive File Guard for Cursor
# Protects sensitive files from being read by Tab completions
#
# Input: JSON via stdin with { "file_path": "...", "content": "..." }
# Output: JSON with { "permission": "allow|deny" }

# Read JSON input from stdin
INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | grep -o '"file_path"[[:space:]]*:[[:space:]]*"[^"]*"' | sed 's/"file_path"[[:space:]]*:[[:space:]]*"//' | sed 's/"$//')

# Default to allow
PERMISSION="allow"

# ALLOW example/sample/template files - these don't contain real secrets
if echo "$FILE_PATH" | grep -qiE "\.(example|sample|template|dist)$"; then
    cat << EOF
{
  "permission": "allow"
}
EOF
    exit 0
fi

# Check if file matches sensitive patterns
if echo "$FILE_PATH" | grep -qiE "\.env($|\.)[^.]*$"; then
    PERMISSION="deny"
elif echo "$FILE_PATH" | grep -qiE "(credentials|secrets|\.pem|\.key|\.p12|\.pfx)$"; then
    PERMISSION="deny"
elif echo "$FILE_PATH" | grep -qiE "id_(rsa|ed25519|dsa|ecdsa)$"; then
    PERMISSION="deny"
elif echo "$FILE_PATH" | grep -qiE "\.ssh/config|\.aws/credentials|\.gcloud/|\.azure/"; then
    PERMISSION="deny"
elif echo "$FILE_PATH" | grep -qiE "service.*account.*\.json|firebase.*\.json|google.*credentials"; then
    PERMISSION="deny"
elif echo "$FILE_PATH" | grep -qiE "\.(npmrc|pypirc|netrc)$"; then
    PERMISSION="deny"
elif echo "$FILE_PATH" | grep -qiE "htpasswd|shadow$|passwd$"; then
    PERMISSION="deny"
elif echo "$FILE_PATH" | grep -qiE "\.kube/config|kubeconfig"; then
    PERMISSION="deny"
fi

# Output JSON response
cat << EOF
{
  "permission": "$PERMISSION"
}
EOF
