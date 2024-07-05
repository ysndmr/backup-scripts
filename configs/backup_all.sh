#!/bin/bash

# Yedekleme dizinini oluştur
mkdir -p ~/backup/configs

# Zsh ve Git yapılandırma dosyaları
cp ~/.zshrc ~/backup/configs
cp ~/.gitconfig ~/backup/configs
cp ~/.zprofile ~/backup/configs

# VSCode ayarları ve uzantılar
cp ~/Library/Application\ Support/Code/User/settings.json ~/backup/configs
cp ~/Library/Application\ Support/Code/User/keybindings.json ~/backup/configs
cp -r ~/Library/Application\ Support/Code/User/snippets ~/backup/configs
code --list-extensions > ~/backup/configs/vscode_extensions_list.txt

# SSH Anahtarları
cp -r ~/.ssh ~/backup/configs

# Diğer yapılandırma dosyaları (varsa)
cp ~/.npmrc ~/backup/configs
cp ~/.yarnrc ~/backup/configs

# Uygulama listesi
brew tap homebrew/bundle
brew bundle dump --file=~/backup/configs/Brewfile

# Global npm paketleri
npm list -g --depth=0 > ~/backup/configs/npm_global_list.txt

echo "Yedekleme tamamlandı. Tüm dosyalar ~/backup/configs dizininde."
