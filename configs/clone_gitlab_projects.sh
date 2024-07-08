#!/bin/bash

# GitLab ayarları
GITLAB_GROUP="success-factory-development"  # URL'den alınan grup adı
GITLAB_PRIVATE_TOKEN="glpat-WsFRAWDYwLcLnKQPzzBs"  # Oluşturduğunuz kişisel erişim tokenı

# Projeleri indireceğimiz dizin
DESTINATION_DIR="$HOME/Desktop/Projects"

# Proje listesini almak için GitLab API'sini kullan
projects=$(curl --header "PRIVATE-TOKEN: $GITLAB_PRIVATE_TOKEN" "https://gitlab.com/api/v4/groups/$GITLAB_GROUP/projects?per_page=100" | jq -r '.[].ssh_url_to_repo')

# Hedef dizinin var olup olmadığını kontrol et, yoksa oluştur
if [ ! -d "$DESTINATION_DIR" ]; then
  mkdir -p "$DESTINATION_DIR"
fi

# Projeleri klonla
if [ -z "$projects" ]; then
  echo "Proje bulunamadı veya erişim reddedildi. Lütfen grup adını ve erişim tokenınızı kontrol edin."
  exit 1
fi

echo "Projeler klonlanıyor..."
for project in $projects; do
  echo "Klonlanıyor: $project"
  git clone "$project" "$DESTINATION_DIR/$(basename $project .git)" || echo "Klonlama hatası: $project"
done

echo "Tüm projeler klonlama işlemi tamamlandı."
