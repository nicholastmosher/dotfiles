# Set the PATH so it includes private bin if it exists.
if [ -d "$HOME/bin" ]; then
	PATH="$HOME/bin:$PATH"
fi

# Set vim as the default CLI editor.
export EDITOR=vim

# Cause bash to launch in tmux, attaching to a live session if available.
# [[ $TERM != "screen" ]] && exec tmux new-session # -A -s 0 # Add -A to attach on start.

# The .tmux.conf will launch a new session to attach to if none already exist.
# Tmux will also give a recursive warning, so clear to scroll past it.
tmux attach; clear

# Source other dotfiles
source ~/.env
source ~/.alias

# If the user has a .path file source it.
if [ -f $HOME/.path ]; then
	source ~/.path
fi

# If the user has a private alias, source it.
if [ -f $HOME/.alias.private ]; then
	source ~/.alias.private
fi
