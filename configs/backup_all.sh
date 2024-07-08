#!/bin/bash

# Yedekleme dizinini oluştur
mkdir -p ~/backup/configs

# Zsh ve Git yapılandırma dosyaları
cp ~/.zshrc ~/backup/configs
cp ~/.gitconfig ~/backup/configs
cp ~/.zprofile ~/backup/configs

# VSCode ayarları ve uzantılar
VSCODE_SETTINGS_DIR="$HOME/Library/Application Support/Code/User"
BACKUP_DIR="$HOME/backup/configs"

# Eski VSCode yedeklerini sil
if [ -f "$BACKUP_DIR/settings.json" ]; then
  rm "$BACKUP_DIR/settings.json"
fi
if [ -f "$BACKUP_DIR/keybindings.json" ]; then
  rm "$BACKUP_DIR/keybindings.json"
fi
if [ -d "$BACKUP_DIR/snippets" ]; then
  rm -r "$BACKUP_DIR/snippets"
fi
if [ -f "$BACKUP_DIR/vscode_extensions_list.txt" ]; then
  rm "$BACKUP_DIR/vscode_extensions_list.txt"
fi

# Yeni VSCode yedeklerini oluştur
echo "VSCode ayarları ve uzantıları yedekleniyor..."
cp "$VSCODE_SETTINGS_DIR/settings.json" "$BACKUP_DIR"
cp "$VSCODE_SETTINGS_DIR/keybindings.json" "$BACKUP_DIR"
cp -r "$VSCODE_SETTINGS_DIR/snippets" "$BACKUP_DIR"
code --list-extensions > "$BACKUP_DIR/vscode_extensions_list.txt"
echo "VSCode ayarları ve uzantıları yedeklendi."

# SSH Anahtarları
cp -r ~/.ssh ~/backup/configs

# Diğer yapılandırma dosyaları (varsa)
cp ~/.npmrc ~/backup/configs
cp ~/.yarnrc ~/backup/configs

# Uygulama listesi (doğru isimlerle)
APPLICATIONS_FILE="$BACKUP_DIR/applications_list.txt"

# Eski dosyayı sil
if [ -f "$APPLICATIONS_FILE" ]; then
  rm "$APPLICATIONS_FILE"
fi

# Boş bir dosya oluştur
touch "$APPLICATIONS_FILE"

# Uygulamaları bul ve listeye yaz
echo "Yüklü uygulamalar listeleniyor..."
for app in /Applications/*.app; do
  app_name=$(basename "$app" .app | tr ' ' '-' | tr '[:upper:]' '[:lower:]')
  if [ "$app_name" == "zoom.us" ]; then
    app_name="zoom"
  fi
  echo "$app_name" >> "$APPLICATIONS_FILE"
done

# Homebrew paketleri
brew tap homebrew/bundle
brew bundle dump --file="$BACKUP_DIR/Brewfile"

# Global npm paketleri
npm list -g --depth=0 > "$BACKUP_DIR/npm_global_list.txt"

echo "Yedekleme tamamlandı. Tüm dosyalar $BACKUP_DIR dizininde."
