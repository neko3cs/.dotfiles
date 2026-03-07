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

cd $HOME
if  [ ! -d $HOME/.dotfiles ]; then
  git clone https://github.com/neko3cs/.dotfiles.git
fi
cd .dotfiles

sudo dnf update -y

activate_fedora
. $SCRIPT_ROOT/install_dnf-packages.sh
. $SCRIPT_ROOT/set_dotfiles.sh
install_aws_cli
install_docker
install_pyenv
install_starship
. $SCRIPT_ROOT/set_completions.sh
/usr/bin/pwsh -File $SCRIPT_ROOT/Set-Completions.ps1

sudo dnf autoremove -y
sudo dnf clean all
