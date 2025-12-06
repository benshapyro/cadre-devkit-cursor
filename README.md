# Cadre DevKit for Cursor

**Turn Cursor from a helpful intern into a reliable senior engineer.**

---

## What is Cursor?

[Cursor](https://cursor.com) is an AI-powered code editor built on VS Code. It has Claude/GPT built in, can read your codebase, and helps you write code through chat and inline completions.

It's powerful. It's also... unpredictable.

## The Problem

AI coding assistants have a reliability problem:

| Issue | What Happens |
|-------|--------------|
| **Hallucination** | "Tests pass!" (they don't) |
| **Over-engineering** | 50 lines of defensive code for a 3-line function |
| **AI slop** | Comments everywhere, `any` casts, unnecessary try/catch |
| **Context loss** | Re-explores the same code every session |
| **Dangerous commands** | `rm -rf /` is just a typo away |
| **No planning** | Jumps straight to code without understanding |
| **Inconsistent quality** | Great on Monday, chaos on Tuesday |

You end up babysitting the AI instead of shipping code.

## The Solution

This devkit adds a **quality and safety layer** to Cursor:

- **Rules** that guide behavior based on what you're working on
- **Hooks** that actually block dangerous commands (not just warnings)
- **Structured workflow** from planning to shipping
- **Evidence-based verification** (no more "it should work")
- **Research-first pattern** (understand before implementing)
- **Anti-slop tooling** (removes AI code smell)

It's not a collection of prompts. It's an integrated system.

---

## Quick Start

### 1. Install

```bash
git clone https://github.com/benshapyro/cadre-devkit-cursor.git
cp -r cadre-devkit-cursor/.cursor /path/to/your/project/
```

Or for global use:
```bash
ln -s /path/to/cadre-devkit-cursor/.cursor ~/.cursor
```

### 2. Restart Cursor

Cursor loads rules from `.cursor/rules/` on startup.

### 3. Use It

In Cursor chat:
```
@plan add user authentication
```

That's it. The devkit is now active.

---

## The Workflow

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                                                                             │
│  NEW PROJECT:                                                               │
│  @greenfield ──→ SPEC.md + DESIGN.md + PLAN.md                              │
│       │                                                                     │
│       └──→ @plan [first feature] ──→ ...                                    │
│                                                                             │
│  EXISTING PROJECT:                                                          │
│  @research ──→ @plan ──→ implement ──→ @slop ──→ @review ──→ @validate ──→ @ship
│      │          │                        │         │          │        │    │
│   Parallel    Read files              Remove    Qualitative  Tests,   Commit│
│   research    first,                  AI cruft  feedback     types,         │
│   agents      --tdd for                         on design    lint,          │
│               test-first                                     build          │
│                                                                             │
│                                          @progress ◄────────────────────────┘
│                                          Save learnings for next time       │
│                                                                             │
│  ISSUES:                                                                    │
│  @backlog ──→ Document bugs/enhancements without implementing               │
│                                                                             │
│  HELP:                                                                      │
│  @learn ──→ Interactive help about Cursor and the devkit                    │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

Not every step is required. Typical flows:

- **Quick fix:** implement → `@validate` → `@ship`
- **New feature:** `@plan` → implement → `@review` → `@validate` → `@ship`
- **Complex feature:** `@research` → `@plan --tdd` → implement → `@slop` → `@review` → `@validate` → `@progress` → `@ship`
- **New project:** `@greenfield` → `@plan [first feature]` → implement → ship

---

## Commands

Invoke commands in Cursor chat with `@command-name`.

### `@greenfield [idea]`

**Start a new project from scratch.**

Don't jump into code. Discover what you're actually building first.

```
@greenfield I want to build a tool that helps developers track learning progress
```

What happens:
1. Interactive discovery through 6 phases (vision, problem, users, technical, validation, scoping)
2. Uses Socratic questioning to uncover requirements you haven't thought of
3. Creates three documents in `docs/`:
   - `SPEC.md` - What to build (requirements, users, success criteria)
   - `DESIGN.md` - How to build it (architecture, technology choices)
   - `PLAN.md` - Implementation roadmap (phases, tasks)
4. Suggests first feature to implement with `@plan`

Why it matters: Most projects fail from unclear requirements, not bad code. This forces clarity before you write a single line.

---

### `@learn [question]`

**Interactive help about Cursor and the devkit.**

```
@learn
@learn how do rules work?
@learn what's the difference between @plan and @greenfield?
@learn what rules are available?
```

What happens:
- No question: Shows welcome message with topic list
- Devkit question: Reads actual files and explains
- Cursor question: Routes to appropriate documentation

Why it matters: Self-service onboarding. Learn the system without reading all the docs.

---

### `@research [topic]`

**Deep research before you build.**

Don't let Cursor guess. Have it actually investigate first.

```
@research how should we implement caching in this project
```

What happens:
1. Analyzes your question + project context
2. Proposes a research plan (e.g., "I'll check existing patterns, framework docs, and community best practices")
3. You approve or adjust
4. Gathers information from multiple sources
5. Synthesizes findings into actionable summary

Why it matters: Research first, implement second. Clean context leads to better code.

---

### `@plan [--tdd] [feature]`

**Plan before you build. No assumptions.**

```
@plan add rate limiting to the API
@plan --tdd add rate limiting to the API   # Test-driven mode
```

What happens:
1. **Reads the actual files** that will be modified (required, not optional)
2. Asks clarifying questions if needed
3. Creates a detailed plan with:
   - Files to modify (with line numbers for complex changes)
   - Code snippets showing what will change
   - Why this approach (and alternatives considered)
   - Testing strategy
4. Waits for your approval before implementing

With `--tdd`:
- Converts requirements to test cases first
- Plans test file creation before implementation
- Follows red → green → refactor cycle

---

### `@backlog [bug|enh|ux] [description]`

**Document issues without implementing them.**

```
@backlog bug the login form doesn't validate email format
@backlog enh add dark mode support
@backlog ux the submit button is hard to find
```

What happens:
1. Classifies as BUG, ENH (enhancement), or UX improvement
2. Investigates codebase to find root cause / affected files
3. Researches best practices (for enhancements)
4. Takes screenshots (for UX issues, if Playwright available)
5. Creates detailed entry in `BACKLOG.md`
6. Asks for next item (interactive loop)

Why it matters: Capture issues when you notice them. Implement later when you have time.

---

### `@review`

**Qualitative code review.**

```
@review
```

Focuses on:
- Design patterns and architecture
- Code readability and maintainability
- Potential bugs or edge cases
- Consistency with existing codebase

This is the "does this code make sense?" check.

---

### `@slop`

**Remove AI-generated code smell.**

```
@slop
```

Checks the diff against `main` and removes:
- **Over-commenting** (`// Get the user` before `getUser()`)
- **Defensive overkill** (null checks when TypeScript already enforces it)
- **Type escapes** (`as any`, `as unknown as X`)
- **Inconsistent style** (JSDoc in a file that doesn't use it)
- **Unnecessary try/catch** (wrapping code that doesn't throw)
- **Verbose logging** (logging every step)

Outputs a 1-3 sentence summary of what was cleaned.

Why it matters: AI code has tells. This removes them so your code looks like a human wrote it.

---

### `@validate`

**Quantitative checks.**

```
@validate
```

Runs:
- TypeScript type checking (`tsc --noEmit`)
- Linting (`eslint`, `ruff`)
- Tests (`jest`, `pytest`)
- Build verification

This is the "does this code work?" check.

---

### `@progress`

**Save learnings for next time.**

```
@progress
```

After a research or exploration session, saves findings to `docs/YYYY-MM-DD-NNN-description.md`.

Example output:
```markdown
# Authentication System - Quick Reference

**Date:** 2025-12-04
**Context:** Researched how to add OAuth

**Key Files:**
- `src/auth/AuthController.ts:34` - Main entry point
- `src/auth/SessionManager.ts` - Redis-backed sessions

**Gotchas:**
- Always call `validateToken()` before `getUser()`
```

Why it matters: Next time you work on auth, Cursor reads this instead of re-exploring from scratch.

---

### `@ship`

**Commit with proper formatting.**

```
@ship
```

What happens:
1. Runs `git status` and `git diff`
2. Analyzes changes
3. Creates a commit message following conventional format (`type(scope): message`)
4. Commits (doesn't push unless you ask)

---

## What's Running Behind the Scenes

The devkit isn't just commands. There's a lot happening automatically.

### Rules (Context-Aware Guidance)

Rules are `.mdc` files in `.cursor/rules/` that auto-activate based on file patterns or descriptions.

#### Always-On Rules

| Rule | What It Does |
|------|--------------|
| `001-global` | Core coding standards, naming conventions, best practices |
| `002-confidence` | Pre-implementation confidence scoring (0.0-1.0) |
| `003-selfcheck` | Post-implementation evidence requirements |

#### Pattern-Based Rules

| Rule | Activates When | Provides |
|------|----------------|----------|
| `100-api-design` | Working in `/api/`, `/routes/`, `/graphql/` | REST conventions, GraphQL patterns, error formats |
| `101-code-style` | Any code file | TypeScript/Python style guidelines |
| `102-documentation` | Creating docs | README structure, API docs format |
| `103-error-handling` | Implementing error handling | Try/catch patterns, error boundaries |
| `104-react-patterns` | Working with `.tsx`, `/components/` | Component patterns, hooks, state management |
| `105-tailwind` | Working with Tailwind | Class organization, layout patterns |
| `106-frontend-design` | Working on pages/layouts | Hero sections, cards, dashboards |
| `107-product-discovery` | New projects, greenfield | MVP scoping, requirements discovery |
| `108-devkit-knowledge` | Learning about the devkit | Commands, rules, hooks, workflows |
| `200-testing` | Working in `/tests/`, `*.test.*` | Jest/Pytest patterns, async testing |
| `304-performance` | Performance-critical code | Profiling, optimization patterns |
| `305-refactoring` | Restructuring code | Safe refactoring patterns |

#### On-Demand Rules

| Rule | Purpose |
|------|---------|
| `300-code-reviewer` | Deep code review guidance |
| `301-debugger` | Error analysis and debugging |
| `302-git-helper` | Git workflow assistance |
| `303-doc-researcher` | Documentation lookup patterns |
| `306-spec-discovery` | Requirements clarification |

### Hooks (The Safety Net)

Hooks are shell scripts that run before/after Cursor actions. They can **block execution**.

| Hook | When | What It Does |
|------|------|--------------|
| `dangerous-command-blocker.sh` | Before shell commands | Blocks `rm -rf /`, `chmod 777`, force push, `sudo`, etc. |
| `sensitive-file-guard.sh` | Before file reads | Blocks access to `.env`, credentials, SSH keys, `.kube/`, `.docker/` |
| `auto-format.sh` | After file edits | Runs Prettier (JS/TS) or Black (Python) |

These aren't warnings. They actually prevent execution.

**Debug mode:** Set `CURSOR_HOOK_DEBUG=1` to see what hooks are doing.

### Quality Gates

Two automated checks enforce quality:

**ConfidenceChecker** (before implementation):
- Scores confidence 0.0-1.0 across: requirements clarity, technical feasibility, dependencies, test strategy, risk
- Green (≥0.90): proceed
- Yellow (0.70-0.89): investigate gaps
- Red (<0.70): stop and clarify

**SelfCheck** (after implementation):
- Requires evidence for claims
- "Tests pass" must show actual test output
- Blocks phrases like "should work" or "probably fine"

---

## Installation (Detailed)

### Prerequisites

- Cursor installed ([cursor.com](https://cursor.com))
- Git (for hooks)

### Option 1: Per-Project

Copy the `.cursor` folder to your project:

```bash
git clone https://github.com/benshapyro/cadre-devkit-cursor.git
cp -r cadre-devkit-cursor/.cursor /path/to/your/project/
```

Rules will apply only to that project.

### Option 2: Global (All Projects)

Symlink to your home directory:

```bash
git clone https://github.com/benshapyro/cadre-devkit-cursor.git
ln -s $(pwd)/cadre-devkit-cursor/.cursor ~/.cursor
```

Rules will apply to all projects.

### Configure Hooks

Cursor hooks are configured in `.cursor/hooks/hooks.json`:

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

This is already configured in the devkit. Just copy the `.cursor` folder and restart Cursor.

### Verify Installation

1. Open Cursor in a project with the `.cursor` folder
2. In chat, type `@plan test feature` - should work
3. Ask Cursor to run `rm -rf /` - should be blocked

---

## FAQ

### Do I need all of this?

No. The components are modular:
- Just want safety? Keep only the hooks
- Just want workflow? Keep only the commands
- Want everything? Keep it all

### Can I customize the rules?

Yes. Rules are `.mdc` files in `.cursor/rules/`. Edit the frontmatter to change when they activate:

```yaml
---
description: "When this rule applies"
globs: ["**/*.tsx"]  # File patterns
alwaysApply: false   # Or true for always-on
---
```

### Can I customize the blocked commands?

Yes. Edit `.cursor/hooks/security/dangerous-command-blocker.sh` and modify the patterns.

### What if a hook blocks something I actually want to do?

Run the command manually in your terminal, outside of Cursor. The hooks only affect Cursor's actions.

### Does this work with Claude Code?

There's a separate [Claude Code version](https://github.com/benshapyro/cadre-devkit-claude) with the same patterns adapted for Claude Code's system.

### How do I debug hooks?

```bash
export CURSOR_HOOK_DEBUG=1
# Now hooks print debug info to stderr
```

### Can I add my own commands?

Yes. Create a `.md` file in `.cursor/commands/`:

```markdown
---
description: What this command does
---

Instructions for the AI when this command is invoked...
```

### Can I add my own rules?

Yes. Create a `.mdc` file in `.cursor/rules/`:

```markdown
---
description: "When this rule should apply"
globs: ["**/my-pattern/**/*"]
---

# Rule Name

Instructions for the AI when working with matching files...
```

### Where are knowledge docs saved?

`@progress` saves to `docs/YYYY-MM-DD-NNN-description.md` in your project directory.

### How do I get help?

Run `@learn` for interactive help about the devkit and Cursor.

---

## What's Included

| Component | Count | Description |
|-----------|-------|-------------|
| **Commands** | 10 | `@greenfield`, `@learn`, `@plan`, `@research`, `@backlog`, `@review`, `@slop`, `@validate`, `@progress`, `@ship` |
| **Rules** | 19 | Always-on (3), pattern-based (11), on-demand (5) |
| **Hooks** | 3 | Dangerous command blocker, sensitive file guard, auto-format |

---

## Directory Structure

```
.cursor/
├── commands/
│   ├── greenfield.md
│   ├── learn.md
│   ├── plan.md
│   ├── research.md
│   ├── backlog.md
│   ├── review.md
│   ├── slop.md
│   ├── validate.md
│   ├── progress.md
│   └── ship.md
├── rules/
│   ├── 001-global.mdc
│   ├── 002-confidence.mdc
│   ├── 003-selfcheck.mdc
│   ├── 100-api-design.mdc
│   ├── 101-code-style.mdc
│   ├── 107-product-discovery.mdc
│   ├── 108-devkit-knowledge.mdc
│   ├── ... (more rules)
└── hooks/
    ├── hooks.json
    ├── security/
    │   ├── dangerous-command-blocker.sh
    │   └── sensitive-file-guard.sh
    └── formatting/
        └── auto-format.sh
```

---

## Documentation

| Doc | What's In It |
|-----|--------------|
| [Getting Started](docs/getting-started.md) | Extended tutorial with examples |
| [Components](docs/components.md) | Deep dive into every component |
| [Cursor-Specific](docs/cursor-specific.md) | Cursor-specific features and tips |
| [Hook Development](docs/hook-development.md) | Creating custom hooks |
| [FAQ](docs/faq.md) | Common questions |

---

## Contributing

Found a bug? Want to add a feature? PRs welcome.

1. Fork the repo
2. Create a branch (`git checkout -b feat/my-feature`)
3. Make changes
4. Test locally by copying `.cursor/` to a project
5. Submit a PR

---

## License

MIT
