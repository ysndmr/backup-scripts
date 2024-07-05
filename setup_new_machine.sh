#!/bin/bash

echo "Homebrew kuruluyor..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

echo "Git kuruluyor..."
brew install git

echo "Node.js ve npm kuruluyor..."
brew install node

echo "jq kuruluyor..."
brew install jq

echo "Homebrew paketleri yükleniyor..."
brew bundle --file=~/backup/Brewfile

echo "Uygulamalar kuruluyor..."
while read -r application; do
    brew install --cask "$application"
done < ~/backup/applications_list.txt

echo "Yedek dosyaları GitHub'dan klonlanıyor..."
git clone https://github.com/ysndmr/backup-scripts.git ~/backup
cd ~/backup

echo "Yapılandırma dosyaları geri yükleniyor..."
chmod +x configs/backup_all.sh
./configs/backup_all.sh

echo "GitLab projeleri klonlanıyor..."
chmod +x configs/clone_gitlab_projects.sh
./configs/clone_gitlab_projects.sh

echo "Kurulum tamamlandı!"

