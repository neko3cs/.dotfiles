#
# neko3cs's .zshrc
#

# zsh options
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

  autoload -Uz compinit
  compinit
fi
typeset -U path cdpath fpath manpath &&
  autoload -Uz compinit &&
  compinit -i &&
  autoload -Uz colors &&
  colors &&
  RPROMPT='%F{magenta}%D{%Y/%m/%d} %*%f' &&
  PROMPT='
%F{blue}┌ %n@%m%f%F{cyan} %C%f
%F{blue}└ $ %f'

# complement options
setopt correct &&
  setopt list_packed &&
  setopt auto_param_slash &&
  setopt auto_param_slash &&
  setopt nonomatch

# alias
alias la='ls -a'
alias ll='ls -l'
alias lla='ls -la'
alias cls='clear'
alias chrome='open -a "Google Chrome"'
alias visualstudio='open -a "Visual Studio"'

if [ "$(uname -s)" = "Linux" ]; then
  alias pbcopy='clip.exe'
fi
