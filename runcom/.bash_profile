# Set the PATH so it includes private bin if it exists.
if [ -d "$HOME/bin" ]; then
    PATH="$HOME/bin:$PATH"
fi

# Set vim as the default CLI editor.
export EDITOR=vim

# Cause bash to launch in tmux, attaching to a live session if available.
[[ $TERM != "screen" ]] && exec tmux new-session # -A -s 0 # Add -A to attach on start.

# Source other dotfiles
source ~/.env
source ~/.alias

if [ -f $HOME/.path ]; then
	source ~/.path
fi
