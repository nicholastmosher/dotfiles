OLD=`pwd` DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"; cd $DIR
git clone -q https://github.com/gmarik/vundle.git $HOME/.vim/bundle/vundle
vim -u .vimrc_setup
cd $OLD
