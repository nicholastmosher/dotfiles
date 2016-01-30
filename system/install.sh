#!/usr/bin/env bash

# Save working directory
OLDDIR=$('pwd')

# Get current dir
SYSTEM_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)"
cd $SYSTEM_DIR

# If the backup directory for system does not exist, create it.
if [ ! -d $BACKUP_DIR/system ]; then
	echo "Backup directory for system does not exist. Creating $BACKUP_DIR/system."
	mkdir -p $BACKUP_DIR/system
fi

# Backup old .alias.
if [ -f ~/.alias ]; then
	echo "Found existing .alias. Backing up to $BACKUP_DIR/system."
	mv ~/.alias $BACKUP_DIR/system/.alias_old
fi

# Hardlink new system files.
ln -F ./.alias ~/

# Return to previous working directory.
cd $OLDDIR
