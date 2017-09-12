#!/bin/bash

# Verify that git is installed
[[ -x "$(command -v git)" ]] || exit 1

# Verify that vim is installed
[[ -x "$(command -v vim)" ]] || exit 1

# Verify that zsh is installed
[[ -x "$(command -v zsh)" ]] || exit 1

# Verify that ripgrep is installed
[[ -x "$(command -v rg)"  ]] || exit 1

exit 0
