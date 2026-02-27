# PLATFORM DETECTION
IS_MACOS=false
[[ "$OSTYPE" == darwin* ]] && IS_MACOS=true
IS_WSL=false
[[ -n "$WSL_DISTRO_NAME" ]] && IS_WSL=true

# HOMEBREW SETUP
if $IS_MACOS; then
  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
fi

# ENVIRONMENT VALUES
$IS_MACOS && export ANDROID_HOME=$HOME/Library/Android/sdk
$IS_MACOS && export ANDROID_SDK_ROOT=$ANDROID_HOME
export CARGO_HOME="$HOME/.cargo"
export DOTNET_ROOT="/usr/local/share/dotnet"
export GOPATH="$HOME/gopath"
$IS_MACOS && export JAVA_HOME=$(/usr/libexec/java_home -v 17)
export JSII_SILENCE_WARNING_UNTESTED_NODE_VERSION=true
export NODE_EXTRA_CA_CERTS="/usr/local/share/ca-certificates/cacert.pem"
if $IS_MACOS; then
  export PNPM_HOME="$HOME/Library/pnpm"
else
  export PNPM_HOME="/usr/local/share/pnpm"
fi
export PYENV_ROOT="$HOME/.pyenv"
export STARSHIP_CONFIG=$HOME/.starship/starship.toml
export STARSHIP_CACHE=$HOME/.starship/cache
if command -v tesseract >/dev/null 2>&1; then
  export TESSDATA_PREFIX="$(brew --prefix tesseract 2>/dev/null)/share/tessdata"
fi
export UUID_PATTERN='[0-9A-F]{8}-[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{12}'

# PATH CONFIGURATION
typeset -U path cdpath fpath manpath
add_to_path() {
  [[ -d "$1" ]] && path=("$1" $path)
}
$IS_MACOS && add_to_path $ANDROID_HOME/emulator
$IS_MACOS && add_to_path $ANDROID_HOME/platform-tools
$IS_MACOS && add_to_path $ANDROID_HOME/cmdline-tools/latest/bin
$IS_MACOS && add_to_path $ANDROID_HOME/tools
$IS_MACOS && add_to_path $ANDROID_HOME/tools/bin
add_to_path $CARGO_HOME/bin
add_to_path $DOTNET_ROOT
add_to_path $GOPATH/bin
add_to_path $HOME/.dotnet/tools
add_to_path $JAVA_HOME/bin
add_to_path $PNPM_HOME
add_to_path $PYENV_ROOT/bin

# INITIALIZATION
if (( $+commands[rbenv] )); then
  eval "$(rbenv init -)"
fi
if (( $+commands[pyenv] )); then
  eval "$(pyenv init -)"
fi
if (( $+commands[starship] )); then
  eval "$(starship init zsh)"
fi
if [[ -n "$HOMEBREW_PREFIX" ]]; then
  local autosuggest="$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
  [[ -f "$autosuggest" ]] && source "$autosuggest"
fi

# COMPLETIONS
if [[ -n "$HOMEBREW_PREFIX" ]]; then
  fpath=($HOMEBREW_PREFIX/share/zsh-completions $fpath)
fi
autoload -Uz compinit && compinit -i
autoload -Uz bashcompinit && bashcompinit
autoload -Uz zmv
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache
if (( $+commands[aws] )); then
  local aws_comp_path=$(command -v aws_completer)
  [[ -n "$aws_comp_path" ]] && complete -C "$aws_comp_path" aws
fi
if [[ -n "$HOMEBREW_PREFIX" && -f "$HOMEBREW_PREFIX/etc/bash_completion.d/az" ]]; then
  source "$HOMEBREW_PREFIX/etc/bash_completion.d/az"
fi

# ZSH OPTIONS
HISTSIZE=10000
SAVEHIST=10000
setopt auto_param_slash
setopt correct
setopt hist_ignore_dups
setopt hist_reduce_blanks
setopt inc_append_history
setopt interactive_comments
setopt list_packed
setopt nomatch
setopt share_history

# ALIASES
alias la='ls -ah'
alias ll='ls -lh'
alias lla='ls -lah'
alias cls='clear'
alias lg='lazygit'
$IS_MACOS && alias chrome='open -a "Google Chrome"'
$IS_WSL && alias pbcopy='clip.exe'
alias gemini-add-conductor='gemini extensions install https://github.com/gemini-cli-extensions/conductor --consent'
