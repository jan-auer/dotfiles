# Sentry Rules (getsentry org)

## Git

- Use `/create-pr` to create PRs following Sentry's conventions, but not include the `## Summary` header and do not add a test plan.
- Branch names: `<type>/<short-description>` (e.g., `feat/add-user-auth`, `fix/null-pointer`). No username prefix. Valid types: `feat`, `fix`, `ref`, `perf`, `docs`, `test`, `build`, `ci`, `chore`, `style`, `meta`, `license`.
- Use the `meta(ai)` type for changes to agent configuration (e.g., `AGENTS.md`, `CLAUDE.md`, Claude settings).

## Before Creating PRs

- If the implementation is complex, ask whether to run `/code-simplifier`.
- Run `/find-bugs` to review for bugs, security, and code quality issues.
