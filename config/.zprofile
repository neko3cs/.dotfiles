#
# neko3cs's .zprofile
#

## common
export PATH="/usr/local/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"
## c++ qt
export PATH="/usr/local/opt/qt/bin:$PATH"
## rust
export CARGO_HOME="$HOME/.cargo"
export PATH="$CARGO_HOME/bin:$PATH"
## golang
export GOPATH="$HOME/gopath"
export PATH="$PATH:$HOME/go/bin:$GOPATH/bin"
## dotnet
export PATH="$PATH:$HOME/.dotnet/tools"
## java
export JAVA_HOME="/usr/libexec/java_home"
export PATH="$JAVA_HOME/bin:$PATH"
## ruby
type rbenv >/dev/null 2>&1 && {
  eval "$(rbenv init -)"
}
# python
type pyenv >/dev/null 2>&1 && {
  export PYENV_ROOT="$HOME/.pyenv"
  [[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init --path)"
}
