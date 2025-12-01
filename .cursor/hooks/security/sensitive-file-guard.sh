#!/bin/bash
# Sensitive File Guard for Cursor
# Protects sensitive files from accidental access or modification
#
# Input: CURSOR_FILE_PATH environment variable contains the file path
# Output: Exit 0 to allow, exit 1 to block

FILE_PATH="${CURSOR_FILE_PATH:-$1}"
OPERATION="${CURSOR_OPERATION:-read}"  # read or write

# Sensitive file patterns that should be protected
SENSITIVE_PATTERNS=(
    "\.env$"
    "\.env\."
    "\.env\.local"
    "\.env\.production"
    "\.env\.development"
    "credentials"
    "secrets"
    "\.pem$"
    "\.key$"
    "\.p12$"
    "\.pfx$"
    "id_rsa"
    "id_ed25519"
    "id_dsa"
    "\.ssh/config"
    "\.aws/credentials"
    "\.gcloud/"
    "\.azure/"
    "service.*account.*\.json"
    "firebase.*\.json"
    "google.*credentials.*\.json"
    "\.npmrc"
    "\.pypirc"
    "\.netrc"
    "htpasswd"
    "shadow$"
    "passwd$"
    "\.kube/config"
    "kubeconfig"
)

# Check if file matches sensitive patterns
for pattern in "${SENSITIVE_PATTERNS[@]}"; do
    if echo "$FILE_PATH" | grep -qiE "$pattern"; then
        if [ "$OPERATION" = "write" ]; then
            echo "BLOCKED: Cannot write to sensitive file"
            echo "File: $FILE_PATH"
            echo "Pattern matched: $pattern"
            exit 1
        else
            echo "WARNING: Accessing sensitive file"
            echo "File: $FILE_PATH"
            echo "Pattern matched: $pattern"
            # Allow read but warn
            exit 0
        fi
    fi
done

# Allow access
exit 0
