#!/usr/bin/env bash

if [ "$PS1" ]; then
    if [ -x "/home/linuxbrew/.linuxbrew/bin/zsh" ]; then
        export SHELL=/home/linuxbrew/.linuxbrew/bin/zsh
        exec $SHELL -l
    fi
fi
