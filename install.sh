#!/usr/bin/env bash

# Save working directory
OLDDIR=$('pwd')

# Get current dir
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

# Backup old .ctags and hardlink the new one.
if [ -f ~/.ctags ]; then
	echo "Found existing .ctags. Backing up and replacing."
	mv ~/.ctags $BACKUP_DIR/.ctags_old
fi
ln -F ./.ctags ~/

# Backup old .bash_profile and hardlink the new one.
if [ -f ~/.bash_profile ]; then
	echo "Found existing .bash_profile. Backing up and replacing."
	mv ~/.bash_profile $BACKUP_DIR/.bash_profile_old
fi
ln -F ./runcom/.bash_profile ~/

# Backup old .env and hardlink the new one.
if [ -f ~/.env ]; then
	echo "Found existing .env. Backing up and replacing."
	mv ~/.env $BACKUP_DIR/.env_old
fi
ln -F ./runcom/.env ~/

# Backup old .alias and hardlink the new one.
if [ -f ~/.alias ]; then
	echo "Found existing .alias. Backing up and replacing."
	mv ~/.alias $BACKUP_DIR/.alias_old
fi
ln -F ./system/.alias ~/

# Backup old .gitconfig and hardlink the new one.
if [ -f ~/.gitconfig ]; then
	echo "Found existing .gitconfig. Backing up and replacing."
	mv ~/.gitconfig $BACKUP_DIR/.gitconfig_old
fi
ln -F ./git/.gitconfig ~/

# Backup old .gitignore_global and hardlink the new one.
if [ -f ~/.gitignore_global ]; then
	echo "Found existing .gitignore_global. Backing up and replacing."
	mv ~/.gitignore_global $BACKUP_DIR/.gitignore_global_old
fi
ln -F ./git/.gitignore_global ~/

# Execute vim setup.
echo "Setting up vim."
./vim/install_vimrc.sh

# Return to previous working directory.
cd $OLDDIR
