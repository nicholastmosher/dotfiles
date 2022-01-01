#!/bin/sh
pushd ~/.dotfiles/nix
nix build .#homeManagerConfigurations.nick.activationPackage
sudo ./result/activate
popd
