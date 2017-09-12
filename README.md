# Dotfiles

[![Build status](https://travis-ci.org/nicholastmosher/dotfiles.svg?branch=master)](https://travis-ci.org/nicholastmosher/dotfiles)

Here's a repo of all of my favorite environment configurations, including
setups for zsh, xterm, tmux, vim, i3, etc. If you're in it for a quick install
and you trust me, you can just run:

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/nicholastmosher/dotfiles/master/install.sh)"
```

## Now let me explain what you just installed

### Dotfiles management

Let's start with the management technique. The root of this repository
represents the status of your homedir after installing. This is done by placing
the git repo into a side folder (~/.dot) so that subdirectories of your
homedir (and thus, other git repositories) aren't shadowed by the dotfiles repo.
If you'd like to read more about this technique, the original idea came from
[this hacker news article](https://news.ycombinator.com/item?id=11070797) which
was later referenced in [this atlassian blog post](https://developer.atlassian.com/blog/2016/02/best-way-to-store-dotfiles-git-bare-repo/).

This means that you can manage any file or directory in your homedir, provided
that you use the alias `dot` instead of `git` while referencing the dotfiles
repo. For example, if you add some aliases to `.alias` and want to commit them,
you would use

```bash
dot add .alias
dot commit -m "message"
```

### Vim

Most of my vim installation process came from
[Harlan's](https://github.com/harlanhaskins/harlan-vimrc) setup. It's got a
script to download and install vundle, and a bundles file (.vimrc_bundles) that
lists the git repositories of plugins to install. Run `.vim/setup.sh`, and
everything will handle itself. If you want to just install the vim setup
without the other dotfiles setup, you should be able to just run

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/nicholastmosher/dotfiles/master/.vim/setup.sh)"
curl -fsSL https://raw.githubusercontent.com/nicholastmosher/dotfiles/master/.vimrc > $HOME/.vimrc
```

### Tmux

Most of my tmux setup involves integrating with vim for inter-pane navigation
using C-(h j k l). Apart from that, the only other changes are the powerline
theme and navigating to next/prev windows using `C-\` and `C-]` respectively.
