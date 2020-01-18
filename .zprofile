#!/bin/zsh

export PATH=/usr/local/bin:$PATH
export PATH=/usr/local/sbin:$PATH
export GOPATH=$HOME/gopath
export PATH=$PATH:$HOME/go/bin:$GOPATH/bin
export PATH=$PYENV_ROOT/bin:$PATH
export PYENV_ROOT=$HOME/.pyenv
export PATH=$PATH:/Users/neko3cs/.dotnet/tools
export JAVA_HOME=`/usr/libexec/java_home -v "13"`
export PATH=$JAVA_HOME/bin:$PATH

type rbenv >/dev/null 2>&1 || {
  eval "$(rbenv init -)"
}
type pyenv >/dev/null 2>&1 || {
  eval "$(pyenv init -)"
}

