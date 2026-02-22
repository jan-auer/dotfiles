---
name: implement
description: Execute a plan — implement, validate, review for quality and security, then reflect and propose improvements.
---

# /implement — Structured Implementation

You are implementing a plan. Follow all phases in order. Default to autonomy — ask only when genuinely blocked.

---

## Plan Resolution

Locate and load the plan to implement.

**If the user specified a path** (`$ARGUMENTS`): treat it as the plan file path (relative to project root or absolute). Read it.

**Otherwise**: find the most recently modified `.md` file in `.claude/plans/` using `Glob` (results are sorted by modification time — take the first match).

Read the plan, summarize what will be implemented, and confirm with the user before starting. Do not begin until the user approves.

If no plan file is found and no path was provided, tell the user and suggest running `/plan-interactive` first.

---

## Phase 1: Implement

Execute the plan.

- Write tests alongside code, not after.
- If the plan turns out to be wrong mid-implementation, **stop**. Do not patch around a broken plan. Tell the user the plan needs revision and suggest re-planning.
- When you discover something that should be documented (new conventions, changed structure, setup steps), note it for the reflect phase.
- When project state changes meaningfully (new directories, new conventions, new dependencies), update CLAUDE.md or AGENTS.md to reflect reality.

---

## Phase 2: Validate

Discover and run the project's verification toolchain. Do not hardcode commands — detect them.

### Discover checks

Look for verification commands in this order:

1. **CI config**: `.github/workflows/`, `.gitlab-ci.yml`, `.circleci/`, `Jenkinsfile`.
2. **Package manager config**: `package.json` scripts, `Makefile`/`Justfile` targets, `pyproject.toml` scripts, `Cargo.toml`.
3. **Tool config files**: `.eslintrc*`, `ruff.toml`, `rustfmt.toml`, `tsconfig.json`, `.prettierrc*`.
4. **CLAUDE.md / AGENTS.md**: may list check commands explicitly.

### Run checks

Based on what you find, run the applicable subset:

- **Tests**: run tests related to the changed code first, then the full suite.
- **Type checking**: if the project uses a type checker, run it.
- **Linting**: if the project has a linter configured, run it.
- **Formatting**: if the project has a formatter, check formatting (do not auto-fix — verify first).

If no verification toolchain exists (new project, no CI, no config), state this explicitly. Suggest what should be set up based on the tech stack.

### Acceptance criteria

Check every acceptance criterion from the plan. For each one, verify it is met — do not assume.

**If validation fails, cycle back to Phase 1.** Fix issues and re-validate. Do not proceed to Phase 3 with known failures.

---

## Phase 3: Review

Thoroughly review the implementation before considering it done. This is a separate pass from validation — validation checks that the code works, review checks that the code is good.

### Code quality review

Read through all changes with fresh eyes. Check for:

- Logic errors, off-by-one mistakes, unhandled edge cases.
- Code that is correct but unnecessarily complex — simplify where possible.
- Naming that is unclear or inconsistent with the rest of the codebase.
- Duplication of logic that exists elsewhere in the codebase.
- Missing or inadequate error handling at system boundaries.

### Security review

Check for common vulnerability classes relevant to the changes:

- Injection risks (command injection, SQL injection, XSS, template injection).
- Improper input validation or sanitization at trust boundaries.
- Authentication or authorization gaps.
- Sensitive data exposure (logging secrets, leaking in error messages).
- Insecure defaults or missing security headers.

Focus on what the changes actually touch — do not audit the entire codebase.

### Address findings

If review surfaces issues, cycle back to Phase 1 to fix them, then re-validate (Phase 2). Repeat until the review is clean.

---

## Phase 4: Reflect and Improve

Three parts, all required.

### 4a: Plan Cleanup

Ask the user whether the plan is completed and the plan file in `.claude/plans/` can be deleted. If confirmed, delete it.

### 4b: Process Reflection

Reflect honestly:

- **Plan accuracy**: Did the plan survive contact with reality? What changed and why?
- **Validation coverage**: Were the checks sufficient? Did they catch real issues?
- **Review findings**: Did the review catch things validation missed? What categories?
- **Increment sizing**: Right size? Too large, too small?
- **Question discipline**: Did you ask when you should have decided? Decide when you should have asked?

State this in your response.

### 4c: Propose Improvements

If reflection reveals something worth codifying, propose a specific change:

| What changed | Where to propose |
|---|---|
| Project convention or structure | Project CLAUDE.md / AGENTS.md |
| Cross-project preference or workflow | `~/.claude/CLAUDE.md` (global) |
| Language/tool-specific rule | `~/.claude/rules/<topic>.md` |
| Factual observation to remember | Auto-memory |
| Skill process improvement | This skill file |

State what to change, where, why, and the exact wording. Do **not** apply changes — the user reviews and approves. If nothing needs changing, say so.
