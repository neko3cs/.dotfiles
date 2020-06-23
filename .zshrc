#!/bin/zsh
# complement options
setopt correct
setopt list_packed
setopt auto_param_slash
setopt auto_param_slash
setopt nonomatch

# zsh options
typeset -U path cdpath fpath manpath
autoload -U compinit
compinit
autoload -Uz colors
colors
PROMPT='%F{green}%m@%n%f %F{cyan}%~%f$ '

# alias
alias la='ls -a'
alias ll='ls -l'
alias lla='ls -la'
alias cls='clear'
alias chrome='open -a "Google Chrome"'
alias visualstudio='open -a "Visual Studio"'
