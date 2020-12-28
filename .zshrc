# Path to oh-my-zsh installation.
export ZSH=${HOME}/.oh-my-zsh
export ZSH_CUSTOM=$ZSH/custom

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
ZSH_THEME="agnoster"

# Hyphen-insensitive completion.
HYPHEN_INSENSITIVE="true"

# Plugins
plugins=(git vi-mode zsh-autosuggestions kubectl)

### User configuration ###

export EDITOR="vim"

# Source "oh-my-zsh" if installed
[[ -f "${ZSH}/oh-my-zsh.sh" ]] && DISABLE_AUTO_UPDATE=true source "${ZSH}/oh-my-zsh.sh"

# Source .osx if Darwin
[[ "$(uname)" == "Darwin" ]] && source "${HOME}/.osx"

# Configure fuzzy finder if installed
[[ -f "${HOME}/.fzf.zsh" ]] && source "${HOME}/.fzf.zsh"

# If rg is installed, use it as fzf command.
if [[ -x "$(command -v "rg")" ]]; then
	export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow -g "!{.git,node_modules}/*" 2> /dev/null'
	export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
fi

# Source .alias if present
[[ -f "${HOME}/.alias" ]] && source "${HOME}/.alias"

# Source .path if present
[[ -f "${HOME}/.path" ]] && source "${HOME}/.path"

# Launch tmux on start. Uncomment the end to attach on start.
if [[ "${TERM}" != *"screen"* && "${TERM}" != "dumb" ]]; then
	exec tmux new-session # -A -s 0
fi

nvm() {
	if [[ ! -d "${HOME}/.nvm" ]]; then
		echo "Nvm is not installed"
		return
	fi

	unset -f nvm
	export NVM_DIR="$HOME/.nvm"
	[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
	[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
	nvm "$@"
}

if [[ -x "$(command -v "starship")" ]]; then
	eval "$(starship init zsh)"
fi
