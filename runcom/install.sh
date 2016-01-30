#!/usr/bin/env bash

# Save working directory
OLDDIR=$('pwd')

# Get current dir
RUNCOM_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)"
cd $RUNCOM_DIR

# If the runcom backup dir does not exist, create it.
if [ ! -d $BACKUP_DIR/runcom ]; then
	echo "Backup directory for runcom does not exist. Creating $BACKUP_DIR/runcom."
	mkdir -p $BACKUP_DIR/runcom
fi

# Backup old .bash_profile.
if [ -f ~/.bash_profile ]; then
	echo "Found existing .bash_profile. Backing up to $BACKUP_DIR/runcom."
	mv ~/.bash_profile $BACKUP_DIR/runcom/.bash_profile_old
fi

# Backup old .bashrc.
if [ -f ~/.bashrc ]; then
	echo "Found existing .bashrc. Backing up to $BACKUP_DIR/runcom."
	mv ~/.bashrc $BACKUP_DIR/runcom/.bashrc_old
fi

# Backup old .env.
if [ -f ~/.env ]; then
	echo "Found existing .env. Backing up to $BACKUP_DIR/runcom."
	mv ~/.env $BACKUP_DIR/runcom/.env_old
fi

# Hardlink new runcom files.
ln -F ./.bash_profile ~/
ln -F ./.bashrc ~/
ln -F ./.env ~/

# Return to previous working directory.
cd $OLDDIR
