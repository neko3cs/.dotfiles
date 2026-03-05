#!/usr/bin/env zsh

completion_dir="$HOME/.zsh/completion"
mkdir -p "$completion_dir"

if command -v docker-compose >/dev/null 2>&1; then
  curl -fsSL \
    "https://raw.githubusercontent.com/docker/compose/$(docker-compose version --short)/contrib/completion/zsh/_docker-compose" \
    -o "$completion_dir/_docker-compose"
fi
if command -v deno >/dev/null 2>&1; then
  deno completions zsh > "$completion_dir/_deno"
fi
if command -v dotnet >/dev/null 2>&1; then
  dotnet completions script zsh > "$completion_dir/_dotnet"
fi
if command -v gh >/dev/null 2>&1; then
  gh completion -s zsh > "$completion_dir/_gh"
fi
if command -v minikube >/dev/null 2>&1; then
  minikube completion zsh > "$completion_dir/_minikube"
fi
if command -v pip >/dev/null 2>&1; then
  pip completion --zsh > "$completion_dir/_pip"
fi
if command -v starship >/dev/null 2>&1; then
  starship completions zsh > "$completion_dir/_starship"
fi
if command -v sqlcmd >/dev/null 2>&1; then
  sqlcmd completion zsh > "$completion_dir/_sqlcmd"
fi
