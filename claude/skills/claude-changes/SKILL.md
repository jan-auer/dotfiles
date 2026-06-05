---
name: claude-changes
description: Summarize what's new in Claude Code (the CLI) across a version or date range, grouped by topic and filtered to user-facing UX changes. Use whenever the user asks "what's new", "what changed since X", "summarize Claude Code changes since [date]", "what did I miss in the last release", or any similar question about Claude Code release history — even if they don't explicitly say "changelog". Fetches the official CHANGELOG.md and returns a topic-grouped summary that drops MCP plumbing, telemetry, and pure bugfixes.
---

# Claude Code changes summary

Produce a curated, topic-grouped summary of Claude Code (the CLI) changes across a version range or date range. The user wants signal about *things they'd notice while using Claude Code*, not a verbatim changelog dump.

## Step 1 — figure out the range

Parse `$ARGUMENTS` to extract a start cutoff and (optionally) an end. Handle these shapes:

- **Version cutoff**: `2.1.98`, `v2.1.98`, `since 2.1.98` → start cutoff is the entry *after* that version (exclusive). End is latest unless given.
- **Explicit range**: `2.1.100..2.1.118`, `between 2.1.100 and 2.1.118` → both bounds inclusive.
- **Date phrase**: `since february`, `last month`, `since 2026-01-15` → resolve to a version cutoff using step 3.
- **Empty `$ARGUMENTS`**: ask via `AskUserQuestion` with options "last 30 days", "since my installed version (`claude --version`)", "custom".

Print the resolved range in the intro line so the user can sanity-check before reading the whole summary. The user phrases this many ways and silently guessing wrong wastes a long fetch+summarize cycle.

## Step 2 — fetch the changelog

```bash
curl -fsSL https://raw.githubusercontent.com/anthropics/claude-code/main/CHANGELOG.md -o /tmp/claude-changelog.md
```

The file is large (~240KB). Don't `Read` it whole. Instead:

1. `Grep` it with `pattern: "^## "`, `output_mode: "content"`, `-n: true` to get a numbered index of version headers.
2. Identify the line range covering the requested versions.
3. `Read` only that slice with `offset`/`limit`.

## Step 3 — resolve dates → versions (only when the user gave a date)

```bash
gh release list -R anthropics/claude-code --json tagName,publishedAt --limit 300
```

Find the earliest tag whose `publishedAt` is on/after the user's date. Use that as the start cutoff. (`gh api` is forbidden; `gh release list --json` is the supported alternative.)

Show the resolution explicitly, e.g.:

> Resolving "since february" → versions 2.1.83 onward (released 2026-02-04).

## Step 4 — categorize entries

Group surviving bullets into these buckets, in this order. Omit any group that ends up empty:

1. **Themes** — color/theme system, appearance.
2. **Effort** — `/effort`, default effort changes, per-skill effort.
3. **New & Improved Commands** — new slash commands, renames, command-level UX upgrades, transcript search.
4. **Keybindings & Input** — keyboard shortcuts, vim modes, paste/IME behavior, prompt-input editing.
5. **Agent Teams & Multi-Agent** — `/agents`, named subagents, auto mode, team-onboarding, agent frontmatter.
6. **Session & Context Management** — `/resume`, `/recap`, `/branch`/`/fork`, plan files, session naming, recap.
7. **General UX** — spinners, indicators, terminal rendering, status line, push notifications, autocomplete, image chips — anything visible that doesn't fit above.

If you find a substantial cluster of changes that don't fit any group (e.g. a new "Sandbox" theme), you may add a new group at the end rather than forcing a poor fit.

## Step 5 — drop the noise

The user wants signal. Skip an entry if it's any of:

- A pure bugfix that doesn't add capability ("fixed X failing in Y", "fixed crash when …").
- MCP transport, OAuth refresh, server connection plumbing, dynamic-client-registration details.
- Provider-specific fixes (Bedrock / Vertex / Foundry) unless they surface a new user-visible feature.
- Telemetry / OpenTelemetry / env-var-only changes (keep ones directly user-facing like `CLAUDE_CODE_NO_FLICKER`).
- SDK / `--print` / headless / `--bare` mode internals.
- Plugin internals (dependency resolution, marketplace cache, install hints).
- Performance fixes for internal-only code paths.
- Windows-only minor fixes — but keep major Windows-visible rollouts like the PowerShell tool.

Keep — even when small:

- New keybindings or shortcut renames.
- New commands or command aliases.
- Visible UI / render changes.
- Default-behavior changes (effort bumps, default model changes).

When in doubt, ask: *would the user's day-to-day experience differ?* If yes, keep it.

## Step 6 — write each entry as a one-liner

Lead with what the user gets, then briefly *how* it works. Don't echo changelog wording verbatim — distill it.

**Format:**

```markdown
**Feature name** (vX.Y.Z) — One-line description of what it does and (briefly) how it works.
```

Rules:

- Bold the feature; em-dash before the one-liner.
- Combine versions when one feature evolved across releases: `(v2.1.94, v2.1.117)`.
- No emojis unless the user asked for them.
- One blank line between bullets for readability.

**Examples:**

> **Auto theme** (v2.1.111) — `/theme` → "Auto (match terminal)" syncs dark/light with your terminal's reported color scheme.
>
> **Vim visual modes** (v2.1.118) — `v` enters visual mode, `V` visual-line mode, with full operator support and visual feedback.
>
> **`/usage`** (v2.1.118) — Merges `/cost` and `/stats` into one command with tabs. Both old names still work as shortcuts.

## Step 7 — assemble the response

```markdown
Here's what's changed [in <range>], grouped by topic:

## Group name

**Feature** (vX.Y.Z) — …

**Feature** (vX.Y.Z) — …

## Next group

…
```

End with the last group. No trailing summary — the section headers are the summary. Don't add a "see the full changelog" footer unless something interesting was deliberately omitted.

## Edge cases

- **Range covers only patch fixes**: say so plainly ("Versions 2.1.X–2.1.Y were almost entirely bugfixes; the only user-visible change is …") rather than padding.
- **Range is huge** (>30 versions): warn the user and offer to narrow. Otherwise proceed but expect the summary to be longer.
- **Latest version is older than the cutoff**: tell the user their version is already at or past the requested cutoff.
- **`gh` is unavailable** when resolving a date: fall back to asking the user for an approximate version, or guess from release cadence (~3–4 versions/week) and clearly mark it as an estimate.
