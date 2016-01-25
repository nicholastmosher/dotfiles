git clone https://github.com/harlanhaskins/harlan-vimrc.git ~/.harlan-vimrc; ~/.harlan-vimrc/setup_vimrc.sh

# Add whitespace preferences to Harlan's .vimrc
echo "" | cat >> ~/.vimrc
echo "\" Whitespace" | cat >> ~/.vimrc
echo "set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<" | cat >> ~/.vimrc
echo "set list" | cat >> ~/.vimrc
