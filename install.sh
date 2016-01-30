#!/usr/bin/env bash

# Save working directory
OLDDIR=$('pwd')

# Get current dir.
export DOTFILES_DIR BACKUP_DIR
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)"
cd $DOTFILES_DIR

# If the backup directory does not exist, create it.
BACKUP_DIR="$HOME/.dotfiles_backup"
if [ ! -d $BACKUP_DIR ]; then
	echo "Backup directory does not exist. Creating $BACKUP_DIR"
	mkdir -p $BACKUP_DIR
fi

# Update dotfiles itself first
[ -d "$DOTFILES_DIR/.git" ] && git --work-tree="$DOTFILES_DIR" --git-dir="$DOTFILES_DIR/.git" pull origin master

# Execute sub setup scripts.
./vim/install.sh
./git/install.sh
./runcom/install.sh
./system/install.sh

# Backup old ~/bin.
if [ -d ~/bin ]; then
	echo "Found existing ~/bin dir. Backing up to $BACKUP_DIR/bin."
	mv ~/bin $BACKUP_DIR/bin_old
fi

# Backup old .ctags.
if [ -f ~/.ctags ]; then
	echo "Found existing .ctags. Backing up to $BACKUP_DIR."
	mv ~/.ctags $BACKUP_DIR/.ctags_old
fi

# Backup old .tmux.conf.
if [ -f ~/.tmux.conf ]; then
	echo "Found existing .tmux.conf. Backing up to $BACKUP_DIR."
	mv ~/.tmux.conf $BACKUP_DIR/.tmux.conf_old
fi

# Hardlink new files.
ln -F ./.ctags ~/
ln -F ./.tmux.conf ~/

# Symlink the ~/bin dir.
ln -s $DOTFILES_DIR/bin ~/

# Return to previous working directory.
cd $OLDDIR
