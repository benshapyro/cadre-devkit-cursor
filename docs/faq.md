# Frequently Asked Questions

## Installation

### Q: Can I use this alongside my existing .cursor directory?

Yes. Merge the contents:
```bash
cp -r cadre-devkit-cursor/.cursor/rules/* ~/.cursor/rules/
cp -r cadre-devkit-cursor/.cursor/commands/* ~/.cursor/commands/
```

### Q: Do I need to restart Cursor after changes?

Yes, for rule changes. Command changes are picked up immediately.

### Q: Can I use this globally across all projects?

Yes, symlink to your home directory:
```bash
ln -s /path/to/cadre-devkit-cursor/.cursor ~/.cursor
```

## Rules

### Q: How do I know which rules are active?

Check Cursor's AI context panel. Active rules are listed there.

### Q: Can I disable specific rules?

Set `alwaysApply: false` and remove the `globs` array, or delete the rule file.

### Q: Why isn't my rule activating?

Check:
1. File pattern matches open files (for glob rules)
2. Description matches your task (for description rules)
3. `alwaysApply` is set correctly

### Q: How do I create custom rules?

Create a new `.mdc` file in `.cursor/rules/`:
```yaml
---
description: "When to activate"
globs: ["**/*.custom"]
---

# Your Rule

Content here...
```

## Commands

### Q: Commands aren't appearing with @ prefix

Ensure:
1. Files are in `.cursor/commands/`
2. Files have `.md` extension
3. Restart Cursor

### Q: Can I add arguments to commands?

Yes, use `$ARGUMENTS` in your command:
```markdown
# My Command

Processing: $ARGUMENTS
```

### Q: How do I create custom commands?

Add a `.md` file to `.cursor/commands/`:
```markdown
# Custom Command

Instructions for the AI...
```

## Hooks

### Q: Hooks aren't running

Check:
1. `hooks.json` has `"version": 1` at top level
2. Script files are executable (`chmod +x`)
3. Script paths are relative to `hooks.json` location
4. Scripts output valid JSON to stdout

### Q: How do I debug hooks?

Write debug info to a file (stderr goes nowhere):
```bash
echo "$INPUT" >> /tmp/hook-debug.log
```

Or check Cursor's Developer Tools (Help > Toggle Developer Tools).

### Q: Can hooks block file writes?

No. `afterFileEdit` runs after edits complete. For blocking, consider:
- Using `beforeShellExecution` to block dangerous commands
- Using `beforeTabFileRead` to prevent Tab from reading sensitive files

### Q: My hook returns "deny" but command still runs

Known issue: Cursor's allow-list can override hook permissions. If a command is in your allow-list, the hook's "deny" may not work. See [bug report](https://forum.cursor.com/t/beforeshellexecution-hook-permissions-allow-ask-ignored-allow-list-takes-precedence/144244).

## Workflow

### Q: What's the difference between @plan and Plan Mode?

- `@plan` - Custom planning format with documentation output
- Plan Mode (Shift+Tab) - Native Cursor feature with checkpoints

Use Plan Mode for implementation, `@plan` for planning documentation.

### Q: When should I use @validate vs running tests manually?

`@validate` runs all checks (types, lint, tests, build) and generates a report. Use it before every `@ship`.

### Q: Can I skip steps in the workflow?

Yes, but not recommended. The workflow ensures quality:
- Skip `@plan` for simple fixes
- Never skip `@validate` before `@ship`
- `@review` can be skipped for trivial changes

## Troubleshooting

### Q: AI responses seem to ignore rules

1. Check if rules are in the context panel
2. Verify rule syntax (YAML frontmatter)
3. Try more specific globs or descriptions

### Q: Hooks are blocking legitimate commands

Edit the patterns in the hook scripts. Remove or modify overly aggressive patterns.

### Q: Performance is slow with all rules

1. Reduce `alwaysApply: true` rules
2. Use narrower glob patterns
3. Split large rules into focused ones

## Migration

### Q: I'm coming from Claude Code, what's different?

| Claude Code | Cursor |
|-------------|--------|
| CLAUDE.md | .cursor/rules/*.mdc |
| /command | @command |
| hooks.json format | Different schema |
| Subagents | Worktrees + agents |

### Q: Can I use the same MCP servers?

Yes, MCP configuration is 99% compatible. Just add to Cursor settings.

### Q: What about Claude Code plugins?

Convert plugins to rules:
- skills/ → rules with globs
- agents/ → rules with descriptions
- commands/ → commands/
