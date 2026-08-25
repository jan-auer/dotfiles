---
name: create-pr
description: Open a pull request end to end — draft the title and body, name and create the branch, commit, and run `gh pr create`. Use when asked to "create a PR", "open a pull request", "put this up for review", "raise a PR for these changes", or to stack a new PR on top of an existing one.
argument-hint: '[base PR/branch to stack on, or notes for the PR]'
disable-model-invocation: false
---

# Create PR

Take the current work from local changes to an open pull request. Every mutating
step happens **after** a single confirmation gate — do not branch, commit, push,
or create the PR before the user confirms.

## Step 1 — Read the request

Parse `$ARGUMENTS` and the surrounding conversation for:

| Signal | Effect |
|--------|--------|
| A base PR number, PR URL, or branch name | Stacked mode; that is the base |
| "stack this", "on top of the current PR", "base it on the current PR" | Stacked mode; base is the PR of the current branch |
| "draft" | Pass `--draft` to `gh pr create` |
| Anything else | Notes for the PR writer (Step 3) and the branch name (Step 4) |

Empty arguments are normal: default to **non-draft** and **normal mode**. Never
enter stacked mode on inference — it requires one of the explicit signals above.

The branch decision is not an argument. It follows from repository state
(Step 4) and is settled in the confirmation loop (Step 6).

## Step 2 — Inspect state

```bash
git branch --show-current
git status --porcelain
git log --oneline -10
gh repo view --json defaultBranchRef
gh pr view --json number,title,url,baseRefName,headRefName
```

Stop and report if the working tree has nothing to ship — no uncommitted changes
and no commits ahead of the base.

If a PR already exists for the current branch, say so and ask whether the intent
is a new PR (continue, Step 4 case 3) or a refresh of the existing one.

## Step 3 — Draft the title and body

PR titles use the same conventional form as commits: `<type>(<scope>): <Subject>`
or `<type>: <Subject>`. Match the current dominant change, not the latest commit
or a stale title.

Write the PR body for a reviewer who knows the product but not this change. Use
ASD-STE100 English: short sentences, common words, active voice, and one idea
per sentence. Avoid dense academic prose and unnecessary jargon.

Explain what this PR changes and why it matters. Add only context the diff
cannot show. Keep the body short by default; add structure only when it helps.
Omit empty or `N/A` sections, file-by-file narration, copied commit logs, and
redundant diff summaries. Do not put `Checks`, `Verification`, `Test plan`, or
similar validation sections in the PR body; put local check results only in the 
final user report.

## Step 4 — Determine the branch

Every run resolves to exactly one branch **action**: `reuse`, `rename`, or
`create`. Pick it from the current state:

| # | State | Default action |
|---|-------|----------------|
| 1 | Feature branch, no PR | `reuse` — keep the current branch and its name |
| 2 | Default branch (`main`/`master`) or detached HEAD | `create` |
| 3 | Feature branch with an open PR | `create` |
| 4 | Stacked mode (any state) | `create` |

In case 1, propose a `rename` only when the existing name is **grossly wrong**
for the change — it names a different type, or a different subject entirely. A
name that is merely vaguer or shorter than the PR title is fine; prefer `reuse`.

In case 3, the new branch inherits the open PR's commits. Point this out and ask
whether to stack on that PR (Step 5) or branch from the default branch instead —
otherwise the new PR's diff will contain the other PR's changes.

Derive a name for `rename` and `create`:

- Format: `<type>/<short-description>`.
- `<type>` is the **same type** the PR title uses (`feat`, `fix`, `ref`, `perf`,
  `docs`, `test`, `build`, `ci`, `chore`, `style`, `meta`, `license`).
- `<short-description>` is a heavily abbreviated kebab-case form of the subject —
  2–4 words, ASCII only, no scope prefix, no ticket numbers.
- Append `-2`, `-3`, … if the name already exists locally or on the remote.

| PR title | Branch |
|----------|--------|
| `feat(auth): Add SAML single sign-on for enterprise orgs` | `feat/saml-sso` |
| `fix(api): Return 404 for deleted user accounts` | `fix/deleted-user-404` |
| `ref: Split the replay ingest pipeline into stages` | `ref/split-ingest-stages` |

