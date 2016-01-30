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

# Backup old .ctags and hardlink the new one.
if [ -f ~/.ctags ]; then
	echo "Found existing .ctags. Backing up and replacing."
	mv ~/.ctags $BACKUP_DIR/.ctags_old
fi

# Hardlink new files.
ln -F ./.ctags ~/

# Return to previous working directory.
cd $OLDDIR
