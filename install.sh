# Prompt confirmation.
read -p "Are you sure you want to continue? This may overwrite existing files. [y/N] " yn
case $yn in
	[yY]* ) break;;
	* ) exit;;
esac

GIT=`which git`

# Download dotfiles into ~/.dot
git clone -q --bare https://github.com/nicholastmosher/dotfiles.git $HOME/.dot

# Alias "dot" as a special git command with repo and work tree paths.
export DOT="$GIT --git-dir=$HOME/.dot --work-tree=$HOME"
alias dot="$DOT"

# Force checkout master, writing files from repo into home.
dot checkout -f master

# Download oh-my-zsh into ~/.oh-my-zsh
git clone -q https://github.com/nicholastmosher/oh-my-zsh.git $HOME/.oh-my-zsh

# Setup vim.
$HOME/.vim/setup.sh

# Finished
clear; echo "Install complete!"
