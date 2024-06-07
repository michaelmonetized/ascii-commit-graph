# Show a graph of your commits

This is a command line tool to show a graph of your commits as ascii art.
![ascii-commit-graph-screenshot](https://raw.githubusercontent.com/michaelmonetized/ascii-commit-graph/master/screenshot.png)

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

Accepts no arguments and will show a graph of your commits in the current directory.

```bash
> ascii-commit-graph
```

![ascii-commit-graph-example](https://raw.githubusercontent.com/michaelmonetized/ascii-commit-graph/master/screenshot.png)

## Extra

### Add to your .bashrc zoxide config

```bash
zcd() {
  if [ "$#" -eq 0 ]; then
    zoxide query --interactive
  else
    zoxide add "$@" && z "$@"
  fi

  ascii-commit-graph
}

alias cd="zcd"

eval "$(zoxide init zsh)"
```

Made with ❤️ by [Michael Hurley D/B/A Hustle Launch](https://www.michaelchurley.com)
![hustle-launch-logo](https://raw.githubusercontent.com/michaelmonetized/my.hustlelaunch.com/master/public/hustle-launch-animated.svg)
