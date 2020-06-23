#!/bin/zsh

# run tmux when login
[[ -z "$TMUX" && ! -z "$PS1" ]] && tmux
