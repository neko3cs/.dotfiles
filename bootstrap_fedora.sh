#!/usr/bin/env bash
set -e

SCRIPT_ROOT="$(cd "$(dirname "$0")" && pwd)"

activate_fedora() {
  # 日本語ロケールのインストール
  sudo dnf install -y langpacks-ja glibc-langpack-ja
  # ロケールの設定
  if command -v localectl > /dev/null; then
    sudo localectl set-locale LANG=ja_JP.UTF-8
  else
    export LANG=ja_JP.UTF-8
  fi
  # タイムゾーンの設定
  if command -v timedatectl > /dev/null; then
    sudo timedatectl set-timezone Asia/Tokyo
  else
    sudo ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
  fi
  # 日本語マニュアル
  sudo dnf install -y man-pages-ja
  # /usr/localの所有者を現在のユーザーに変更
  sudo chown -R $(whoami) /usr/local
}
add_dnf_repositories() {
  # Microsoft Repository
  curl -sSL -O https://packages.microsoft.com/config/rhel/9/packages-microsoft-prod.rpm
  sudo rpm -i packages-microsoft-prod.rpm
  rm packages-microsoft-prod.rpm
  # zsh-completions Repository
  sudo dnf copr enable -y clarlok/zsh-users
  # lazygit Repository
  sudo dnf copr enable -y dejan/lazygit
  # HashiCorp Repository
  sudo dnf install -y dnf-plugins-core
  sudo dnf config-manager addrepo --from-repofile=https://rpm.releases.hashicorp.com/fedora/hashicorp.repo
}
install_aws_cli() {
  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "$SCRIPT_ROOT/awscliv2.zip"
  unzip $SCRIPT_ROOT/awscliv2.zip
  sudo $SCRIPT_ROOT/aws/install
  sudo rm -rf $SCRIPT_ROOT/awscliv2.zip $SCRIPT_ROOT/aws
}
install_docker() {
  sudo dnf remove -y docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate \
                    docker-logrotate docker-selinux docker-engine-selinux docker-engine
  sudo dnf config-manager addrepo --from-repofile https://download.docker.com/linux/fedora/docker-ce.repo
  sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
  sudo usermod -aG docker $USER
  sudo systemctl enable --now docker
}
install_pyenv() {
  sudo dnf install -y make gcc patch zlib-devel bzip2-devel readline-devel sqlite-devel \
                      openssl-devel tk-devel libffi-devel xz-devel libnsl2-devel
  curl https://pyenv.run | bash
}
install_starship() {
  sudo curl -sS https://starship.rs/install.sh | sh -s -- --yes
}
install_gcm() {
  if [[ -n "$WSL_DISTRO_NAME" ]]; then
    # WSL には dbus/keyring が無く secretservice が使えないため、
    # Windows 側の Git (Git.Git winget パッケージ) に同梱された GCM に interop 経由で委譲する。
    # .gitconfig の `helper = manager` が PATH 上のこのラッパーを `git-credential-manager` として解決する。
    mkdir -p "$HOME/.local/bin"
    cat > "$HOME/.local/bin/git-credential-manager" <<'EOF'
#!/usr/bin/env bash
exec "/mnt/c/Program Files/Git/mingw64/bin/git-credential-manager.exe" "$@"
EOF
    chmod +x "$HOME/.local/bin/git-credential-manager"
  else
    # ネイティブ Fedora: 公式 RPM が無いため .NET tool として導入する
    sudo dnf install -y libsecret
    dotnet tool install --global git-credential-manager
    git-credential-manager configure
    # Linux は認証情報の保存先を明示指定する必要がある(macOS/Windows は既定のストアを使う)
    git config --file "$HOME/.gitconfig.local" credential.credentialStore secretservice
  fi
}

sudo dnf update -y

activate_fedora
add_dnf_repositories
sudo dnf clean all
sudo dnf makecache -y
sudo dnf upgrade -y
sudo dnf install -y $(cat dnf-packages.txt)
zsh $SCRIPT_ROOT/set_dotfiles.sh
install_aws_cli
install_docker
install_pyenv
install_starship
install_gcm
zsh $SCRIPT_ROOT/set_completions.sh
/usr/bin/pwsh -File $SCRIPT_ROOT/Set-Completions.ps1

sudo dnf autoremove -y
sudo dnf clean all
