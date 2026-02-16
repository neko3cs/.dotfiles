#!/bin/bash

# General: 外観モードを「自動」に設定
defaults write NSGlobalDomain AppleInterfaceStyleSwitchesAutomatically -bool true
# General: 全ての拡張子を表示
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
# General: フルキーボードアクセスを有効化 (Tabキーですべてのコントロールを選択可能に)
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3
# General: 自動入力（大文字化）を無効化
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
# General: スマートダッシュ（ダッシュの自動置換）を無効化
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
# General: ピリオドの自動置換を無効化
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
# General: スマートクオート（引用符の自動置換）を無効化
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
# General: スペルの自動修正を無効化
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# Finder: フォルダを常に先頭に表示
defaults write com.apple.finder _FXSortFoldersFirst -bool true
# Finder: デスクトップでもフォルダを常に先頭に表示
defaults write com.apple.finder _FXSortFoldersFirstOnDesktop -bool true
# Finder: 検索時にデフォルトで現在のフォルダを検索
defaults write com.apple.finder FXDefaultSearchScope -string "SCev"
# Finder: 30日後にゴミ箱を空にする
defaults write com.apple.finder FXRemoveOldTrashItems -bool true
# Finder: ファイルの拡張子変更時の警告を無効化
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Dock: 自動的に隠す
defaults write com.apple.dock autohide -bool true
# Dock: 最近使ったアプリケーションを表示しない
defaults write com.apple.dock show-recents -bool false
# Dock: ウィンドウをアプリケーションアイコンに最小化
defaults write com.apple.dock minimize-to-application -bool true
# Dock: アイコンサイズを設定
defaults write com.apple.dock tilesize -int 66

# Trackpad: タップでクリックを有効化
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
# Trackpad: Bluetoothトラックパッドでもタップでクリックを有効化
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
# Trackpad: マウスのタップ挙動を設定
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
# Trackpad: システム全体でタップでクリックを有効化
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
# Trackpad: 3本指でのドラッグを有効化
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true
# Trackpad: Bluetoothトラックパッドでも3本指ドラッグを有効化
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -bool true

# Desktop Services: ネットワークドライブで .DS_Store を作成しない
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
# Desktop Services: USBドライブで .DS_Store を作成しない
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

echo "Done. Please restart."
