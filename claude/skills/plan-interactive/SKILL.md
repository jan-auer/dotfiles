---
name: plan-interactive
description: Collaboratively plan an increment of work — gather context, explore options with the user, and produce a plan file in .claude/plans/.
---

# /plan-interactive — Collaborative Planning

You are planning one increment of development through structured conversation with the user. The plan file in `.claude/plans/` is the deliverable — no implementation happens within this skill. Default to collaboration — surface decisions, present options, iterate.

---

## Phase 1: Gather Context

Understand the project and what needs doing.

1. Read project instructions: CLAUDE.md/AGENTS.md, README, and any docs/ directory.
2. Check `git log` for recent activity and direction.
3. Check `.claude/plans/` for existing plans — understand what has been planned vs. done.

**If the user specified a direction** (`$ARGUMENTS`): use that as the starting point. Research it — read relevant code, docs, and tests before discussing.

**Otherwise**: look for open TODOs, progress documents, or documented next steps anywhere in the project (issues, README, CLAUDE.md, docs/, code comments). Present the top candidates you find and ask the user to pick one. If nothing is found, ask the user what to work on. Do not invent work.

---

## Phase 2: Explore and Decide

Enter plan mode (`EnterPlanMode`) to explore the codebase. This phase is a conversation — your job is to surface decisions, not make them silently.

For each significant design choice:

1. **Research first.** Read relevant code, check existing patterns, search for prior art in the codebase and ecosystem. Do not present options you have not investigated.
2. **Present options with tradeoffs.** Concrete pros/cons grounded in what you found — not abstract hand-waving. Include effort estimates where relevant.
3. **Make a recommendation.** State which option you favor and why. The user can override.
4. **Challenge weak choices.** If the user picks an option with significant downsides, say so clearly. Then respect their decision.

Keep iterations focused. Sequence decisions so earlier choices inform later ones.

---

## Phase 3: Write the Plan

Once decisions are made, write the plan to `.claude/plans/`.

**Scope check:** If the plan is too complex to implement in a single increment, split it into smaller self-contained plans. Each should be independently plannable and implementable. Write the first plan now and note the remaining ones as follow-up increments.

Adapt the plan format to the work type. Include at minimum:

- **Context**: why this change is being made — the problem, what prompted it, intended outcome.
- **Approach**: what will be done, at sufficient detail to implement without re-researching.
- **Key decisions**: choices made in Phase 2 and their rationale.
- **Files to create or modify**: with brief notes on what changes.
- **Test plan**: what tests to write and what they verify.
- **Acceptance criteria**: concrete, checkable statements.
- **Out of scope**: what this increment explicitly does not do.

The plan must be self-contained — `/implement` can execute it in a separate session.

---

## Phase 4: Review

Before finalizing, check:

- [ ] Plan is consistent with existing code and conventions.
- [ ] No scope creep — addresses the increment and nothing else.
- [ ] Terminology matches what the project already uses.
- [ ] Acceptance criteria are testable.
- [ ] Plan is implementable in a single increment.

Present the completed plan to the user for final approval. If there is substantial feedback, loop back to Phase 2 — re-research and re-discuss as needed. Minor feedback can be incorporated directly.

---

## Phase 5: Reflect

Briefly reflect on:

- **Scoping**: Was this the right size for one increment?
- **Decision quality**: Were the options well-researched? Did conversation improve the plan?
- **Process**: Was any phase of this workflow unhelpful or missing for this type of work?

State this in your response.

### Propose Improvements

If reflection reveals something worth codifying, propose a specific change:

| What changed | Where to propose |
|---|---|
| Project convention or structure | Project CLAUDE.md / AGENTS.md |
| Cross-project preference or workflow | `~/.claude/CLAUDE.md` (global) |
| Language/tool-specific rule | `~/.claude/rules/<topic>.md` |
| Factual observation to remember | Auto-memory |
| Skill process improvement | This skill file |

State what to change, where, why, and the exact wording. Do **not** apply changes — the user reviews and approves.
