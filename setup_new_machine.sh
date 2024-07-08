#!/bin/bash

# Parametre kontrolü
SKIP_GITLAB=false
SKIP_VSCODE=false
LIST_PROJECTS=false
SKIP_PROJECTS=""

# GitLab ayarları
GITLAB_GROUP="success-factory-development"  # URL'den alınan grup adı
GITLAB_PRIVATE_TOKEN="glpat-WsFRAWDYwLcLnKQPzzBs"  # Oluşturduğunuz kişisel erişim tokenı

while [[ "$#" -gt 0 ]]; do
    case $1 in
        --none) SKIP_GITLAB=true ;;
        --no-vscode) SKIP_VSCODE=true ;;
        --projects) LIST_PROJECTS=true ;;
        --skip) SKIP_PROJECTS="$2"; shift ;;
        *) echo "Unknown parameter: $1" ;;
    esac
    shift
done

# Ortak kısmı belirlemek için yardımcı fonksiyon
find_common_prefix() {
    # İlk projeyi ortak kısım olarak başlat
    local prefix=$1
    shift
    for name in "$@"; do
        while [[ "${name#$prefix}" == "$name" ]]; do
            prefix=${prefix%?}
        done
    done
    echo "$prefix"
}

# Eğer --projects parametresi verilmişse sadece projeleri listele ve çık
if [ "$LIST_PROJECTS" = true ]; then
    echo "Listing GitLab projects..."
    response=$(curl --header "PRIVATE-TOKEN: $GITLAB_PRIVATE_TOKEN" "https://gitlab.com/api/v4/groups/$GITLAB_GROUP/projects?per_page=100")
    projects=$(echo "$response" | jq -r '.[].name_with_namespace')
    if [ -z "$projects" ]; then
        echo "No projects found or there was an error retrieving the projects."
        echo "API Response: $response"
        exit 1
    fi

    # Proje isimlerini diziye al
    project_array=()
    while IFS= read -r project; do
        project_array+=("$project")
    done <<< "$projects"

    # Ortak kısmı bul
    common_prefix=$(find_common_prefix "${project_array[@]}")

    # Proje isimlerini ortak kısmı çıkararak listele
    i=1
    for project in "${project_array[@]}"; do
        project_name=${project#$common_prefix}
        echo "$i. $project_name"
        i=$((i+1))
    done
    exit 0
fi

# Homebrew'ü kurar
if ! command -v brew &> /dev/null; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "Homebrew is already installed, skipping."
fi

# Gerekli paketleri yükler
REQUIRED_PACKAGES=("git" "node" "npm" "jq" "lazygit" "fzf" "autojump" "fd" "the_silver_searcher" "ripgrep")
for pkg in "${REQUIRED_PACKAGES[@]}"; do
  if ! brew list -1 | grep -q "^${pkg}\$"; then
    echo "Installing $pkg..."
    brew install "$pkg"
  else
    echo "$pkg is already installed, skipping."
  fi
done

# Brewfile'daki paketleri yükler
if [ -f ./configs/Brewfile ]; then
  echo "Installing Homebrew packages..."
  brew bundle --file=./configs/Brewfile
else
  echo "./configs/Brewfile not found, skipping."
fi

# applications_list.txt dosyasındaki uygulamaları yükler
if [ -f ./configs/applications_list.txt ]; then
  echo "Installing applications..."
  while IFS= read -r application; do
    if ! brew list --cask -1 | grep -q "^${application}\$"; then
      echo "Installing $application..."
      brew install --cask "$application" || echo "Failed to install $application, skipping."
    else
      echo "$application is already installed, skipping."
    fi
  done < ./configs/applications_list.txt
else
  echo "./configs/applications_list.txt not found, skipping."
fi

# Yapılandırma dosyalarını geri yükler
echo "Restoring configuration files..."
cp ~/backup/configs/.zshrc ~/
cp ~/backup/configs/.gitconfig ~/
cp ~/backup/configs/.zprofile ~/
cp ~/backup/configs/.npmrc ~/
cp ~/backup/configs/.yarnrc ~/

# VSCode uzantılarını ve ayarlarını yükler
if [ "$SKIP_VSCODE" = false ]; then
  if [ -f ~/backup/configs/vscode_extensions_list.txt ]; then
    echo "Installing VSCode extensions..."
    while IFS= read -r extension; do
      code --install-extension "$extension" || echo "Failed to install $extension, skipping."
    done < ~/backup/configs/vscode_extensions_list.txt
  else
    echo "VSCode extensions list not found, skipping."
  fi

  # VSCode ayarlarını geri yükler
  echo "Restoring VSCode settings..."
  cp ~/backup/configs/settings.json ~/Library/Application\ Support/Code/User/settings.json
  cp ~/backup/configs/keybindings.json ~/Library/Application\ Support/Code/User/keybindings.json
  cp -r ~/backup/configs/snippets ~/Library/Application\ Support/Code/User/snippets
else
  echo "VSCode extensions and settings restoration skipped (--no-vscode parameter used)."
fi

# Oh My Zsh ve yapılandırmalarını geri yükler
echo "Restoring Oh My Zsh and configurations..."
cp -r ~/backup/configs/.oh-my-zsh ~/
cp ~/backup/configs/.p10k.zsh ~/
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# Zsh eklentilerini yükler
echo "Installing Zsh plugins..."
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
git clone https://github.com/lukechilds/zsh-better-npm-completion ~/.oh-my-zsh/custom/plugins/zsh-better-npm-completion
git clone https://github.com/changyuheng/zsh-interactive-cd ~/.oh-my-zsh/custom/plugins/zsh-interactive-cd

# Zsh yapılandırmasını yeniden yükle
echo "Loading Zsh configuration..."
source ~/.zshrc

# GitLab projelerinin klonlanmasını kontrol eder
PROJECTS_DIR="$HOME/Desktop/Projects"
if [ "$SKIP_GITLAB" = false ]; then
  if [ ! -d "$PROJECTS_DIR" ] || [ -z "$(ls -A "$PROJECTS_DIR")" ]; then
    echo "Cloning GitLab projects..."
    projects=$(curl --header "PRIVATE-TOKEN: $GITLAB_PRIVATE_TOKEN" "https://gitlab.com/api/v4/groups/$GITLAB_GROUP/projects?per_page=100" | jq -r '.[].ssh_url_to_repo')
    if [ -z "$projects" ]; then
        echo "No projects found or there was an error retrieving the projects."
        exit 1
    fi
    i=1
    while IFS= read -r project; do
      if [[ ",$SKIP_PROJECTS," != *",$i,"* ]]; then
        echo "Cloning: $project"
        git clone "$project" "$PROJECTS_DIR/$(basename $project .git)" || echo "Failed to clone $project, skipping."
      else
        echo "Skipping project number $i."
      fi
      i=$((i+1))
    done <<< "$projects"
  else
    echo "GitLab projects already cloned, skipping."
  fi
else
  echo "GitLab projects cloning skipped (--none parameter used)."
fi

echo "Setup completed!"
