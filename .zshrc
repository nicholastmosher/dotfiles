# Path to oh-my-zsh installation.
export ZSH=${HOME}/.oh-my-zsh
export ZSH_CUSTOM=$ZSH/custom

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
ZSH_THEME="agnoster"

# Hyphen-insensitive completion.
HYPHEN_INSENSITIVE="true"

# Plugins
plugins=(git sudo zsh-autosuggestions)

### User configuration ###

# Use kakoune as default editor if installed.
[[ -x "$(command -v kak)" ]] && export EDITOR="kak"

# Custom completions
fpath+=~/.zfunc

# Source "oh-my-zsh" if installed
[[ -f "${ZSH}/oh-my-zsh.sh" ]] && source "${ZSH}/oh-my-zsh.sh"

# Source .alias if present
[[ -f "${HOME}/.alias" ]] && source "${HOME}/.alias"

# Source .path if present
[[ -f "${HOME}/.path" ]] && source "${HOME}/.path"

# Source .osx if Darwin
[[ "$(uname)" == "Darwin" ]] && source "${HOME}/.osx"

# Launch tmux on start. Uncomment the end to attach on start.
[[ "${TERM}" != *"screen"* ]] && exec tmux new-session # -A -s 0

# Configure fuzzy finder if installed
[[ -f "${HOME}/.fzf.zsh" ]] && source "${HOME}/.fzf.zsh"

# If rg is installed, use it as fzf command.
if [[ -x "$(command -v "rg")" ]]; then
	export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow -g "!{.git,node_modules}/*" 2> /dev/null'
	export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
fi
