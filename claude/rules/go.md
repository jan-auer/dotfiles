---
paths:
  - "**/*.go"
---

# Go Rules

- Always check error returns — never silently ignore
- Wrap errors with `fmt.Errorf("context: %w", err)` not `%v` — enables `errors.Is` / `errors.As`
- No error string matching — use sentinel errors and typed errors
- `context.Context` as first parameter, never stored in structs
- Small interfaces (1-3 methods), defined in the consuming package
- Table-driven tests with descriptive subtest names
- No `init()` without documented justification
- Return concrete types, accept interfaces in parameters
