# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

A macOS-first personal dotfiles repo managing shell (zsh), editor (vim), tmux, git, Homebrew packages, and Claude Code configuration. Configs are installed via `./install.sh`, which prompts for a profile (`personal` or `work`) and runs three phases: link, copy, init.

There are no tests, no CI, and no build step. Verify changes by running `./install.sh`.

## Git

Commit messages use a summary line only — no body. Keep it concise and descriptive.

## Conventions

- **Link vs copy**: Use `link/` for configs that should always match the repo. Use `copy/` when the file needs per-machine customization (e.g., `gitconfig` with local `[user]` section).
- **Homebrew packages**: Declared inline in `init/10_osx_brew.sh`, not in a separate Brewfile. Conditional on `$INSTALL_PROFILE`.
- **`claude/` is global config**: This directory is symlinked into `~/.claude/` — edits here affect all Claude Code sessions across all projects. Do not duplicate it with a project-level `claude/CLAUDE.md`.
