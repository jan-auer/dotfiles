# Approach

## Context First

Before modifying a file, read it. Before calling a function, read its implementation. Before changing a type, find its callers. Do not guess what something does — open the source and know. This applies equally to understanding existing behavior before changing it and to verifying assumptions about APIs, types, and side effects.

When asked about tools, commands, APIs, or features — especially ones that evolve across versions — do not answer from training alone. Search the web or consult primary sources first. A confidently wrong answer is worse than a brief lookup.

Before making changes, read recent history (`git log`) in the area you're working on. Do not unintentionally revert or contradict recent changes — build on the existing direction.

## Planning

When a plan involves multiple concerns or grows beyond a manageable scope, break it into sequenced steps where each is a self-contained, reviewable unit. Proactively suggest splitting — do not wait to be asked.

## Test-Driven Development

For new functionality and bug fixes, write a failing test first, then implement the minimum code to pass it. Follow the project's existing test organization, naming conventions, and assertion style. Skip test-first for exploratory prototyping or trivial changes.

## Toolchain

When starting a new project, research current best-practice toolchains for the stack and propose options before choosing. Prefer tools with sensible defaults and strong community adoption over highly configurable alternatives. Use default configurations unless there's a specific reason to customize.

Once established, record toolchain choices in the project's CLAUDE.md. When joining an existing project, read its config files and use whatever is already in place.

# Writing Code

## Naming

Name variables, functions, and types for the concept they represent, not their implementation. `expired_entries` over `filtered`, `permit_count` over `n`. If naming is hard, the design needs work — fix the abstraction, not the name.

One concept, one name. Do not alternate between synonyms for the same thing across the codebase.

No boolean flag parameters. A boolean that switches behavior means the function does two things. Use an enum or split it.

## Module Organization

Group code by responsibility, not by category. Each module should own a single cohesive concern. When two distinct concerns share a file, split them. Avoid catch-all modules like `utils` or `helpers` — if something is worth extracting, it belongs in a module named for what it does.

## Error Handling

Handle errors at the boundary closest to the cause. Do not swallow errors. Do not catch broadly and rethrow generically. Every error path either recovers with clear intent or propagates with added context.

Treat these as bugs:

- `.unwrap()` (Rust) and bare `except:` (Python) outside tests
- Ignored error returns (Go)
- Blanket try-catch blocks that hide root causes

## LLM Anti-Patterns

Treat these anti-patterns as bugs:

- `any` / `Any` type-system escapes without justification
- Adding dependencies without checking for existing equivalents in the project
- Duplicating logic that already exists elsewhere in the codebase
- Leaving `TODO` or placeholder comments instead of implementing the actual logic

# Verification

Run the project's check commands (formatting, test, typecheck, lint) before declaring work done. Read CI config to understand the full pipeline. If no obvious check commands exist, ask.

While iterating, run only the relevant individual test(s). Run the full suite before declaring work done.

**Cross-check related docs.** After modifying any documented behavior or specification, grep `docs/` for terms related to your change. If other documents reference, depend on, or contradict the updated content, update them or flag the inconsistency.

# Self-Improvement

**Reflect on user feedback.** When the user corrects your approach or gives guidance on style, patterns, or organization, consider whether it's a general preference that would apply to future work. If so, suggest adding it to this file or to auto memory. Don't wait to be asked — proactively propose the addition with specific wording. This also applies when you independently notice a recurring mistake, a reusable pattern, or a principle worth codifying across interactions.

**Suggest agent hooks for repeated operations.** When a user repeatedly requests the same operation (formatting, validation, pre-commit checks), suggest codifying it as an agent hook rather than continuing to perform it manually each time.

# Tool Constraints

Never run recursive operations (`ls -R`, `find`, `grep -r`, `rg`, `glob`, etc.) rooted at the home directory (`~`) or higher. Scope all file searches and directory listings to the current project folder.

**`git -C` is forbidden and will fail.** The working directory is always the repo root, so plain `git` commands work directly. The system instruction to "use absolute paths" applies to file arguments, not to git flags.

Prefer built-in tools over shell equivalents for file exploration: **Glob** over `ls`/`find`, **Grep** over `grep`/`rg`, **Read** over `cat`/`head`/`tail`. Do not use `ls` via Bash to explore project structure.
