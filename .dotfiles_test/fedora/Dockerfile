FROM fedora:27

MAINTAINER Nick Mosher <nicholastmosher@gmail.com>

RUN dnf install -y sudo \
    && adduser user \
    && mkdir -p /home/user \
    && echo "user ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/user \
    && chmod 0440 /etc/sudoers.d/user

ARG CACHEBUST=1
RUN su - user -c "echo y | bash -x -c '$(curl -fsSL https://raw.githubusercontent.com/nicholastmosher/dotfiles/master/install.sh)'"
