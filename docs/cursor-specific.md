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

Cursor hooks (introduced in v1.7) let you run scripts at agent lifecycle points.

### Supported Events

| Event | Can Block | Use Case |
|-------|-----------|----------|
| beforeShellExecution | Yes | Block dangerous commands |
| beforeMCPExecution | Yes | Control MCP tool calls |
| beforeTabFileRead | Yes | Protect sensitive files from Tab |
| beforeSubmitPrompt | Yes | Filter prompts |
| afterFileEdit | No | Format code, logging |
| afterShellExecution | No | Audit commands |
| stop | No | Trigger follow-ups |

### Hook I/O Format

Hooks receive JSON via **stdin** (not environment variables):

```json
{
  "command": "npm install",
  "cwd": "/path/to/project",
  "conversation_id": "uuid",
  "generation_id": "uuid"
}
```

Hooks return JSON via **stdout**:

```json
{
  "permission": "allow",
  "agent_message": "Proceeding with install"
}
```

### Permission Values

| Value | Effect |
|-------|--------|
| `"allow"` | Execute without prompting |
| `"deny"` | Block and send agent_message to AI |
| `"ask"` | Prompt user for confirmation |

### Known Limitations

- Multiple hooks in same array may only execute first one ([bug report](https://forum.cursor.com/t/cursor-hooks-bug-multiple-hooks-in-array-only-execute-first-hook/141996))
- `beforeShellExecution` allow-list can override hook permissions
- Hooks are still in beta - API may change

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
