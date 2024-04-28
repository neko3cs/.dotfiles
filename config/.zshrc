# ---------------------------
#       neko3cs .zshrc
# ---------------------------
# PATH
export PATH="$PATH:/usr/local/bin"
export PATH="$PATH:/usr/local/sbin"
export PATH="$PATH:/usr/local/Cellar"
export PATH="$PATH:$HOME/.dotnet/tools"
export GOPATH="$HOME/gopath"
export PATH="$PATH:$HOME/go/bin:$GOPATH/bin"
export CARGO_HOME="$HOME/.cargo"
export PATH="$PATH:$CARGO_HOME/bin"
export PATH="$PATH:/usr/local/opt/openjdk/bin"
export PATH="$PATH:/usr/local/opt/qt/bin"
export CPPFLAGS="-I/usr/local/opt/openjdk/include"
export PATH="$PATH:$JAVA_HOME/bin"
type rbenv >/dev/null 2>&1 && {
  eval "$(rbenv init -)"
}
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PATH:$PYENV_ROOT/bin"
type pyenv >/dev/null 2>&1 && {
  eval "$(pyenv init --path)"
}
export STARSHIP_CONFIG=$HOME/.starship/starship.toml
export STARSHIP_CACHE=$HOME/.starship/cache
export TESSDATA_PREFIX='/usr/local/Cellar/tesseract/5.3.4_1/share/tessdata/'
# ZSH OPTIONS
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
fi
typeset -U path cdpath fpath manpath
autoload -Uz compinit && compinit -i
autoload bashcompinit && bashcompinit
setopt correct
setopt list_packed
setopt nonomatch
setopt auto_param_slash
# STARSHIP INIT
eval "$(starship init zsh)"
source $HOME/.dotfiles/config/starship.zsh
# COMPLETIONS
## AZURE_CLI
if type brew &>/dev/null; then
  source $(brew --prefix)/etc/bash_completion.d/az
fi
## DOTNET_CLI
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
alias la='ls -ah'
alias ll='ls -lh'
alias lla='ls -lah'
alias cls='clear'
alias lg='lazygit'
alias chrome='open -a "Google Chrome"'
if [ "$(uname -s)" = "Linux" ]; then
  alias pbcopy='clip.exe'
fi
# SPECIFIC VARIABLE
UUID_PATTERN='[0-9A-F]{8}-[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{12}'
