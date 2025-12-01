# Components Guide

## Rules

Rules are MDC (Markdown with Configuration) files that provide context-aware guidance to Cursor's AI.

### Rule Structure

```yaml
---
description: "When this rule applies"
globs: ["**/*.ts", "**/*.tsx"]  # Optional: file patterns
alwaysApply: false              # Optional: always include
---

# Rule Title

Rule content in Markdown...
```

### Core Rules (001-003)

These rules are always active and establish fundamental standards:

#### 001-global.mdc
- Core coding principles (DRY, KISS, YAGNI)
- Naming conventions
- Universal best practices

#### 002-confidence.mdc
- Pre-implementation confidence checking
- Structured questions before coding
- Prevents premature implementation

#### 003-selfcheck.mdc
- Post-implementation validation
- Evidence-based verification
- Quality assurance protocol

### Skill Rules (100-200)

Activated by file patterns when relevant files are open:

#### 100-api-design.mdc
- REST/GraphQL patterns
- Request/response structures
- Error response formats
- Globs: `**/api/**/*`, `**/routes/**/*`

#### 101-code-style.mdc
- TypeScript/Python formatting
- Naming conventions
- Import organization
- Globs: `**/*.ts`, `**/*.py`

#### 102-documentation.mdc
- README templates
- API documentation
- Inline comment standards
- Globs: `**/*.md`, `**/docs/**/*`

#### 103-error-handling.mdc
- Try/catch patterns
- Error types and classes
- Logging best practices
- Globs: `**/*.ts`, `**/*.py`

#### 200-testing.mdc
- Jest/Pytest patterns
- Arrange-Act-Assert structure
- Test organization
- Globs: `**/*.test.*`, `**/tests/**/*`

### Agent Rules (300-303)

Activated by description when the task matches:

#### 300-code-reviewer.mdc
- Activates for: "code review", "PR review", "quality check"
- Provides structured review checklist
- Outputs review summary format

#### 301-debugger.mdc
- Activates for: "bug", "error", "exception", "stack trace"
- Systematic debugging methodology
- Root cause analysis format

#### 302-git-helper.mdc
- Activates for: "commit", "branch", "merge", "git"
- Branch naming conventions
- Commit message formats

#### 303-doc-researcher.mdc
- Activates for: "docs", "documentation", "API reference"
- Research methodology
- Documentation summary format

## Commands

Commands are invoked with `@command-name` in the Cursor chat.

### @plan

Structured feature planning:
1. Gathers codebase context
2. Asks clarifying questions
3. Creates implementation plan
4. Awaits approval

### @review

Code quality review:
1. Gets changed files from git
2. Applies review checklist
3. Generates review summary
4. Provides verdict

### @validate

Pre-commit validation:
1. Runs type checking
2. Runs linting
3. Runs tests
4. Checks build
5. Generates report

### @ship

Commit workflow:
1. Verifies validation passed
2. Analyzes changes
3. Generates commit message
4. Creates commit

## Hooks

Cursor hooks (v1.7+) intercept agent actions at defined lifecycle points.

### hooks.json

Configuration file with version and hook definitions:

```json
{
  "version": 1,
  "hooks": {
    "beforeShellExecution": [
      { "command": "./security/dangerous-command-blocker.sh" }
    ],
    "beforeTabFileRead": [
      { "command": "./security/sensitive-file-guard.sh" }
    ]
  }
}
```

### Hook Input/Output

Hooks receive JSON via stdin and return JSON via stdout:

**beforeShellExecution input:**
```json
{
  "command": "rm -rf /tmp/test",
  "cwd": "/home/user/project",
  "conversation_id": "...",
  "generation_id": "..."
}
```

**beforeShellExecution output:**
```json
{
  "permission": "allow",  // or "deny" or "ask"
  "agent_message": "Optional message to the AI"
}
```

### dangerous-command-blocker.sh

**Blocks (permission: deny):**
- `rm -rf /` and variants
- Fork bombs
- Disk formatting commands
- Force pushes to main/master
- SQL destructive commands
- Piping curl/wget to shell

**Warns (permission: ask):**
- `rm -rf` (non-root paths)
- `git reset --hard`
- `npm publish`

### sensitive-file-guard.sh

**Blocks Tab from reading:**
- `.env` files (all variants)
- SSH keys (`id_rsa`, `id_ed25519`)
- Cloud credentials (AWS, GCP, Azure)
- API tokens and secrets
- Kubernetes configs

Note: This only affects Tab completions (`beforeTabFileRead`). Agent file reads are not blocked by default.
