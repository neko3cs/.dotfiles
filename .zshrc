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
export NVM_DIR="$HOME/.nvm"
if $IS_MACOS; then
  export PNPM_HOME="$HOME/Library/pnpm"
else
  export PNPM_HOME="/usr/local/share/pnpm"
fi
export STARSHIP_CONFIG=$HOME/.starship/starship.toml
export STARSHIP_CACHE=$HOME/.starship/cache
if command -v tesseract >/dev/null 2>&1; then
  export TESSDATA_PREFIX="$(brew --prefix tesseract 2>/dev/null)/share/tessdata"
fi
export UUID_PATTERN='[0-9A-F]{8}-[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{12}'
export ZSH_CACHE_DIR="$HOME/.zsh/cache"
export ZSH_COMPDUMP="$HOME/.zsh/.zcompdump"
[[ -d "$ZSH_CACHE_DIR" ]] || mkdir -p "$ZSH_CACHE_DIR"

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
add_to_path $HOME/.local/bin
add_to_path $HOMEBREW_PREFIX/opt/llvm/bin
add_to_path $JAVA_HOME/bin
add_to_path $PNPM_HOME

# INITIALIZATION
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi
if [[ -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
  source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
  autoload -Uz _zinit
  (( ${+_comps} )) && _comps[zinit]=_zinit
fi
if [[ -r "${HOMEBREW_PREFIX:-}/opt/nvm/nvm.sh" ]]; then
  source "$HOMEBREW_PREFIX/opt/nvm/nvm.sh"
  [[ -r "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm" ]] && source "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm"
fi
if (( $+commands[rbenv] )); then
  eval "$(rbenv init -)"
fi
if (( $+commands[starship] )); then
  eval "$(starship init zsh)"
fi

# PLUGIN
zinit ice wait'0' lucid as"completion"
zinit light zsh-users/zsh-completions
zinit ice wait'0' lucid atload"_zsh_autosuggest_start"
zinit light zsh-users/zsh-autosuggestions
zinit ice wait'0' lucid
zinit light zsh-users/zsh-syntax-highlighting
zinit ice lucid
zinit light momo-lab/zsh-abbrev-alias

# COMPLETIONS
fpath=($HOME/.zsh/completion $fpath)
autoload -Uz compinit
compinit -C -d "$ZSH_COMPDUMP" -i
autoload -Uz bashcompinit && bashcompinit
autoload -Uz zmv
zinit cdreplay -q
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$ZSH_CACHE_DIR"

if (( $+commands[aws] )); then
  aws_comp_path=$(command -v aws_completer)
  [[ -n "$aws_comp_path" ]] && complete -C "$aws_comp_path" aws
fi

if [[ -n "$HOMEBREW_PREFIX" && -r "$HOMEBREW_PREFIX/etc/bash_completion.d/az" ]]; then
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
if (( $+functions[abbrev-alias] )); then
  abbrev-alias la='ls -ah'
  abbrev-alias ll='ls -lh'
  abbrev-alias lla='ls -lah'
  abbrev-alias cls='clear'
  abbrev-alias lg='lazygit'
  $IS_MACOS && abbrev-alias chrome='open -a "Google Chrome"'
  $IS_WSL && abbrev-alias pbcopy='clip.exe'
fi
