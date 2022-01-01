#!/bin/sh
pushd ~/.dotfiles/nix
sudo nixos-rebuild switch --flake .#
popd
