#!/bin/zsh
# complement options
setopt correct
setopt list_packed
setopt auto_param_slash
setopt auto_param_slash

# zsh options
typeset -U path cdpath fpath manpath
autoload -U compinit
compinit

# alias
alias la='ls -a'
alias ll='ls -l'
alias lla='ls -la'
alias cls='clear'
alias boost='-I/opt/local/include'
alias chrome='open -a "Google Chrome"'
