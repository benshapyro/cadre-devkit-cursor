# Hook Development Guide for Cursor

A guide to creating custom hooks for Cursor IDE.

## Overview

Cursor hooks allow you to run custom scripts before or after certain events. They enable:
- **Security guards** - Block dangerous operations
- **Automation** - Auto-format code
- **Validation** - Check inputs before execution

## Hook Types

### Before Hooks (can block)
- `beforeShellExecution` - Before running shell commands
- `beforeTabFileRead` - Before Tab reads a file

**Output to block:**
```json
{ "permission": "deny", "agent_message": "Reason for blocking" }
```

### After Hooks (react only)
- `afterFileEdit` - After a file is edited

**Output (informational):**
```json
{ "message": "What happened" }
```

## Configuration

Hooks are configured in `.cursor/hooks/hooks.json`:

```json
{
  "version": 1,
  "hooks": {
    "beforeShellExecution": [
      { "command": "./security/dangerous-command-blocker.sh" }
    ],
    "beforeTabFileRead": [
      { "command": "./security/sensitive-file-guard.sh" }
    ],
    "afterFileEdit": [
      { "command": "./formatting/auto-format.sh" }
    ]
  }
}
```

## Hook Input

Hooks receive JSON on stdin:

**beforeShellExecution:**
```json
{ "command": "npm test", "cwd": "/project" }
```

**beforeTabFileRead:**
```json
{ "path": "/project/.env" }
```

**afterFileEdit:**
```json
{ "path": "/project/src/app.ts" }
```

## Hook Template (Bash)

```bash
#!/bin/bash
# My Custom Hook
# Debug: Set CURSOR_HOOK_DEBUG=1 to enable verbose logging

DEBUG="${CURSOR_HOOK_DEBUG:-0}"

debug() {
    if [ "$DEBUG" = "1" ]; then
        echo "[my-hook] $1" >&2
    fi
}

# Read JSON input
INPUT=$(cat)
VALUE=$(echo "$INPUT" | grep -o '"key":"[^"]*"' | sed 's/"key":"//' | sed 's/"$//')

debug "Received: $VALUE"

# Your logic here
PERMISSION="allow"
AGENT_MESSAGE=""

# Output JSON
echo '{"permission":"'"$PERMISSION"'","agent_message":"'"$AGENT_MESSAGE"'"}'
```

## Debugging

Enable debug mode:
```bash
export CURSOR_HOOK_DEBUG=1
```

Test hook directly:
```bash
echo '{"command":"rm -rf /"}' | ./dangerous-command-blocker.sh
```

## Directory Structure

```
.cursor/
├── hooks/
│   ├── hooks.json
│   ├── security/
│   │   ├── dangerous-command-blocker.sh
│   │   └── sensitive-file-guard.sh
│   └── formatting/
│       └── auto-format.sh
├── rules/
└── commands/
```
