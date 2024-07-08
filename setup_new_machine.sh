#!/bin/bash

# Homebrew'ü kurar
if ! command -v brew &> /dev/null
then
  echo "Homebrew yükleniyor..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Gerekli paketleri yükler
echo "Gerekli paketler yükleniyor..."
brew install git node npm jq

# Brewfile'daki paketleri yükler
echo "Homebrew paketleri yükleniyor..."
brew bundle --file=./configs/Brewfile

# applications_list.txt dosyasındaki uygulamaları yükler
echo "Uygulamalar kuruluyor..."
while IFS= read -r application
do
  brew install --cask "$application"
done < ./configs/applications_list.txt

# Yapılandırma dosyalarını geri yükler
echo "Yapılandırma dosyaları geri yükleniyor..."
./configs/backup_all.sh

# GitLab projelerinin zaten klonlanıp klonlanmadığını kontrol eder ve gerekirse klonlar
PROJECTS_DIR="$HOME/Desktop/Projects"
if [ ! -d "$PROJECTS_DIR" ] || [ -z "$(ls -A $PROJECTS_DIR)" ]; then
  echo "GitLab projeleri klonlanıyor..."
  ./configs/clone_gitlab_projects.sh
else
  echo "GitLab projeleri zaten klonlanmış, atlanıyor."
fi

echo "Kurulum tamamlandı!"
