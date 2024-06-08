# Show a graph of your commits V1.0.2

This is a command line tool to show a graph of your commits as ascii art.
![ascii-commit-graph-screenshot](https://raw.githubusercontent.com/michaelmonetized/ascii-commit-graph/master/screenshot.png)

## To Do

- [ ] Merge with rc
- [ ] Create a release

## Dependencies

- [gh](https://github.com/cli/cli) _optional for showing issues with `--show-issues`_
- [rg](https://github.com/BurntSushi/ripgrep) _optional for showing todos with `--show-todos`_

## Installation

1 clone into ~/bin/

```bash
git clone https://github.com/michael-k/ascii-commit-graph.git ~/bin/ascii-commit-graph
```

2 add write permissions

```bash
chmod +x ~/bin/ascii-commit-graph/ascii-commit-graph.sh
```

3 create a symlink to /usr/local/bin/

```bash
sudo ln -s ~/bin/ascii-commit-graph/ascii-commit-graph.sh /usr/local/bin/ascii-commit-graph
```

## Usage

### Show all commits for the last 52 weeks

```bash
ascii-commit-graph
```

![ascii-commit-graph-example](https://raw.githubusercontent.com/michaelmonetized/ascii-commit-graph/master/screenshot.png)

### Show only columns for the current year

```bash
ascii-commit-graph --this-year
```

### Show commit history full-width

[x] maybe make this a rule on the default behavior if tput cols is less than 52

```bash
ascii-commit-graph --full-width
```

## Extra

### Add to your .bashrc zoxide config

```bash
zcd() {
  if [ "$#" -eq 0 ]; then
    z
  else
    z "$@"
  fi

  ascii-commit-graph --full-width --show-issues --show-todos
}

alias cd="zcd"

eval "$(zoxide init zsh)"
```

## Bonus new features for gh users

when you're not in a git repo you can see your commit history for all your repos.

### Show issues

```bash
ascii-commit-graph --show-issues
```

runs `gh issue list` and shows the issues in the current directory.

### Show todos (for rg users)

```bash
ascii-commit-graph --show-todos
```

runs `rg "(\[\s\]|TODO|BUG|FIXME|ISSUE|HACK|\[\-\])" -g '!*/lib/*' -g '!*/node_modules/*' -g '!*/vendor/*' -NU --color=always` and shows the todos found in the current directory's files.

Made with ❤️ by [Michael Hurley D/B/A Hustle Launch](https://www.michaelchurley.com)
![hustle-launch-animated](https://github.com/michaelmonetized/ascii-commit-graph/assets/162010215/da2f7c1e-d0b9-48d6-b913-df3c6f40d8c0)
