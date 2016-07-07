# Dotfiles

This is a set of the dotfiles I use for my unix setups. Feel free to use and
distribute them, but I'm not responsible if these break your system.

## Installation

Here's the easy installation for all of my dotfiles.

```bash
git clone --bare https://github.com/nicholastmosher/dotfiles $HOME/.dot
alias dot="/usr/bin/git --git-dir=$HOME/.dot --work-tree=$HOME"
dot checkout
```

## Quick Overview

So far in the dotfiles I've got configurations for git (`.gitconfig` and
`.gitignore_global`), vim (highly borrowed from
[Harlan's vim setup](https://github.com/harlanhaskins/harlan-vimrc)), tmux, i3,
and various bash and zsh configurations.

To read more about my dotfiles version control setup, check out
[this hacker news article](https://news.ycombinator.com/item?id=11070797)
and/or [this blog on atlassian](https://developer.atlassian.com/blog/2016/02/best-way-to-store-dotfiles-git-bare-repo/).
