#!/usr/bin/env bash

if [ -d ./.git ] || git rev-parse --git-dir >/dev/null 2>&1; then
  # Check if the branch has any commits
  if ! git log --pretty=format:"%cd" --date=short >/dev/null 2>&1; then
    # Get the current branch name
    BRANCH_NAME=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)

    echo "Branch $BRANCH_NAME has no commits"

    exit 0
  fi

  # Get unique commit dates
  DATES=$(git log --pretty=format:"%cd" --date=short | sort | uniq)

  # Define colors
  COLORS=(
    "\033[38;5;0m"
    "\033[38;5;22m"
    "\033[38;5;34m"
    "\033[38;5;46m"
  )

  # Set grid dimensions
  GRID_ROWS=6
  GRID_COLS=52

  # Get current week and day numbers
  TODAY_WK_NUM=$(date +%V)
  TODAY_WK_DAY_NUM=$(date +%w) # 0 (Sunday) to 6 (Saturday)

  # Initialize commits array
  commits=()
  for date in $DATES; do
    week=$(date -j -f "%Y-%m-%d" "$date" +%V)
    day=$(date -j -f "%Y-%m-%d" "$date" +%w) # 0 (Sunday) to 6 (Saturday)
    count=$(git log --pretty=format:"%cd" --date=short | grep "$date" | wc -l | xargs)

    if ((week < TODAY_WK_NUM)); then
      adjusted_week=$(((week - TODAY_WK_NUM + 51) % 51))
    else
      adjusted_week=$((week - TODAY_WK_NUM + 51))
    fi

    commits+=("$day,$adjusted_week,$count")
  done

  days=(
    "S"
    "M"
    "T"
    "W"
    "T"
    "F"
    "S"
  )

  # Print the grid
  for row in $(seq 0 $GRID_ROWS); do
    for col in $(seq 0 $((GRID_COLS - 1))); do
      count=0
      for entry in "${commits[@]}"; do
        IFS=',' read -r entry_day entry_week entry_count <<<"$entry"
        if [[ $entry_day -eq $row && $entry_week -eq $col ]]; then
          count=$entry_count
          break
        fi
      done

      if [ "$count" -gt 2 ]; then
        COLOR=3
      elif [ "$count" -gt 1 ]; then
        COLOR=2
      elif [ "$count" -gt 0 ]; then
        COLOR=1
      else
        COLOR=0
      fi

      echo -ne "${COLORS[$COLOR]}\033[0m"
    done
    echo -e "\033[0m" # Reset color
  done
fi
