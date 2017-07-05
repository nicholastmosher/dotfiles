# Path to oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh
export ZSH_CUSTOM=$ZSH/custom

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
ZSH_THEME="agnoster"

# Hyphen-insensitive completion.
HYPHEN_INSENSITIVE="true"

# Plugins
plugins=(git sudo zsh-autosuggestions)

### User configuration ###

export EDITOR="kak"

if [ -f $ZSH/oh-my-zsh.sh ]; then
	source $ZSH/oh-my-zsh.sh
fi

# Source .alias if present
if [ -f $HOME/.alias ]; then
	source $HOME/.alias
fi

# Source .path if present
if [ -f $HOME/.path ]; then
	source $HOME/.path
fi

# Source .osx if Darwin
if [ "$(uname)" = "Darwin" ]; then
	source $HOME/.osx
fi

# Launch tmux on start. Uncomment the end to attach on start.
[[ $TERM != *"screen"* ]] && exec tmux new-session # -A -s 0

# export NVM_DIR="/home/nick/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
