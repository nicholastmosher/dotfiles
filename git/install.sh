#!/usr/bin/env bash

# Save working directory
OLDDIR=$('pwd')

# Get current dir
GIT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)"
cd $GIT_DIR

# If the git backup dir does not exist, create it.
if [ ! -d $BACKUP_DIR/git ]; then
	echo "Backup directory for git does not exist. Creating $BACKUP_DIR/git."
	mkdir -p $BACKUP_DIR/git
fi

# Backup old .gitconfig.
if [ -f ~/.gitconfig ]; then
	echo "Found existing .gitconfig. Backing up to $BACKUP_DIR/git."
	mv ~/.gitconfig $BACKUP_DIR/.gitconfig_old
fi

# Backup old .gitignore_global.
if [ -f ~/.gitignore_global ]; then
	echo "Found existing .gitignore_global. Backing up to $BACKUP_DIR/git."
	mv ~/.gitignore_global $BACKUP_DIR/.gitignore_global_old
fi

# Hardlink new git files.
ln -F .gitconfig ~/
ln -F .gitignore_global ~/

# Configure the global gitignore.
git config --global core.excludesfile '~/.gitignore_global'

# Return to previous working directory.
cd $OLDDIR
