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

# Prevent screen freeze from control S.
stty -ixon

##
# Your previous /Users/nmosher/.bash_profile file was backed up as /Users/nmosher/.bash_profile.macports-saved_2016-06-07_at_19:44:36
##

# MacPorts Installer addition on 2016-06-07_at_19:44:36: adding an appropriate PATH variable for use with MacPorts.
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
# Finished adapting your PATH environment variable for use with MacPorts.

PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
