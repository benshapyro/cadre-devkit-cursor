# Validate Command

Run all validations before shipping code.

## Usage

Invoke with `@validate`

## Validation Steps

### 1. Type Checking

**TypeScript projects:**
```bash
npx tsc --noEmit
```

**Python projects:**
```bash
mypy .
# or
pyright
```

### 2. Linting

**JavaScript/TypeScript:**
```bash
npm run lint
```

**Python:**
```bash
ruff check .
```

### 3. Tests

**JavaScript/TypeScript:**
```bash
npm test
```

**Python:**
```bash
pytest -q
```

### 4. Build Check

**Verify build succeeds:**
```bash
npm run build
```

### 5. SelfCheck Protocol

Answer these questions with evidence:

**Q1: Are tests passing?**
- Show actual test output
- Report pass/fail counts

**Q2: Are all requirements met?**
- Map requirements to implementation
- Confirm nothing missed

**Q3: No unverified assumptions?**
- External APIs verified
- Libraries documented

**Q4: Is there evidence?**
- Include validation output
- Show build success

## Report Format

```markdown
## Validation Report

### Type Checking
[PASSED / FAILED]
[Details if failed]

### Linting
[PASSED / FAILED]
[Details if failed]

### Tests
[X passed, Y failed / Failed to run]
[Failure details if any]

### Build
[PASSED / FAILED]
[Details if failed]

### Summary
[READY TO SHIP / NEEDS FIXES]
```

## Next Steps

- If all pass: `@ship` to commit
- If issues found: Fix and re-run `@validate`
