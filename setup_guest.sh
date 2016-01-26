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

# Add my public key into the ~/.ssh/ directory.
# if [ ! -d "$HOME/.ssh" ]; then
#     mkdir -p $HOME/.ssh
# fi
# cat obsidyn.pub >> $HOME/.ssh/authorized_keys
# I've removed this configuration from setup_guest.sh for your comfort.

# Setup a .profile to set bash as default shell.
echo "" | cat >> .profile
echo "export SHELL=/bin/bash" | cat >> .profile
echo "exec '/bin/bash'" | cat >> .profile

# Tell bash to source the .bash_profile
echo "" | cat >> .bashrc
echo "source .bash_profile" | cat >> .bashrc

# Copy .bash_profile to home directory.
cp .bash_profile $HOME/.bash_profile
