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
```

### 2. Ana Script'i Çalıştırın
Script'in çalıştırılabilir olduğundan emin olun:

```sh
chmod +x setup_new_machine.sh
```

Tüm kurulumları ve yapılandırmaları otomatik olarak gerçekleştirmek için setup_new_machine.sh script'ini çalıştırın:

```sh
./setup_new_machine.sh
```

Bu script aşağıdaki adımları gerçekleştirecektir:

- Homebrew'ü kurar.
- Git, Node.js, npm ve jq'yu kurar.
- Homebrew ile yedeklenen paketleri Brewfile kullanarak kurar.
- applications_list.txt dosyasındaki uygulamaları Homebrew ile kurar.
- Yapılandırma dosyalarını geri yükler (backup_all.sh script'i ile).
- GitLab projelerini klonlar (clone_gitlab_projects.sh script'i ile).

### Parametreler

`setup_new_machine.sh` script'i, belirli adımları atlamak veya ek işlemler yapmak için aşağıdaki parametrelerle çalıştırılabilir:

1. `--none`
Bu parametre, GitLab projelerinin klonlanma adımını atlar.
```sh
./setup_new_machine.sh --none
```

2. `--no-vscode`
Bu parametre, GitLab projelerinin klonlanma adımını atlar.
```sh
./setup_new_machine.sh --no-vscode
```
3. `--projects`
Bu parametre, GitLab'da mevcut olan projelerin listesini numaralı olarak çıkartır. Bu listeyi aldıktan sonra, hangi projeleri atlamak istediğinizi belirleyebilirsiniz.

```sh
./setup_new_machine.sh --projects
```

4. `--skip`
Bu parametre, belirli numaralı projeleri klonlamadan atlamayı sağlar. Numara aralıkları, --projects parametresi ile alınan listeye dayanmaktadır. Birden fazla numara virgülle ayrılarak belirtilebilir.

```sh
./setup_new_machine.sh --skip 1,2,3
```
Örnek Kullanım Senaryosu
Öncelikle, projelerin listesini almak için --projects parametresi ile script'i çalıştırın:

```sh
./setup_new_machine.sh --projects
```
Bu, projelerin numaralı bir listesini döndürecektir. Örneğin:
```sh
1. Group/Project1
2. Group/Project2
3. Group/Project3
```

Daha sonra, klonlamak istemediğiniz projeleri atlamak için --skip parametresini kullanın:

```sh
./setup_new_machine.sh --skip 1,3
```
Bu komut, 1 ve 3 numaralı projeleri klonlamadan atlayacaktır.

