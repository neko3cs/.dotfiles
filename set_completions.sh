#!/usr/bin/env zsh

COMPLETIONS_DIR="$HOME/.zsh/completion"
mkdir -p "$COMPLETIONS_DIR"

if command -v deno >/dev/null 2>&1; then
  deno completions zsh > "$COMPLETIONS_DIR/_deno"
fi
if command -v docker >/dev/null 2>&1; then
  docker completion zsh > "$COMPLETIONS_DIR/_docker"
fi
if command -v dotnet >/dev/null 2>&1; then
  dotnet completions script zsh > "$COMPLETIONS_DIR/_dotnet"
fi
if command -v gh >/dev/null 2>&1; then
  gh completion -s zsh > "$COMPLETIONS_DIR/_gh"
fi
if command -v minikube >/dev/null 2>&1; then
  minikube completion zsh > "$COMPLETIONS_DIR/_minikube"
fi
if command -v pip >/dev/null 2>&1; then
  pip completion --zsh > "$COMPLETIONS_DIR/_pip"
fi
if command -v starship >/dev/null 2>&1; then
  starship completions zsh > "$COMPLETIONS_DIR/_starship"
fi
if command -v sqlcmd >/dev/null 2>&1; then
  sqlcmd completion zsh > "$COMPLETIONS_DIR/_sqlcmd"
fi
