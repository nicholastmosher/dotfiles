#!/bin/bash

# Move to the directory of this script
OLDDIR = 'pwd'
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

# Backup old vimrc files
if [ -f ~/.vimrc ]; then
	echo "Found existing .vimrc. Backing up and replacing."
	mv ~/.vimrc $BACKUP_DIR/.vimrc_old
fi

if [ -f ~/.vimrc_bundles ]; then
	echo "Found existing .vimrc_bundles. Backing up and replacing."
	mv ~/.vimrc_bundles $BACKUP_DIR/.vimrc_bundles_old
fi

if [ -f ~/.vimrc_vundle ]; then
	echo "Found existing .vimrc_vundle. Backing up and replacing."
	mv ~/.vimrc_vundle $BACKUP_DIR/.vimrc_vundle_old
fi

# Create hardlinks between local vimrc files and the actual vimrc files.
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
