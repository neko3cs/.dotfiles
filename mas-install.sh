#!/bin/bash

type mas >/dev/null 2>&1 || {
  echo "mas-cli not installed!"
  echo "please install mas-cli from brew"
  exit
}

apps=(
    803453959     # Slack (4.0.1)
    405399194     # Kindle (1.28.0)
    409183694     # Keynote (10.0)
    425424353     # The Unarchiver (4.2.2)
    1444383602    # GoodNotes (5.4.30)
    441258766     # Magnet (2.4.5)
    409201541     # Pages (10.0)
    1295203466    # Microsoft Remote Desktop (10.3.12)
    1496833156    # Playgrounds (3.3)
    409203825     # Numbers (10.0)
    1208561404    # カスペルスキー セキュアコネクション (2.5.0)
    1333542190    # 1Password 7 (7.5)
)

# HACK: mas-cli not support signin on catalina
# while true
# do
#     read -p "Apple ID: " apple_id
#     if [ ! -z "$apple_id" ]; then
#         break
#     fi
# done
# mas signin $apple_id

for app in "${apps[@]}"; do
    mas install $apps || mas upgrade $apps
done
