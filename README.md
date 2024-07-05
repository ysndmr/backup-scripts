# backup-scripts
# Backup Scripts

Bu depo, yeni bir bilgisayara geçiş yaparken gerekli tüm kurulumları ve yapılandırmaları otomatik olarak gerçekleştiren script'leri içerir.

## İçindekiler

- `configs/`: Yapılandırma dosyalarının bulunduğu dizin.
- `setup_new_machine.sh`: Yeni bilgisayarda tüm kurulumları gerçekleştiren ana script.
- `configs/Brewfile`: Homebrew ile yüklenen paketlerin listesi.
- `configs/applications_list.txt`: Kurulu uygulamaların listesi.
- `configs/backup_all.sh`: Yapılandırma dosyalarını yedekleyen script.
- `configs/clone_gitlab_projects.sh`: GitLab projelerini klonlayan script.

## Kurulum Adımları

Yeni bilgisayarda bu yedekleme ve kurulum işlemlerini gerçekleştirmek için aşağıdaki adımları izleyin:

### 1. Depoyu Klonlayın

Yeni bilgisayarınızda terminali açın ve bu depoyu klonlayın:

```sh
git clone https://github.com/ysndmr/backup-scripts.git ~/backup
cd ~/backup

## Ana Script'i Çalıştırın
Tüm kurulumları ve yapılandırmaları otomatik olarak gerçekleştirmek için setup_new_machine.sh script'ini çalıştırın:

```./setup_new_machine.sh```

Bu script aşağıdaki adımları gerçekleştirecektir:

- Homebrew'ü kurar.
- Git, Node.js, npm ve jq'yu kurar.
- Homebrew ile yedeklenen paketleri Brewfile kullanarak kurar.
- applications_list.txt dosyasındaki uygulamaları Homebrew ile kurar.
- Yapılandırma dosyalarını geri yükler (backup_all.sh script'i ile).
- GitLab projelerini klonlar (clone_gitlab_projects.sh script'i ile).
