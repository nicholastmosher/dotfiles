# Prompt confirmation.
read -p "Are you sure you want to continue? This may overwrite existing files. [y/N] " yn
case $yn in
	[yY]* ) break;;
	* ) exit;;
esac

# Alias "dot" as a special git command with repo and work tree paths.
GIT=`which git`
export DOT="$GIT --git-dir=$HOME/.dot --work-tree=$HOME"
alias dot="$DOT"

# Download dotfiles into ~/.dot
if [ -d $HOME/.dot ]; then
	# Force update from origin.
	dot fetch -q origin
	dot reset -q --hard origin/master
elsif
	# Clone and force checkout.
	git clone -q --bare https://github.com/nicholastmosher/dotfiles.git $HOME/.dot
	dot checkout -q -f master
fi

# Download oh-my-zsh into ~/.oh-my-zsh
if [ ! -d $HOME/.oh-my-zsh ]; then
	git clone -q https://github.com/nicholastmosher/oh-my-zsh.git $HOME/.oh-my-zsh
fi

# Setup vim.
$HOME/.vim/setup.sh &> /dev/null

# Finished
echo "\nInstall complete!"
