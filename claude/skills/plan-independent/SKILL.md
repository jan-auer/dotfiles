---
name: plan-independent
description: Autonomously research, self-challenge, and produce a thorough plan in .claude/plans/. Only asks when truly blocked.
---

# /plan-independent — Autonomous Deep Planning

You are planning one increment of development through deep, independent research. The plan file in `.claude/plans/` is the deliverable — no implementation happens within this skill. Default to extended autonomy — ask only when genuinely blocked. It is OK to loop for extended periods.

---

## Phase 1: Understand Context

Gather all available project context before deciding anything.

1. Read project instructions: CLAUDE.md/AGENTS.md, README, and any docs/ directory.
2. Check `git log --oneline -30` for trajectory and recent decisions.
3. Check `.claude/plans/` for existing plans.
4. Read CI config, build config, and toolchain files to understand the project's standards.

**If the user specified a direction** (`$ARGUMENTS`): use that as the increment. Proceed without confirmation.

**Otherwise**: look for open TODOs, progress documents, or documented next steps anywhere in the project (issues, README, CLAUDE.md, docs/, code comments). Identify the highest-value next increment from what you find. Present your choice and confirm with the user before proceeding — do not invent work or start planning without agreement on direction.

---

## Phase 2: Research

Enter plan mode (`EnterPlanMode`). Explore thoroughly before committing to an approach.

- Read all code paths relevant to the increment. Trace call chains and data flow.
- Identify existing patterns, utilities, and conventions that constrain the design.
- Check for similar features or prior art in the codebase.
- Read tests to understand expected behavior and coverage gaps.
- If the increment involves external APIs, libraries, or tools — verify current behavior via web search, docs, or version checks.
- Research the web thoroughly for prior art, recommended practices, and best solutions.
- Check `git blame` and commit messages for files you plan to modify — understand why things are the way they are.

Spend time here. The quality of the plan depends on the depth of research. Do not skip to designing because the direction seems obvious. Research the web and do not rely on training data.

---

## Phase 3: Design with Self-Challenge

Develop the approach, then stress-test it. This is an iterative loop — repeat until the design is stable.

**First pass — design:**
Draft the approach. Include alternatives you considered and why you rejected them.

**Second pass — devil's advocate:**
Challenge your own design. For each major decision, argue the opposite position:

- What assumptions am I making that could be wrong?
- What is the simplest approach that would work? Am I overengineering?
- What will break first? What is the hardest part to get right?
- Does this approach create problems for future work?
- Am I following existing patterns, or introducing unnecessary novelty?

Also audit the requirements driving this increment:

- Are any requirements ambiguous — interpretable in multiple ways?
- Do any requirements contradict each other or contradict existing code/conventions?
- Do any requirements not make sense given the project's context?

If you find requirement issues: resolve them yourself if the project context provides a clear answer. If not, note them as blockers.

**Third pass — revise:**
Incorporate the strongest objections. If the challenge revealed a better approach, switch to it. If the original holds, state why the objections do not outweigh it.

**Blocker check:**
If this pass surfaced issues you cannot resolve — genuine requirement contradictions, missing prerequisites, fundamentally different tradeoffs with no project context to break the tie — batch them and ask the user in a single interaction. Otherwise, continue.

Loop through these passes until additional iterations stop changing the design.

---

## Phase 4: Write the Plan

Write the plan to `.claude/plans/`.

**Scope check:** If the plan is too complex to implement in a single increment, split it into smaller self-contained plans. Each should be independently plannable and implementable. Write the first plan now and note the remaining ones as follow-up increments.

Include:

- **Context**: why this change is being made — the problem, what prompted it, intended outcome.
- **Approach**: the design, at sufficient detail to implement without re-researching.
- **Key decisions**: choices made and their rationale.
- **Alternatives rejected**: what else was considered and why it lost.
- **Requirement issues found**: any ambiguities, contradictions, or nonsensical requirements discovered and how they were resolved (or flagged).
- **Files to create or modify**: with brief notes on what changes.
- **Risk areas**: what is most likely to go wrong or need revision.
- **Test plan**: what tests to write and what they verify.
- **Acceptance criteria**: concrete, checkable statements.

The plan must be self-contained for `/implement`.

---

## Phase 5: Reflect

Reflect on:

- **Research depth**: Did you explore enough before designing? Where were you surprised?
- **Self-challenge quality**: Did the devil's advocate pass change anything? Was the challenge rigorous?
- **Requirement quality**: Did you find issues? Were they resolvable from context?
- **Scoping**: Right size for one increment?
- **Process**: Any phase unhelpful or missing?

State this in your response.

### Propose Improvements

If reflection reveals something worth codifying, propose a specific change:

| What changed                         | Where to propose               |
| ------------------------------------ | ------------------------------ |
| Project convention or structure      | Project CLAUDE.md / AGENTS.md  |
| Cross-project preference or workflow | `~/.claude/CLAUDE.md` (global) |
| Language/tool-specific rule          | `~/.claude/rules/<topic>.md`   |
| Factual observation to remember      | Auto-memory                    |
| Skill process improvement            | This skill file                |

State what to change, where, why, and the exact wording. Do **not** apply changes — the user reviews and approves.
