#!/usr/bin/env bash
input=$(cat)

# ANSI colors
RESET="\033[0m"
BOLD="\033[1m"
CYAN="\033[36m"
YELLOW="\033[33m"
GREEN="\033[32m"
MAGENTA="\033[35m"
RED="\033[31m"
BLUE="\033[34m"
DIM="\033[2m"

cwd=$(echo "$input" | jq -r '.workspace.project_dir // .cwd // ""')
model=$(echo "$input" | jq -r '.model.display_name // ""')
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
cost=$(echo "$input" | jq -r '.cost.total_cost_usd // empty')

# Detect worktree: strip .claude/worktrees/<name>/... from path
worktree_name=""
worktree_pattern="/.claude/worktrees/"
if [[ "$cwd" == *"$worktree_pattern"* ]]; then
  worktree_name="${cwd#*$worktree_pattern}"
  # Show path up to (but not including) .claude/worktrees
  cwd="${cwd%%$worktree_pattern*}"
fi

# Full path with ~ abbreviation, split into parent and dirname
dir_name=$(basename "$cwd")
[ -z "$dir_name" ] && dir_name="/"
tilde="~"
full_path="${cwd/#$HOME/$tilde}"
# parent_path is everything up to and including the last slash
parent_path="${full_path%/$dir_name}/"
# Suppress parent if we're directly in ~ or /
[ "$full_path" = "~" ] && parent_path=""
[ "$full_path" = "/" ] && parent_path=""
[ "$parent_path" = "//" ] && parent_path=""

# Git branch and dirty state (skip lock checks, non-blocking)
git_branch=""
git_dirty=0
if git -C "$cwd" rev-parse --git-dir >/dev/null 2>&1; then
  branch=$(git -C "$cwd" symbolic-ref --short HEAD 2>/dev/null || git -C "$cwd" rev-parse --short HEAD 2>/dev/null)
  if [ -n "$branch" ]; then
    git_branch="$branch"
    # Check for dirty working tree (untracked files and submodules excluded)
    if [ -n "$(git -C "$cwd" status --porcelain --untracked-files=no --ignore-submodules 2>/dev/null)" ]; then
      git_dirty=1
    fi
  fi
fi

# Context usage color: blue under 80%, red at 80%+
ctx_color="$BLUE"
if [ -n "$used_pct" ]; then
  used_int=$(printf "%.0f" "$used_pct")
  if [ "$used_int" -ge 80 ]; then
    ctx_color="$RED"
  fi
fi

# Assemble status line
parts=()

# Folder
if [ -n "$parent_path" ]; then
  parts+=("$(printf "${BOLD}❯${RESET} ${DIM}%s${RESET}%s" "$parent_path" "$dir_name")")
else
  parts+=("$(printf "❯ %s" "$dir_name")")
fi

# Worktree name in cyan
if [ -n "$worktree_name" ]; then
  parts+=("$(printf "${CYAN}⑂ %s${RESET}" "$worktree_name")")
fi

# Git branch: green when clean, yellow when dirty
if [ -n "$git_branch" ]; then
  if [ "$git_dirty" -eq 1 ]; then
    parts+=("$(printf "${YELLOW}⎇  %s${RESET}" "$git_branch")")
  else
    parts+=("$(printf "${GREEN}⎇  %s${RESET}" "$git_branch")")
  fi
fi

# Join first line with separator
line1=""
sep="$(printf "${DIM} · ${RESET}")"
for part in "${parts[@]}"; do
  if [ -z "$line1" ]; then
    line1="$part"
  else
    line1="$line1$sep$part"
  fi
done

# Second line: model, context, cost (original order)
line2_parts=()

# Model
if [ -n "$model" ]; then
  line2_parts+=("$(printf "${MAGENTA}⚙ %s${RESET}" "$model")")
fi

# Context usage
if [ -n "$used_pct" ]; then
  line2_parts+=("$(printf "${ctx_color}≡ ctx %d%%${RESET}" "$used_int")")
fi

# Cost (no symbol per request)
if [ -n "$cost" ]; then
  cost_fmt=$(awk -v c="$cost" 'BEGIN { if (c < 0.01) printf "< $0.01"; else printf "$%.2f", c }')
  line2_parts+=("$(printf "${DIM}%s${RESET}" "$cost_fmt")")
fi

# Join second line
line2=""
for part in "${line2_parts[@]}"; do
  if [ -z "$line2" ]; then
    line2="$part"
  else
    line2="$line2$sep$part"
  fi
done

# Output
if [ -n "$line2" ]; then
  printf "%b\n%b" "$line1" "$line2"
else
  printf "%b" "$line1"
fi
