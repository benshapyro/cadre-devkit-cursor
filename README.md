# Cadre DevKit for Cursor

A comprehensive development kit that brings Cadre's coding standards, workflows, and AI-assisted development patterns to Cursor IDE.

## Quick Start

1. **Copy to your project:**
   ```bash
   cp -r .cursor/ /path/to/your/project/
   ```

2. **Or symlink for global use:**
   ```bash
   ln -s /path/to/cadre-devkit-cursor/.cursor ~/.cursor
   ```

3. **Restart Cursor** to load the new rules and commands.

## What's Included

### Rules (`.cursor/rules/`)

Rules are automatically applied based on file patterns or descriptions:

| Rule | Type | Description |
|------|------|-------------|
| `001-global` | Always On | Core coding standards |
| `002-confidence` | Always On | Confidence checking protocol |
| `003-selfcheck` | Always On | Post-implementation validation |
| `100-api-design` | Pattern | API design patterns |
| `101-code-style` | Pattern | TypeScript/Python style |
| `102-documentation` | Pattern | Documentation standards |
| `103-error-handling` | Pattern | Error handling patterns |
| `200-testing` | Pattern | Testing standards |
| `300-code-reviewer` | On-Demand | Code review specialist |
| `301-debugger` | On-Demand | Debugging specialist |
| `302-git-helper` | On-Demand | Git workflow assistant |
| `303-doc-researcher` | On-Demand | Documentation researcher |

### Commands (`.cursor/commands/`)

Invoke commands with `@command-name` in the chat:

- **`@plan`** - Plan a new feature with proper structure
- **`@review`** - Review code changes for quality
- **`@validate`** - Run all validations before shipping
- **`@ship`** - Commit validated changes

### Hooks (`.cursor/hooks/`)

Hooks using Cursor's lifecycle hook system (v1.7+):

**Security (before events)**
- **beforeShellExecution** - Blocks destructive shell commands (rm -rf, force push, etc.)
- **beforeTabFileRead** - Prevents Tab from reading sensitive files (.env, credentials, keys)
  - Allows `.example`, `.sample`, `.template` files

**Automation (after events)**
- **afterFileEdit** - Runs Prettier/Black to auto-format edited files

Hooks receive JSON via stdin and return JSON permission responses.

## Workflow

```
@plan "feature" → implement → @review → @validate → @ship
```

1. **Plan** - Use `@plan` or Cursor's Plan Mode (Shift+Tab)
2. **Implement** - Write code with rule guidance
3. **Review** - Run `@review` for quality check
4. **Validate** - Run `@validate` for tests/lint/build
5. **Ship** - Run `@ship` to commit

## Cursor-Specific Features

### Plan Mode

Use Cursor's native Plan Mode (Shift+Tab) for complex features. It provides:
- Structured planning with checkpoints
- Automatic context gathering
- Step-by-step implementation tracking

### Agent Mode

For parallel work:
- Use git worktrees for multiple features
- Cursor supports up to 8 parallel agents
- Each agent can work in its own worktree

### MCP Servers

This devkit is compatible with MCP servers. Add your servers to Cursor settings and they'll work alongside these rules.

## Configuration

### Enable/Disable Rules

Edit the `alwaysApply` field in rule frontmatter:
```yaml
---
alwaysApply: false  # Only apply when relevant
---
```

### Customize Hooks

Edit `hooks.json` to add hook triggers. Cursor hooks use a simple format:
```json
{
  "version": 1,
  "hooks": {
    "beforeShellExecution": [
      { "command": "./my-hook.sh" }
    ],
    "afterFileEdit": [
      { "command": "./format-code.sh" }
    ]
  }
}
```

Hooks receive JSON via stdin and return JSON responses. See [Cursor Hooks Docs](https://cursor.com/docs/agent/hooks).

## Documentation

- [Getting Started](docs/getting-started.md)
- [Components Guide](docs/components.md)
- [Cursor-Specific Features](docs/cursor-specific.md)
- [FAQ](docs/faq.md)

## Related

- [cadre-devkit-claude](https://github.com/benshapyro/cadre-devkit-claude) - Same patterns for Claude Code

## License

MIT
