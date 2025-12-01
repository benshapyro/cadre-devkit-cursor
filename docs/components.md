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

Security hooks that intercept dangerous operations.

### hooks.json

Configuration file that maps events to scripts:

```json
{
  "beforeShellExecution": [...],
  "beforeReadFile": [...],
  "beforeWriteFile": [...]
}
```

### dangerous-command-blocker.sh

Blocks:
- `rm -rf /` and variants
- Fork bombs
- Disk formatting commands
- Force pushes to main/master
- SQL destructive commands

Warns:
- `rm -rf` (non-root)
- `git reset --hard`
- `DROP` statements

### sensitive-file-guard.sh

Protects:
- `.env` files (all variants)
- SSH keys
- Cloud credentials (AWS, GCP, Azure)
- API tokens and secrets
- Kubernetes configs

Read operations are warned but allowed.
Write operations to sensitive files are blocked.