If the user supplies a different branch name during Step 6 without asking for a
new branch, and the state is case 1, the action becomes `rename` — not `create`.
Any explicit request for a new branch makes it `create`.

## Step 5 — Resolve the base

Normal mode: the base is the repo default branch from Step 2's
`defaultBranchRef`. Nothing else to do.

Stacked mode: the base is the **branch** of the base PR. Resolve it with
`gh pr view <number> --json headRefName,url,state`, then flag and stop for
confirmation if any of these hold:

- The current branch is not the base PR's branch (you are stacking off something
  other than where you are standing).
- The base PR is closed or already merged.
- The current branch already has commits that do not belong on the new layer.

Read the `gh-stack` skill before running any `gh stack` command.

## Step 6 — Confirm

Present exactly this block, then gate on `AskUserQuestion` (offer "Create the PR"
and "I have feedback"):

```markdown
**Branch:** <name> (<keeping current branch | renaming current branch <old> | new branch off <base>>)
**Base:** <base branch>  [stacked on #<pr> — <pr title>]
**Draft:** no

**Title:** <type>(<scope>): <subject>

---
<PR body>
```

Spell the branch action out in words — never just the name — so it is
unambiguous whether the current branch is kept, renamed, or left behind:

| Action | Branch line |
|--------|-------------|
| `reuse` | `**Branch:** feat/saml-sso (keeping current branch)` |
| `rename` | `**Branch:** feat/deleted-user-404 (renaming current branch feat/wip)` |
| `create` | `**Branch:** feat/saml-sso (new branch off main)` |

If the user gives feedback, incorporate it and present the whole block again.
Repeat until confirmed. Do not proceed on silence or on partial approval.

## Step 7 — Apply the branch action

`reuse` — nothing to do.

`rename`:

```bash
git branch -m <new-name>
```

If the old branch was already pushed, the stale remote branch stays behind. Say
so and ask before running `git push origin --delete <old-name>`.

`create`, normal mode or stacked mode where the base branch is not in a local
stack:

```bash
git switch -c <branch>
```

Pass an explicit start point when the new branch must not inherit the current
branch's commits — the case-3 "branch from the default branch" path:

```bash
git switch -c <branch> origin/<default-branch>
```

`create`, stacked mode where `gh stack view --json` exits 0 and lists the base
branch: add the layer to the local stack instead. `gh stack add` only works from
the topmost branch, so verify position first and stop if the base is mid-stack.

```bash
gh stack view --json
gh stack add <branch>
```

Uncommitted changes carry over in every path.

## Step 8 — Commit

Only if changes are uncommitted. Stage the files that belong in this PR — prefer
explicit paths over `git add -A` — and commit with the **PR title as the subject
and no body**:

```bash
git commit -m "<PR title>"
```

## Step 9 — Push and open the PR

```bash
BODY_FILE=$(mktemp /tmp/pr-body-XXXXXX.md)   # write the confirmed body here
git push -u origin <branch>
gh pr create --base <base-branch> --title '<title>' --body-file "$BODY_FILE"
```

Add `--draft` only when the user asked for it. `--base` is required in stacked
mode and may be omitted in normal mode.

## Step 10 — Link the stack (stacked mode only)

`gh pr create --base` gives the PR the right base but does not group the PRs into
a GitHub Stack. Link them afterwards — `link` is additive, finds the existing PRs,
and corrects bases:

```bash
gh stack link <base-branch> <branch>
```

| Exit | Meaning | Action |
|------|---------|--------|
| 0 | Stack created or updated | Report the stack |
| 9 | Stacked PRs not enabled on the repo | The PR base is still correct — report that stacking is unavailable and stop |
| 6 | Branch belongs to multiple stacks | Report; do not attempt to resolve automatically |

Do not use `gh stack submit` — it auto-generates titles and bodies and would
overwrite the confirmed ones.

## Step 11 — Report

Return the PR URL, the base, and — in stacked mode — the resulting stack order.

## Boundaries

- No mutation before the Step 6 confirmation.
- Never force-push, never rebase, never amend an existing commit.
- Never `git add -A` when the working tree holds unrelated changes.
- Never enter stacked mode without an explicit request.
