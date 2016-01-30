#!/bin/bash

# Save working directory.
OLDDIR=$('pwd')

# Get current dir.
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

# If the vim backup dir does not exist, create it.
if [ ! -d $BACKUP_DIR ]; then
	echo "Backup directory for vim does not exist. Creating $BACKUP_DIR/vim."
	mkdir -p $BACKUP_DIR/vim
fi

# Backup old .vimrc.
if [ -f ~/.vimrc ]; then
	echo "Found existing .vimrc. Backing up to $BACKUP_DIR/vim."
	mv ~/.vimrc $BACKUP_DIR/.vimrc_old
fi

# Backup old .vimrc_bundles.
if [ -f ~/.vimrc_bundles ]; then
	echo "Found existing .vimrc_bundles. Backing up to $BACKUP_DIR/vim."
	mv ~/.vimrc_bundles $BACKUP_DIR/.vimrc_bundles_old
fi

# Backup old .vimrc_vundle.
if [ -f ~/.vimrc_vundle ]; then
	echo "Found existing .vimrc_vundle. Backing up to $BACKUP_DIR/vim."
	mv ~/.vimrc_vundle $BACKUP_DIR/.vimrc_vundle_old
fi

# Hardlink new vim files.
ln -F .vimrc ~/
ln -F .vimrc_vundle ~/
ln -F .vimrc_bundles ~/

# Install Vundle (https://github.com/gmarik/vundle)
git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle

# If vim is version 7.4, install YouCompleteMe.
VIM_VERSION = 'vim --version | grep 7.4'
if [[$VIM_VERSION != ""]]; then
	echo "Bundle 'Valloric/YouCompleteMe'" >> .vimrc_bundles
fi

# Clean/install bundles
vim -u .vimrc_setup

# Return to the original directory.
cd $OLDDIR
