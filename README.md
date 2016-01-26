# nickrc

This is a set of the runtime configurations that I use on my day-to-day
linux setups. I've put together this repo so that I can quickly migrate
to a new machine, and so that others can pick up some of my settings if
they so wish.

## Setup scripts

I've got two setup scripts in here, one that I'll use when I migrate to
a new machine - that'll be the `setup_nick.sh`. The other one,
`setup_guest.sh` is nearly identical, except that it doesn't copy my
public ssh key into your ~/.ssh/ directory.

Here are two one-liners that will install my runtime configurations. The
first one is what I personally use on new and remote machines, as it
installs my public SSH key. IF YOU USE `setup_nick.sh` YOU ARE GIVING ME
THE FRONT DOOR KEY TO YOUR COMPUTER. The `setup_guest.sh` does NOT
install my SSH key.

This is the one for me:

    git clone https://github.com/nicholastmosher/nickrc.git ~/.nickrc; ~/.nickrc/setup_nick.sh

This is the (safer) one for you:

    git clone https://github.com/nicholastmosher/nickrc.git ~/.nickrc; ~/.nickrc/setup_guest.sh

### .vimrc

The .vimrc that I use is about 99% Harlan Haskins's. In fact, I didn't
even duplicate it because his install script is so gorgeous, I just call
his install from mine. If you want just his .vimrc, you can get it on his
[repo](https://github.com/harlanhaskins/harlan-vimrc).

### .bash_profile

Right before the .bash_profile gets installed, the setup script makes sure
you have a ~/bin directory and then it gets added to the $PATH. Also,
the .bash_profile will cause all new bash sessions to be executed in tmux,
with new instances becoming automatically attached to existing ones.
This is particularly useful to have on remote machines because always being
in tmux means that it's never an afterthought if you need to leave a long
process running detached.  Having it attach automatically means that you
won't forget about old sessons, because you'll be brought right back to them.

### ctags

Ctags is an excellent compliment to vim, as it gives it IDE-like searching
capabilities. Running `ctags -R .` in a project directory will cause ctags
to index every keyword in source files in that structure. Vim will then
look at the ctags file to gain insight as to where program elements are,
and give you the ability to jump to declarations.
