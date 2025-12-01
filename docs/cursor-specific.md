# Cursor-Specific Features

This guide covers features unique to Cursor and how to use them effectively with the Cadre DevKit.

## Plan Mode

Cursor's native Plan Mode (Shift+Tab) is excellent for complex features.

### When to Use Plan Mode

- Multi-file refactoring
- New feature implementation
- Complex bug fixes
- Architecture changes

### Plan Mode vs @plan Command

| Feature | Plan Mode | @plan Command |
|---------|-----------|---------------|
| Structured checkpoints | Yes | No |
| Automatic context | Yes | Manual |
| Step-by-step tracking | Yes | No |
| Custom output format | No | Yes |

**Recommendation:** Use Plan Mode for implementation, `@plan` for documentation.

## Agent Mode and Parallelism

Cursor supports parallel agents for faster development.

### Git Worktrees for Parallel Work

```bash
# Create worktree for feature
git worktree add ../project-feature-a feat/feature-a

# Open in new Cursor window
cursor ../project-feature-a
```

### Parallel Agent Limits

- Cursor supports up to 8 parallel agents
- Each agent should work in its own worktree
- Avoid conflicts by assigning different files

### Best Practices

1. **Separate concerns** - Each agent works on independent files
2. **Clear boundaries** - Define file ownership per agent
3. **Merge strategy** - Decide merge order before starting

## MCP Server Integration

Cursor supports Model Context Protocol (MCP) servers.

### Adding MCP Servers

In Cursor settings, add your MCP configuration:

```json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem"]
    }
  }
}
```

### MCP Limitations

- **40-tool limit** - Cursor limits total MCP tools
- **Same syntax** - Configuration is 99% compatible with Claude Code
- **Discovery** - Use `/mcp` to see available tools

## Rules System

### MDC Format

Cursor rules use MDC (Markdown with Configuration):

```yaml
---
description: "Description for context matching"
globs: ["**/*.ts"]  # File pattern matching
alwaysApply: true   # Always include in context
---

# Rule content
```

### Activation Methods

1. **alwaysApply: true** - Always active
2. **globs** - Active when matching files are open
3. **description** - Active when task description matches

### Rule Priority

When multiple rules could apply:
1. Always-apply rules first
2. Glob-matched rules second
3. Description-matched rules third

## Hooks System

### Supported Events

| Event | Can Block | Use Case |
|-------|-----------|----------|
| beforeShellExecution | Yes | Block dangerous commands |
| beforeReadFile | Yes | Protect sensitive files |
| beforeWriteFile | Yes | Prevent bad edits |
| afterFileEdit | No | Logging, validation |

### Hook Scripts

Hooks receive context via environment variables:
- `CURSOR_COMMAND` - Shell command being executed
- `CURSOR_FILE_PATH` - File being accessed
- `CURSOR_OPERATION` - read/write operation type

### Blocking vs Warning

- Exit code 0 = Allow (with optional warning)
- Exit code 1 = Block operation

## Keyboard Shortcuts

| Shortcut | Action |
|----------|--------|
| Cmd+L | Open AI chat |
| Shift+Tab | Enter Plan Mode |
| Cmd+K | Inline edit |
| Cmd+Shift+K | Multi-file edit |
| @ | Command prefix |

## Performance Tips

1. **Keep rules focused** - Smaller rules load faster
2. **Use globs wisely** - Narrow patterns reduce overhead
3. **Limit always-apply** - Only essential rules should be always-on
4. **Prune MCP tools** - Stay under the 40-tool limit
