# ---------------------------
#       neko3cs .zshrc
# ---------------------------

# HOMEBREW SETUP
if [[ -f /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -f /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# ENVIRONMENT VALUES
export ANDROID_HOME=$HOME/Library/Android/sdk
export ANDROID_SDK_ROOT=$ANDROID_HOME
export CARGO_HOME="$HOME/.cargo"
export DOTNET_ROOT=$HOME/.dotnet
export GOPATH="$HOME/gopath"
export JAVA_HOME=$(/usr/libexec/java_home -v 17)
export JSII_SILENCE_WARNING_UNTESTED_NODE_VERSION=true
export NODE_EXTRA_CA_CERTS="/usr/local/share/ca-certificates/cacert.pem"
export PNPM_HOME="$HOME/Library/pnpm"
export PYENV_ROOT="$HOME/.pyenv"
export STARSHIP_CONFIG=$HOME/.starship/starship.toml
export STARSHIP_CACHE=$HOME/.starship/cache
export TESSDATA_PREFIX='/usr/local/Cellar/tesseract/5.3.4_1/share/tessdata/'

# PATH CONFIGURATION
typeset -U path cdpath fpath manpath
path=(
  $ANDROID_HOME/emulator
  $ANDROID_HOME/platform-tools
  $ANDROID_HOME/cmdline-tools/latest/bin
  $ANDROID_HOME/tools
  $ANDROID_HOME/tools/bin
  $CARGO_HOME/bin
  $DOTNET_ROOT/tools
  $GOPATH/bin
  $JAVA_HOME/bin
  $PNPM_HOME
  $PYENV_ROOT/bin
  $path
)

# CPPFLAGS
export CPPFLAGS="-I$JAVA_HOME/include"

# TOOL INITIALIZATION
# Ruby (rbenv)
if (( $+commands[rbenv] )); then
  eval "$(rbenv init -)"
fi

# Python (pyenv)
if (( $+commands[pyenv] )); then
  eval "$(pyenv init -)"
fi

# ZSH OPTIONS & COMPLETIONS
if [[ -n "$HOMEBREW_PREFIX" ]]; then
  fpath=($HOMEBREW_PREFIX/share/zsh-completions $fpath)
fi

autoload -Uz compinit && compinit -i
autoload -Uz bashcompinit && bashcompinit
autoload -Uz zmv

setopt correct
setopt list_packed
setopt nonomatch
setopt auto_param_slash

# STARSHIP INIT
if (( $+commands[starship] )); then
  eval "$(starship init zsh)"
  [[ -f $HOME/.dotfiles/starship.zsh ]] && source $HOME/.dotfiles/starship.zsh
fi

# TOOL SPECIFIC COMPLETIONS
## AZURE_CLI
if [[ -n "$HOMEBREW_PREFIX" && -f "$HOMEBREW_PREFIX/etc/bash_completion.d/az" ]]; then
  source "$HOMEBREW_PREFIX/etc/bash_completion.d/az"
fi

## DOTNET_CLI
if (( $+commands[dotnet] )); then
  _dotnet_zsh_complete() {
    local completions=("$(dotnet complete "$words")")
    if [ -z "$completions" ]; then
      _arguments '*::arguments: _normal'
      return
    fi
    _values = "${(ps:\n:)completions}"
  }
  compdef _dotnet_zsh_complete dotnet
fi

## PIP
__pip() {
  compadd $( COMP_WORDS="$words[*]" \
             COMP_CWORD=$((CURRENT-1)) \
             PIP_AUTO_COMPLETE=1 $words[1] 2>/dev/null )
}
compdef __pip -P 'pip[0-9.]#'

## AWS_CLI
if (( $+commands[aws] )); then
  # Prefer searching for aws_completer if not at fixed path
  local aws_comp_path=$(command -v aws_completer)
  [[ -n "$aws_comp_path" ]] && complete -C "$aws_comp_path" aws
fi

## zsh-autosuggestions
if [[ -n "$HOMEBREW_PREFIX" ]]; then
  local autosuggest="$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
  [[ -f "$autosuggest" ]] && source "$autosuggest"
fi

# ALIASES
alias la='ls -ah'
alias ll='ls -lh'
alias lla='ls -lah'
alias cls='clear'
alias lg='lazygit'
alias chrome='open -a "Google Chrome"'

if [[ "$(uname -s)" == "Linux" ]]; then
  alias pbcopy='clip.exe'
fi

# UTILS
export UUID_PATTERN='[0-9A-F]{8}-[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{12}'
