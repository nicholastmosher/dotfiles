#!/bin/bash

printf "%s" "$(tput setaf 4)" # Blue
echo "_____   ______      ______      ________      _______________________            "
echo "___  | / /__(_)________  /__    ___  __ \_______  /___  __/__(_)__  /____________"
echo "__   |/ /__  /_  ___/_  //_/    __  / / /  __ \  __/_  /_ __  /__  /_  _ \_  ___/"
echo "_  /|  / _  / / /__ _  ,<       _  /_/ // /_/ / /_ _  __/ _  / _  / /  __/(__  ) "
echo "/_/ |_/  /_/  \___/ /_/|_|      /_____/ \____/\__/ /_/    /_/  /_/  \___//____/  "
echo "                                                                                 "
printf "%s" "$(tput sgr0)" # Normal color

set -x

# Prompt confirmation.
read -p "Are you sure you want to continue? This may overwrite existing files. [y/N] " yn
case "${yn}" in
	[yY]* ) ;;
	* ) exit;;
esac

# If XDG_CONFIG_HOME is not set, set it to $HOME.
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME}"

install_utils() {

	# Install on Debian
	if [[ -x "$(command -v apt)" ]]; then
		yes | sudo apt update
		yes | sudo apt install git
		yes | sudo apt install vim
	fi
}

# Download dotfiles into "${HOME}/.dot"
download_dotfiles() {

	# Alias "dot" as a special git command with repo and work tree paths.
	alias dot="$(which git) --git-dir=${HOME}/.dot --work-tree=${HOME}"

	if [[ -d "${HOME}/.dot" ]]; then
		echo "Found dotfiles. Updating"
		dot config status.showUntrackedFiles no
		dot fetch -q origin
		dot reset -q --hard origin/master
	else
		echo "Cloning dotfiles"
		git clone -q --bare https://github.com/nicholastmosher/dotfiles.git "${HOME}/.dot"
		dot config status.showUntrackedFiles no
		dot checkout -q -f master
	fi
}

install_fonts() {
	echo "Installing fonts"
	if [[ ! -d "${HOME}/fonts" ]]; then
		echo "Installing powerline fonts"
		git clone -q https://github.com/powerline/fonts.git "${HOME}/fonts"
		bash "${HOME}/fonts/install.sh"
	fi
}

# Install zsh on osx or some linux distros.
install_zsh() {
	echo "Installing zsh"
	[[ "$(uname)" == "Darwin"    ]] && yes | brew install zsh zsh_completions
	[[ -x "$(command -v apt)"    ]] && yes | sudo apt install zsh
	[[ -x "$(command -v dnf)"    ]] && yes | sudo dnf install zsh
	[[ -x "$(command -v pacman)" ]] && yes | sudo pacman -S zsh

	# Use zsh as startup shell
	chsh -s "$(which zsh)"
}

# Configure ZSH with oh-my-zsh
configure_zsh() {
	# Verify that zsh is installed.
	if [[ ! -x "$(command -v zsh)" ]]; then
		echo "Zsh is not installed"
		return
	fi

	echo "Zsh is installed. Installing plugins"
	source "${HOME}/.zshrc"

	# Detect if OMZ is installed.
	if [[ ! -d "${HOME}/.oh-my-zsh" ]]; then
		echo "Installing oh-my-zsh"
		git clone -q https://github.com/nicholastmosher/oh-my-zsh.git "${HOME}/.oh-my-zsh"
	else
		echo "Updating oh-my-zsh"
		( # Use a subshell to return to current dir after this step.
			cd "${HOME}/.oh-my-zsh" || return
			git fetch -q origin;
			git reset -q --hard origin/master
		)
	fi
	source "${HOME}/.zshrc" # Now resolves .oh-my-zsh

	# Detect if zsh-autosuggestions is installed.
	if [[ ! -d "${ZSH_CUSTOM}/plugins/zsh-autosuggestions" ]]; then
		echo "Cloning zsh-autsuggestions"
		git clone -q https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM}/plugins/zsh-autosuggestions"
	else
		echo "Updating zsh-autosuggestions"
		( # Use a subshell to return to current dir after this step.
			cd "${ZSH_CUSTOM}/plugins/zsh-autosuggestions" || return
			git pull -q --rebase --stat origin master;
		)
	fi

	echo "Zsh plugins installed"
}

# Install ripgrep completions for any installed shells.
install_ripgrep_completions() {
	echo "Installing ripgrep completions"
	local completions_path="$1/complete"; shift
	local install_dir

	# Install rg completions for bash
	if [[ -x "$(command -v bash)" ]]; then
		install_dir="${XDG_CONFIG_HOME}/bash_completion"
		[[ ! -d "${install_dir}" ]] && mkdir -p "${install_dir}"
		cp "${completions_path}/rg.bash-completion" "${install_dir}/"
	fi

	# Install rg completions for fish
	if [[ -x "$(command -v fish)" ]]; then
		install_dir="${HOME}/.config/fish/completions"
		[[ ! -d "${install_dir}" ]] && mkdir -p "${install_dir}"
		cp "${completions_path}/rg.fish" "${install_dir}/"
	fi

	# Install rg completions for zsh
	if [[ -x "$(command -v zsh)" ]]; then
		install_dir="${HOME}/.zfunc"
		[[ ! -d "${install_dir}" ]] && mkdir -p "${install_dir}"
		cp "${completions_path}/_rg" "${install_dir}/"
	fi
}

# Install ripgrep.
install_ripgrep() {

	# If ripgrep is already installed, return
	[[ -x "$(command -v rg)" ]] && return

	echo "Installing ripgrep"

	# How to install on osx.
	if [[ "$(uname)" == "Darwin" ]]; then
		brew install ripgrep
		return
	fi

	# How to install on Fedora
	if [[ -x "$(command -v dnf)" ]]; then
		dnf copr enable carlwgeorge/ripgrep
		dnf install ripgrep
		return
	fi
	if [[ -x "$(command -v yum)" ]]; then
		yum-config-manager --add-repo=https://copr.fedorainfracloud.org/coprs/carlwgeorge/ripgrep/repo/epel-7/carlwgeorge-ripgrep-epel-7.repo
		yum install ripgrep
		return
	fi

	# How to install on Arch
	if [[ -x "$(command -v pacman)" ]]; then
		pacman -S ripgrep
		return
	fi

	 # Other linux
	if [[ "$(uname)" == "Linux" ]]; then
		local rg_release="ripgrep-0.5.2-x86_64-unknown-linux-musl"
		wget https://github.com/BurntSushi/ripgrep/releases/download/0.5.2/ripgrep-0.5.2-x86_64-unknown-linux-musl.tar.gz > /dev/null
		tar xf "${rg_release}.tar.gz"
		cp "${rg_release}/rg" "${HOME}/bin/"
		install_ripgrep_completions "./${rg_release}";
		rm "${rg_release}.tar.gz"
		rm -r "${rg_release}"
	fi
}

# Install fuzzy-finder
install_fzf() {
	# If fzf is already installed, return
	[[ -x "$(command -v fzf)" ]] && return

	echo "Installing fzf"
	git clone https://github.com/junegunn/fzf "${HOME}/.fzf"
	bash "${HOME}/.fzf/install"
}

# Set up vim
configure_vim() {
	echo "Setting up vim"
	bash "${HOME}/.vim/setup.sh" &> /dev/null
}

main() {
	install_utils;
	download_dotfiles;
	install_fonts;
	install_zsh;
	configure_zsh;
	configure_vim;
	install_ripgrep;
	install_fzf;

	# Finished
	echo
	echo "Install complete!"
}
main

set +x
