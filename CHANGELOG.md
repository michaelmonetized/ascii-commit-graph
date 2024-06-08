# CHANGELOG

## 1.0.3

- [x] Added --author flag back to protect cd from slowing down
- [x] wrapped regex pattern fot todos in word boundaries to be less greedy
- [x] Added more glob excludes to cleanup todos

## 1.0.2

- [x] Fixed issue with dates that have a time component
- [x] Added max-width behavior if terminal width is less than 52
- [x] Fixed issue with gh api contributions
- [x] Removed --author option
- [x] Added feature to show logged in user's commits when not inside a git repo

## 1.0.1

- [x] Moved direcorty is repo or in git repo check to the top of the script as a variable
- [x] Added options to show issues and todos
- [x] Added option to change date range from 52 week to full width or this year
- [x] Added option to show all authorized gh cli user commits when not inside a git repo

## ROADMAP

- [ ] Add color options
- [ ] Merge main into rc
- [ ] Create a release for 1.0.3

we'll need to find a way to dim the color for the counts.
