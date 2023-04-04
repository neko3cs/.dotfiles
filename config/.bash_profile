#!/usr/bin/env bash

# wsl2でchsh出来ないのでbashから無理やりzshをデフォルトシェルにする
if [ "$PS1" ]; then
    if [ -x "/home/linuxbrew/.linuxbrew/bin/zsh" ]; then
        export SHELL=/home/linuxbrew/.linuxbrew/bin/zsh
        exec $SHELL -l
    fi
fi
