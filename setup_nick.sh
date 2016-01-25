# If the user does not have a ~/bin directory, create it.
if [ ! -d "$HOME/bin" ]; then
    mkdir $HOME/bin
fi

# Copy files into user's bin folder.
cp -r ./bin/* $HOME/bin

# Copy the global gitignore file to the home directory.
cp .gitignore $HOME/.gitignore

# Configure the global gitignore
git config --global core.excludesfile '$HOME/.gitignore'

# Setup a .profile to set bash as default shell.
# echo "" | cat >> .profile
# echo "export SHELL=/bin/bash" | cat >> .profile
# echo "exec '/bin/bash'" | cat >> .profile

# Tell bash to source the .bash_profile
# echo "" | cat >> .bashrc
# echo "source .bash_profile" | cat >> .bashrc
