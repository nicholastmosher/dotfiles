#!/bin/sh

# Apply current user's config, or use first arg as username
#
# Examples:
# nick@thinkpad $ ./apply-user.sh          # Applies config for 'nick'
# nick@thinkpad $ ./apply-user.sh nmosher  # Applies config for 'nmosher'
USER=${1:-${USER}}

# Use subshell to change directories temporarily
(cd ~/.dotfiles/nix; \
    nix build ".#homeManagerConfigurations.${USER}.activationPackage"; \
    ./result/activate)
