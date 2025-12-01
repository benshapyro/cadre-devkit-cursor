# Getting Started with Cadre DevKit for Cursor

## Prerequisites

- Cursor IDE v1.7 or later
- Basic familiarity with Cursor's AI features

## Installation

### Option 1: Copy to Project

Copy the `.cursor` directory to your project root:

```bash
git clone https://github.com/benshapyro/cadre-devkit-cursor.git
cp -r cadre-devkit-cursor/.cursor /path/to/your/project/
```

### Option 2: Global Installation

For use across all projects, symlink to your home directory:

```bash
git clone https://github.com/benshapyro/cadre-devkit-cursor.git ~/cadre-devkit-cursor
ln -s ~/cadre-devkit-cursor/.cursor ~/.cursor
```

### Option 3: Git Submodule

Add as a submodule to track updates:

```bash
git submodule add https://github.com/benshapyro/cadre-devkit-cursor.git .devkit
ln -s .devkit/.cursor .cursor
```

## Verify Installation

1. Open Cursor in your project
2. Open the AI chat (Cmd+L or Ctrl+L)
3. Type `@plan test feature`
4. You should see the planning workflow activate

## First Steps

### 1. Try the Plan Command

```
@plan Add a user profile page
```

This will:
- Gather context about your codebase
- Ask clarifying questions
- Create a structured implementation plan

### 2. Use Plan Mode

Press **Shift+Tab** to enter Cursor's native Plan Mode for complex features.

### 3. Review Your Code

After making changes:
```
@review
```

### 4. Validate Before Committing

```
@validate
```

### 5. Ship Your Changes

```
@ship Add user profile page
```

## Understanding Rules

Rules activate based on:

1. **Always-on rules** (001-003): Apply to every conversation
2. **Pattern-based rules** (100-200): Activate when matching files are open
3. **Description-based rules** (300-303): Activate when the description matches context

Check which rules are active in Cursor's status bar.

## Next Steps

- Read the [Components Guide](components.md) for detailed documentation
- Review [Cursor-Specific Features](cursor-specific.md) for platform tips
- Check the [FAQ](faq.md) for common questions
