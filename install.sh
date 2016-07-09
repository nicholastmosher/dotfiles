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
	echo "Found dotfiles. Updating..."
	dot config status.showUntrackedFiles no
	dot fetch -q origin
	dot reset -q --hard origin/master
else
	echo "Cloning dotfiles..."
	git clone -q --bare https://github.com/nicholastmosher/dotfiles.git $HOME/.dot
	dot config status.showUntrackedFiles no
	dot checkout -q -f master
fi

echo "Installing powerline fonts..."
if [ ! -d $HOME/fonts ]; then
	git clone -q https://github.com/powerline/fonts.git ~/fonts
	$HOME/fonts/install.sh
fi

echo "Downloading oh-my-zsh..."
if [ ! -d $HOME/.oh-my-zsh ]; then
	git clone -q https://github.com/nicholastmosher/oh-my-zsh.git $HOME/.oh-my-zsh
fi

echo "Setting up vim..."
$HOME/.vim/setup.sh &> /dev/null

# Finished
echo
echo "Install complete!"
