#!/bin/bash

# Homebrew'ü kurar
if ! command -v brew &> /dev/null; then
  echo "Homebrew yükleniyor..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "Homebrew zaten kurulu, atlanıyor."
fi

# Gerekli paketleri yükler
REQUIRED_PACKAGES=("git" "node" "npm" "jq")
for pkg in "${REQUIRED_PACKAGES[@]}"; do
  if ! brew list -1 | grep -q "^${pkg}\$"; then
    echo "$pkg yükleniyor..."
    brew install "$pkg"
  else
    echo "$pkg zaten kurulu, atlanıyor."
  fi
done

# Brewfile'daki paketleri yükler
if [ -f ./configs/Brewfile ]; then
  echo "Homebrew paketleri yükleniyor..."
  brew bundle --file=./configs/Brewfile
else
  echo "./configs/Brewfile bulunamadı, atlanıyor."
fi

# applications_list.txt dosyasındaki uygulamaları yükler
if [ -f ./configs/applications_list.txt ]; then
  echo "Uygulamalar kuruluyor..."
  while IFS= read -r application; do
    if ! brew list --cask -1 | grep -q "^${application}\$"; then
      echo "$application yükleniyor..."
      brew install --cask "$application"
    else
      echo "$application zaten kurulu, atlanıyor."
    fi
  done < ./configs/applications_list.txt
else
  echo "./configs/applications_list.txt bulunamadı, atlanıyor."
fi

# Yapılandırma dosyalarını geri yükler
if [ ! -f "$HOME/.zshrc" ] || [ ! -f "$HOME/.gitconfig" ]; then
  echo "Yapılandırma dosyaları geri yükleniyor..."
  ./configs/backup_all.sh
else
  echo "Yapılandırma dosyaları zaten mevcut, atlanıyor."
fi

# GitLab projelerinin zaten klonlanıp klonlanmadığını kontrol eder ve gerekirse klonlar
PROJECTS_DIR="$HOME/Desktop/Projects"
if [ ! -d "$PROJECTS_DIR" ] || [ -z "$(ls -A "$PROJECTS_DIR")" ]; then
  echo "GitLab projeleri klonlanıyor..."
  ./configs/clone_gitlab_projects.sh
else
  echo "GitLab projeleri zaten klonlanmış, atlanıyor."
fi

echo "Kurulum tamamlandı!"
