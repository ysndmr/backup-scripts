# Backup Scripts

[English](#english) | [Türkçe](#türkçe)

## English

This repository contains scripts that automate all the necessary installations and configurations when transitioning to a new computer.

### Contents
- configs/: Directory containing configuration files.
- setup_new_machine.sh: Main script that performs all installations on a new computer.
- configs/Brewfile: List of packages installed with Homebrew.
- configs/applications_list.txt: List of installed applications.
- configs/backup_all.sh: Script that backs up configuration files.
- configs/clone_gitlab_projects.sh: Script that clones GitLab projects.

## Installation Steps
Follow these steps to perform the backup and installation process on a new computer:

### 1. Clone the Repository
Open the terminal on your new computer and clone this repository:

```sh
git clone https://github.com/ysndmr/backup-scripts.git ~/backup
```

### 2.  Run the Main Script
Ensure that the script is executable:

```sh
chmod +x setup_new_machine.sh
```
Run the setup_new_machine.sh script to automatically perform all installations and configurations:


```sh
./setup_new_machine.sh
```

This script will perform the following steps:

- Installs Homebrew.
- Installs Git, Node.js, npm, and jq.
- Installs the packages backed up with Homebrew using `Brewfile`.
- Installs the applications listed in `applications_list.txt` with Homebrew.
- Restores configuration files (using the `backup_all.sh` script).
- Clones GitLab projects (using the `clone_gitlab_projects.sh` script).


### Parameters

The setup_new_machine.sh script can be run with the following parameters to skip certain steps or perform additional tasks:

1. `--none`
This parameter skips the GitLab projects cloning step.

```sh
./setup_new_machine.sh --none
```

2. `--no-vscode`
This parameter skips the Visual Studio Code extensions and settings restoration step.

```sh
./setup_new_machine.sh --no-vscode
```
3. `--projects`
This parameter lists the available projects in GitLab with numbered entries. After obtaining this list, you can decide which projects to skip.

```sh
./setup_new_machine.sh --projects
```

4. `--skip`
This parameter skips cloning the projects with the specified numbers. The numbers correspond to the list obtained with the --projects parameter. Multiple numbers can be specified, separated by commas.

```sh
./setup_new_machine.sh --skip 1,2,3
```
Example Usage Scenario
First, run the script with the --projects parameter to get a numbered list of projects:

```sh
./setup_new_machine.sh --projects
```
This will output a numbered list of projects. For example:


```sh
1. Group/Project1
2. Group/Project2
3. Group/Project3
```
Then, use the --skip parameter to skip cloning the projects you don't want:

```sh
./setup_new_machine.sh --skip 1,3
```
This command will skip cloning projects numbered 1 and 3.

# Backup Scripts

## Türkçe

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
Bu parametre, VS Code kurulum adımını atlar.
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


