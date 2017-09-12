#!/bin/bash

[[ -x "$(command -v git)" ]] || exit 1
[[ -x "$(command -v vim)" ]] || exit 1
[[ -x "$(command -v zsh)" ]] || exit 1
[[ -x "$(command -v rg)"  ]] || exit 1

exit 0
