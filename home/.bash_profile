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
tmux -2; clear # Workstation setting.
#tmux attach; clear # Server setting.

# If the user has a .alias file source it.
if [ -f $HOME/.alias ]; then
	source $HOME/.alias
fi

# If the user has a .path file source it.
if [ -f $HOME/.path ]; then
	source $HOME/.path
fi

# If this is Darwin, source .osx
if [ "$(uname)" = "Darwin" ]; then
	source $HOME/.osx
fi

# Prevent screen freeze from control S.
stty -ixon

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
