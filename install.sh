# Banner
printf "$(tput setaf 4)"
echo "_____   ______      ______      ________      _______________________            "
echo "___  | / /__(_)________  /__    ___  __ \_______  /___  __/__(_)__  /____________"
echo "__   |/ /__  /_  ___/_  //_/    __  / / /  __ \  __/_  /_ __  /__  /_  _ \_  ___/"
echo "_  /|  / _  / / /__ _  ,<       _  /_/ // /_/ / /_ _  __/ _  / _  / /  __/(__  ) "
echo "/_/ |_/  /_/  \___/ /_/|_|      /_____/ \____/\__/ /_/    /_/  /_/  \___//____/  "
echo "                                                                                 "
echo
printf "$(tput sgr0)"

# Prompt confirmation.
read -p "Are you sure you want to continue? This may overwrite existing files. [y/N] " yn
case $yn in
	[yY]* ) break;;
	* ) exit;;
esac

# Store the location of this install script.
SCRIPT="$(cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd )"

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
	git clone -q --bare git@github.com:nicholastmosher/dotfiles.git $HOME/.dot
	dot config status.showUntrackedFiles no
	dot checkout -q -f master
fi

echo "Installing powerline fonts..."
if [ ! -d $HOME/fonts ]; then
	git clone -q git@github.com:powerline/fonts.git ~/fonts
	$HOME/fonts/install.sh
fi

# Detect if zsh is installed.
if [ -n "$(which zsh | grep -F zsh)" ]; then
	echo "=== Zsh is installed. Installing plugins... ==="

	# Detect if OMZ is installed.
	if [ ! -d $HOME/.oh-my-zsh ]; then
		echo "Installing oh-my-zsh..."
		sh -c "$(curl -fsSL https://raw.githubusercontent.com/nicholastmosher/oh-my-zsh/master/tools/install.sh)"
	else
		echo "Updating oh-my-zsh..."
		cd $ZSH; git pull --rebase --stat origin master; cd $SCRIPT
	fi

	# Detect if zsh-autosuggestions is installed.
	if [ ! -d $ZSH_CUSTOM/plugins/zsh-autosuggestions ]; then
		echo "Cloning zsh-autsuggestions..."
		git clone -q git@github.com:zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions
	else
		echo "Updating zsh-autosuggestions..."
		cd $ZSH_CUSTOM/plugins/zsh-autosuggestions; git pull --rebase --stat origin master; cd $SCRIPT
	fi

	echo "============ Zsh plugins installed! ==========="
fi

echo "Setting up vim..."
$HOME/.vim/setup.sh &> /dev/null

# Finished
echo
echo "Install complete!"
