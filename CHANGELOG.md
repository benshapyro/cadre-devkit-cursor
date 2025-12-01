# Changelog

All notable changes to this project will be documented in this file.

## [1.1.0] - 2025-11-30

### Added
- **Auto-Format Hook** (`afterFileEdit`)
  - Runs Prettier for JS/TS/CSS/JSON/MD files
  - Runs Black for Python files

- **Red Flags Detection**
  - Added 7 hallucination indicators to 003-selfcheck.mdc
  - 94% detection rate for quality issues

### Fixed
- **Sensitive File Guard**
  - Allow `.example`, `.sample`, `.template`, `.dist` files
  - Fix `.env` regex to not match `.env.example`
  - Remove `.pub` from SSH key blocking (public keys aren't sensitive)
  - Add `id_ecdsa` to private key patterns

## [1.0.0] - 2025-11-30

### Added

- Initial release of Cadre DevKit for Cursor
- Core rules (001-global, 002-confidence, 003-selfcheck)
- Skill-based rules:
  - 100-api-design
  - 101-code-style
  - 102-documentation
  - 103-error-handling
  - 200-testing
- Agent-based rules:
  - 300-code-reviewer
  - 301-debugger
  - 302-git-helper
  - 303-doc-researcher
- Commands:
  - @plan - Feature planning
  - @review - Code review
  - @validate - Pre-commit validation
  - @ship - Commit workflow
- Security hooks:
  - dangerous-command-blocker
  - sensitive-file-guard
- Documentation:
  - README with quick start
  - Getting started guide
  - Components reference
  - Cursor-specific features
  - FAQ

### Notes

- Converted from cadre-devkit-claude
- Adapted for Cursor's MDC rule format
- Uses Cursor-native Plan Mode integration
- Compatible with MCP servers
