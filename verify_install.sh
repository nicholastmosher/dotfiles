#!/bin/bash

set -x

[[ -x "$(command -v git)" ]] || exit 1
echo "GIT"
echo $(which git)
[[ -x "$(command -v vim)" ]] || exit 1
echo "VIM"
echo $(which vim)
[[ -x "$(command -v zsh)" ]] || exit 1
echo "ZSH"
echo $(which zsh)
[[ -x "$(command -v rg)"  ]] || exit 1
echo "RG"
echo $(which rg)

set +x

exit 0
