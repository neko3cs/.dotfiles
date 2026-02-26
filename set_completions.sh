#!/usr/bin/env zsh

completion_dir="$HOME/.zsh/completion"
mkdir -p "$completion_dir"

if command -v docker-compose >/dev/null 2>&1; then
  curl -fsSL \
    "https://raw.githubusercontent.com/docker/compose/$(docker-compose version --short)/contrib/completion/zsh/_docker-compose" \
    -o "$completion_dir/_docker-compose"
fi
command -v deno >/dev/null 2>&1 \
  && deno completions zsh > "$completion_dir/_deno"
command -v dotnet >/dev/null 2>&1 \
  && dotnet completions script zsh > "$completion_dir/_dotnet"
command -v minikube >/dev/null 2>&1 \
  && minikube completion zsh > "$completion_dir/_minikube"
command -v pip >/dev/null 2>&1 \
  && pip completion --zsh > "$completion_dir/_pip"
command -v starship >/dev/null 2>&1 \
  && starship completions zsh > "$completion_dir/_starship"
command -v sqlcmd >/dev/null 2>&1 \
  && sqlcmd completion zsh > "$completion_dir/_sqlcmd"
