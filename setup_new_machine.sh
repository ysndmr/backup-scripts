#!/bin/bash

# Parametre kontrolü
SKIP_GITLAB=false
SKIP_VSCODE=false
LIST_PROJECTS=false
SKIP_PROJECTS=""

while [[ "$#" -gt 0 ]]; do
    case $1 in
        --none) SKIP_GITLAB=true ;;
        --no-vscode) SKIP_VSCODE=true ;;
        --projects) LIST_PROJECTS=true ;;
        --skip) SKIP_PROJECTS="$2"; shift ;;
        *) echo "Bilinmeyen parametre: $1" ;;
    esac
    shift
done

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
      brew install --cask "$application" || echo "$application yüklenemedi, atlanıyor."
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

# VSCode uzantılarını ve ayarlarını yükler
if [ "$SKIP_VSCODE" = false ]; then
  if [ -f ~/backup/configs/vscode_extensions_list.txt ]; then
    echo "VSCode uzantıları yükleniyor..."
    while IFS= read -r extension; do
      code --install-extension "$extension" || echo "$extension yüklenemedi, atlanıyor."
    done < ~/backup/configs/vscode_extensions_list.txt
  else
    echo "VSCode uzantı listesi bulunamadı, atlanıyor."
  fi

  # VSCode ayarlarını geri yükler
  echo "VSCode ayarları geri yükleniyor..."
  cp ~/backup/configs/settings.json ~/Library/Application\ Support/Code/User/settings.json
  cp ~/backup/configs/keybindings.json ~/Library/Application\ Support/Code/User/keybindings.json
  cp -r ~/backup/configs/snippets ~/Library/Application\ Support/Code/User/snippets
else
  echo "VSCode uzantı ve ayarlarının yüklenmesi atlandı (--no-vscode parametresi kullanıldı)."
fi

# GitLab projelerinin klonlanmasını kontrol eder
PROJECTS_DIR="$HOME/Desktop/Projects"
if [ "$SKIP_GITLAB" = false ]; then
  if [ "$LIST_PROJECTS" = true ]; then
    echo "GitLab projeleri listeleniyor..."
    projects=$(curl --header "PRIVATE-TOKEN: $GITLAB_PRIVATE_TOKEN" "https://gitlab.com/api/v4/groups/$GITLAB_GROUP/projects?per_page=100" | jq -r '.[].name_with_namespace')
    i=1
    for project in $projects; do
      echo "$i. $project"
      i=$((i+1))
    done
    exit 0
  fi

  if [ ! -d "$PROJECTS_DIR" ] || [ -z "$(ls -A "$PROJECTS_DIR")" ]; then
    echo "GitLab projeleri klonlanıyor..."
    projects=$(curl --header "PRIVATE-TOKEN: $GITLAB_PRIVATE_TOKEN" "https://gitlab.com/api/v4/groups/$GITLAB_GROUP/projects?per_page=100" | jq -r '.[].ssh_url_to_repo')
    i=1
    for project in $projects; do
      if [[ ",$SKIP_PROJECTS," != *",$i,"* ]]; then
        echo "Klonlanıyor: $project"
        git clone "$project" "$PROJECTS_DIR/$(basename $project .git)" || echo "$project klonlanamadı, atlanıyor."
      else
        echo "$i numaralı proje atlanıyor."
      fi
      i=$((i+1))
    done
  else
    echo "GitLab projeleri zaten klonlanmış, atlanıyor."
  fi
else
  echo "GitLab projeleri klonlama atlandı (--none parametresi kullanıldı)."
fi

echo "Kurulum tamamlandı!"
