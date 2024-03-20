#
# neko3cs .zshrc
#

# PATH
export PATH="/usr/local/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"
export PATH="/usr/local/opt/qt/bin:$PATH"
export CARGO_HOME="$HOME/.cargo"
export PATH="$CARGO_HOME/bin:$PATH"
export GOPATH="$HOME/gopath"
export PATH="$PATH:$HOME/go/bin:$GOPATH/bin"
export PATH="$PATH:$HOME/.dotnet/tools"
export PATH="/usr/local/opt/openjdk/bin:$PATH"
export CPPFLAGS="-I/usr/local/opt/openjdk/include"
export PATH="$JAVA_HOME/bin:$PATH"
type rbenv >/dev/null 2>&1 && {
  eval "$(rbenv init -)"
}
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
type pyenv >/dev/null 2>&1 && {
  eval "$(pyenv init --path)"
}

# ZSH OPTIONS
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
PROMPT='
%F{cyan}┌ %n@%m%f%F{081} %C%f
%F{cyan}└ $ %f' &&
RPROMPT='%F{green}%D{%Y/%m/%d} %*%f' &&
setopt correct &&
setopt list_packed &&
setopt auto_param_slash &&
setopt auto_param_slash &&
setopt nonomatch

# DOTNET COMPLETION
_dotnet_zsh_complete()
{
  local completions=("$(dotnet complete "$words")")
  if [ -z "$completions" ]
  then
    _arguments '*::arguments: _normal'
    return
  fi
  _values = "${(ps:\n:)completions}"
}
compdef _dotnet_zsh_complete dotnet

# ALIAS
alias la='ls -a'
alias ll='ls -l'
alias lla='ls -la'
alias cls='clear'
alias chrome='open -a "Google Chrome"'
if [ "$(uname -s)" = "Linux" ]; then
  alias pbcopy='clip.exe'
fi
