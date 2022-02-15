#!/bin/sh

USER=${1?' Usage: ./apply-user USERNAME'}

pushd ~/.dotfiles/nix
nix build ".#homeManagerConfigurations.${USER}.activationPackage"
./result/activate
popd
