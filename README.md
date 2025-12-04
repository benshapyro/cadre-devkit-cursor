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

Rules are automatically applied based on file patterns:

| Rule | Type | Description |
|------|------|-------------|
| `001-global` | Always | Core coding standards |
| `002-confidence` | Always | Pre-implementation confidence check |
| `003-selfcheck` | Always | Post-implementation validation |
| `100-api-design` | Pattern | REST & GraphQL patterns |
| `101-code-style` | Pattern | TypeScript/Python style |
| `102-documentation` | Pattern | Documentation standards |
| `103-error-handling` | Pattern | Error handling patterns |
| `104-react-patterns` | Pattern | React components & state |
| `105-tailwind` | Pattern | Tailwind CSS conventions |
| `106-frontend-design` | Pattern | UI/UX design patterns |
| `200-testing` | Pattern | Jest/Pytest patterns |
| `300-code-reviewer` | On-Demand | Code review guidance |
| `301-debugger` | On-Demand | Debugging assistance |
| `302-git-helper` | On-Demand | Git workflow help |
| `303-doc-researcher` | On-Demand | Documentation lookup |
| `304-performance` | Pattern | Performance optimization |
| `305-refactoring` | Pattern | Refactoring patterns |
| `306-spec-discovery` | On-Demand | Requirements clarification |

### Commands (`.cursor/commands/`)

Invoke commands with `@command-name` in chat:

- **`@plan [--tdd]`** - Plan a new feature (--tdd for test-driven)
- **`@research`** - Deep research with parallel sub-agents
- **`@review`** - Qualitative code review (patterns, readability, design)
- **`@slop`** - Remove AI-generated slop (over-comments, defensive overkill, any casts)
- **`@validate`** - Quantitative checks (tests, types, lint, build)
- **`@progress`** - Save research findings as knowledge docs
- **`@ship`** - Commit validated changes

### Hooks (`.cursor/hooks/`)

**Security (before events)**
- **beforeShellExecution** - Blocks dangerous commands (rm -rf, sudo, force push)
- **beforeTabFileRead** - Protects sensitive files (.env, keys, .kube/, .docker/)

**Automation (after events)**
- **afterFileEdit** - Auto-formats with Prettier/Black

**Debug mode:** Set `CURSOR_HOOK_DEBUG=1` to see hook output.

## Workflow

```
@plan "feature" → implement → @review → @validate → @ship
```

1. **Plan** - Use `@plan` for feature planning
2. **Implement** - Write code with rule guidance
3. **Review** - Run `@review` for qualitative feedback
4. **Validate** - Run `@validate` for automated checks
5. **Ship** - Run `@ship` to commit

## Documentation

- [Getting Started](docs/getting-started.md)
- [Components Guide](docs/components.md)
- [Cursor-Specific Features](docs/cursor-specific.md)
- [Hook Development](docs/hook-development.md)
- [FAQ](docs/faq.md)

## Related

- [cadre-devkit-claude](https://github.com/benshapyro/cadre-devkit-claude) - Same patterns for Claude Code

## License

MIT
