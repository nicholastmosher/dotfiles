FROM debian:buster

MAINTAINER Nick Mosher <nicholastmosher@gmail.com>

RUN apt-get update -y \
    && apt-get install -y sudo curl \
    && yes | adduser user \
    && mkdir -p /home/user \
    && echo "user ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/user \
    && chmod 0440 /etc/sudoers.d/user

ARG CACHEBUST=1
RUN su - user -c "echo y | bash -c '$(curl -fsSL https://raw.githubusercontent.com/nicholastmosher/dotfiles/master/install.sh)'"
