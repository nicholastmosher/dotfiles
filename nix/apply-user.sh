#!/bin/sh
pushd ~/.dotfiles/nix
nix build .#homeManagerConfigurations.nick.activationPackage
./result/activate
popd
