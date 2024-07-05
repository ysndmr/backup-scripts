#!/bin/bash

# GitLab ayarları
GITLAB_GROUP="success-factory-development"  # URL'den alınan grup adı
GITLAB_PRIVATE_TOKEN="glpat-WsFRAWDYwLcLnKQPzzBs"  # Oluşturduğunuz kişisel erişim tokenı

# Proje listesini almak için GitLab API'sini kullan
projects=$(curl --header "PRIVATE-TOKEN: $GITLAB_PRIVATE_TOKEN" "https://gitlab.com/api/v4/groups/$GITLAB_GROUP/projects?per_page=100" | jq -r 
'.[].ssh_url_to_repo')

# Projeleri klonla
for project in $projects; do
  git clone $project
done

echo "Tüm projeler başarıyla klonlandı."

