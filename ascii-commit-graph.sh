#!/usr/bin/env bash

ISGIT=false
if [ -d ./.git ] || git rev-parse --git-dir >/dev/null 2>&1; then
  ISGIT=true
fi

# Define colors
COLORS=(
  "\033[38;5;0m"
  "\033[38;5;22m"
  "\033[38;5;34m"
  "\033[38;5;46m"
)

# Set grid dimensions
GRID_ROWS=6
GRID_COLS=51

# Get current week and day numbers
TODAY_WK_NUM=$(date +%V)
TODAY_WK_DAY_NUM=$(date +%w) # 0 (Sunday) to 6 (Saturday)

if [[ $@ == *"--this-year"* ]]; then
  GRID_COLS=$((TODAY_WK_NUM - 1))
fi

if [[ $@ == *"--full-width"* ]] || (($(tput cols) < (($GRID_COLS + 1)))); then
  GRID_COLS=$(tput cols)
  DIFF=$(((TODAY_WK_NUM - $GRID_COLS) * -1))
  GRID_COLS=$((GRID_COLS - 1))
  TODAY_WK_NUM=$((TODAY_WK_NUM + $DIFF))
fi

days=(
  "S"
  "M"
  "T"
  "W"
  "T"
  "F"
  "S"
)

# Initialize commits array
commits=()

if $ISGIT; then
  # Check if the branch has any commits
  if ! git log --pretty=format:"%cd" --date=short >/dev/null 2>&1; then
    # Get the current branch name
    BRANCH_NAME=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)

    echo "Branch $BRANCH_NAME has no commits"

    exit 0
  fi

  # Get unique commit dates
  DATES=$(git log --pretty=format:"%cd" --date=short | sort | uniq)

  for date in $DATES; do
    week=$(date -j -f "%Y-%m-%d" "$date" +%V | sed 's/^0*//')
    day=$(date -j -f "%Y-%m-%d" "$date" +%w) # 0 (Sunday) to 6 (Saturday)
    count=$(git log --pretty=format:"%cd" --date=short | grep "$date" | wc -l | xargs)

    if ((week < TODAY_WK_NUM)); then
      adjusted_week=$(((week - TODAY_WK_NUM + $GRID_COLS) % $GRID_COLS))
    else
      adjusted_week=$((week - TODAY_WK_NUM + $GRID_COLS))
    fi

    if [[ $@ == *"--full-width"* ]]; then
      adjusted_week=$((adjusted_week + $DIFF))
    fi

    commits+=("$day,$adjusted_week,$count")
  done
else
  REPOS=$(gh api \
    -H "Accept: application/vnd.github+json" \
    -H "X-GitHub-Api-Version: 2022-11-28" \
    /user/repos --jq '.[].name')

  for repo in $REPOS; do
    raw_dates=$(gh api \
      -H "Accept: application/vnd.github+json" \
      -H "X-GitHub-Api-Version: 2022-11-28" \
      /repos/michaelmonetized/$repo/commits --jq '.[].commit.author.date')

    for date in $raw_dates; do
      date_format=$(echo $date | cut -d'T' -f1)

      week=$(date -j -f "%Y-%m-%d" "$date_format" +%V | sed 's/^0*//')
      day=$(date -j -f "%Y-%m-%d" "$date_format" +%w)
      count=$(grep -c "$date_format" <<<"$raw_dates")

      if [[ $week -lt $TODAY_WK_NUM ]]; then
        adjusted_week=$(((week - TODAY_WK_NUM + $GRID_COLS) % $GRID_COLS))
      else
        adjusted_week=$((week - TODAY_WK_NUM + $GRID_COLS))
      fi

      if [[ $@ == *"--full-width"* ]]; then
        adjusted_week=$((adjusted_week + $DIFF))
      fi

      commits+=("$day,$adjusted_week,$count")
    done
  done
fi

# Print the grid
for row in $(seq 0 $GRID_ROWS); do
  for col in $(seq 0 $GRID_COLS); do
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

if $ISGIT; then
  # show issues if --show-issues is passed anywhere in $@
  if [[ $@ == *"--show-issues"* ]]; then
    gh issue list 2>/dev/null
  fi

  # show todos if --show-todos is passed anywhere in $@
  if [[ $@ == *"--show-todos"* ]]; then
    rg "(\[\s\]|TODO|BUG|FIXME|ISSUE|HACK|\[\-\])" -g '!*/lib/*' -g '!*/node_modules/*' -g '!*/vendor/*' -NU --color=always
  fi
fi
