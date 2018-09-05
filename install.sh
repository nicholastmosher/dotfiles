#!/bin/bash

set -e

[[ -x "$(command -v tput)" ]] && printf "%s" "$(tput setaf 4)" # Blue
echo "_____   ______      ______      ________      _______________________            "
echo "___  | / /__(_)________  /__    ___  __ \_______  /___  __/__(_)__  /____________"
echo "__   |/ /__  /_  ___/_  //_/    __  / / /  __ \  __/_  /_ __  /__  /_  _ \_  ___/"
echo "_  /|  / _  / / /__ _  ,<       _  /_/ // /_/ / /_ _  __/ _  / _  / /  __/(__  ) "
echo "/_/ |_/  /_/  \___/ /_/|_|      /_____/ \____/\__/ /_/    /_/  /_/  \___//____/  "
echo "                                                                                 "
[[ -x "$(command -v tput)" ]] && printf "%s" "$(tput sgr0)" # Normal color

# Prompt confirmation.
read -p "Are you sure you want to continue? This may overwrite existing files. [y/N] " yn
case "${yn}" in
	[yY]* ) ;;
	* ) exit;;
esac

# If XDG_CONFIG_HOME is not set, set it to $HOME.
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME}"

dot() {
	git --git-dir="${HOME}/.dot" --work-tree="${HOME}" "$@"
}

install_utils() {

	# Install on Debian
	if [[ -x "$(command -v apt-get)" ]]; then
		sudo apt-get update -y
		sudo apt-get install -y git vim tmux wget
		return
	fi

	# Install on Fedora
	if [[ -x "$(command -v dnf)" ]]; then
		sudo dnf install -y which git vim tmux wget findutils
		return
	fi
}

# Download dotfiles into "${HOME}/.dot"
download_dotfiles() {
	if [[ -d "${HOME}/.dot" ]]; then
		echo "Found dotfiles. Updating"
		dot config status.showUntrackedFiles no
		dot fetch -q origin
		dot reset -q --hard origin/master
	else
		echo "Cloning dotfiles"
		git clone --bare https://github.com/nicholastmosher/dotfiles.git "${HOME}/.dot"
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
	[[ "$(uname)" == "Darwin" ]] && brew install -y zsh zsh_completions

	# Install on Debian
	if [[ -x "$(command -v apt-get)" ]]; then
		sudo apt-get install -y zsh
		sudo chsh -s "$(which zsh)"
	fi

	# Install on Fedora
	if [[ -x "$(command -v dnf)" ]];then
		sudo dnf install -y zsh
		sudo usermod -s "$(which zsh)" "${USER}"
	fi
}

# Configure ZSH with oh-my-zsh
configure_zsh() {
	# Verify that zsh is installed.
	if [[ ! -x "$(command -v zsh)" ]]; then
		echo "Zsh is not installed"
		return
	fi

	echo "Zsh is installed. Installing plugins"
	source "${HOME}/.zshrc" || true

	# Detect if OMZ is installed.
	if [[ ! -d "${HOME}/.oh-my-zsh/README.md" ]]; then
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
	local RG_VERSION="0.9.0-x86_64-unknown-linux-musl"
	wget "https://github.com/BurntSushi/ripgrep/releases/download/0.9.0/ripgrep-${RG_VERSION}.tar.gz"
	tar xf "ripgrep-${RG_VERSION}.tar.gz"
	local COMPLETIONS_PATH="ripgrep-${RG_VERSION}/complete"; shift || true
	local INSTALL_DIR

	# Install rg completions for bash
	if [[ -x "$(command -v bash)" ]]; then
		echo "Installing rg completions for bash"
		INSTALL_DIR="${XDG_CONFIG_HOME}/bash_completion"
		[[ ! -d "${INSTALL_DIR}" ]] && mkdir -p "${INSTALL_DIR}"
		cp "${COMPLETIONS_PATH}/rg.bash" "${INSTALL_DIR}/"
	fi

	# Install rg completions for fish
	if [[ -x "$(command -v fish)" ]]; then
		echo "Installing rg completions for fish"
		INSTALL_DIR="${HOME}/.config/fish/completions"
		[[ ! -d "${INSTALL_DIR}" ]] && mkdir -p "${INSTALL_DIR}"
		cp "${COMPLETIONS_PATH}/rg.fish" "${INSTALL_DIR}/"
	fi

	# Install rg completions for zsh
	if [[ -x "$(command -v zsh)" ]]; then
		echo "Installing rg completions for zsh"
		INSTALL_DIR="${HOME}/.zfunc"
		[[ ! -d "${INSTALL_DIR}" ]] && mkdir -p "${INSTALL_DIR}"
		cp "${COMPLETIONS_PATH}/_rg" "${INSTALL_DIR}/"
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
		sudo dnf install -y dnf-"command(copr)"
		sudo dnf copr enable -y carlwgeorge/ripgrep
		sudo dnf install -y ripgrep
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
	install_ripgrep_completions;
	install_fzf;

	# Finished
	echo
	echo "Install complete! Please restart your shell for changes to take effect."
}
main

