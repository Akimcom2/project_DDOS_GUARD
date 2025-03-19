# Project_DDOS_GUARD
Техническое задание для компании DDOS-GUARD
Индивидуальное тестовое задание для DevOps-инженера

Цель: создание сценария развёртывания сервисов и систем

## Требования к ПО
Debian 12
MariaDB - 10.3 или новее
docker + docker-compose (или плагин docker compose)
grafana, prometheus - последние стабильные версии
prometheus-node-exporter, mysqld_exporter - версии, доступные в соответствии с выбранными ОС и ПО

## Описание задания
Задание предполагает развёртывание решения на двух системах
1. В первой системе должны быть развёрнуты prometheus-node-exporter, mariadb, mysqld_exporter + фаерволл (nftables). Развёртывание предполагается без использования контейнеризации.
2. В первой системе должен быть сконфигурирован фаерволл - закрыты все порты, кроме ssh, prometheus-node-exporter, mariadb, mysqld_exporter. Список открытых портов должен задаваться в виде переменных в ansible.
3. Во второй системе должны быть развёрнуты docker + docker compose, prometheus и grafana. Файлы конфигураций должны находиться на хосте и монтироваться в контейнеры в режиме ro.
4. В prometheus должен быть организован сбор метрик prometheus-node-exporter и mysqld_exporter
5. В grafana необходимо реализовать два dashboard:
	- общие метрики ОС (cpu, RAM, загруженность сетевых интерфейсов, заполненность диска);
	- метрики mariadb - количество соединений, количество запросов в общем, отдельно количество чтений (select), отдельно количество остальных операций записи (update, insert, delete).

## Ожидаемый результат
Проект должен состоять из
1. набора конфигураций для каждого из используемого ПО.
2. docker-compose.yml файла, разворачивающего контейнеры и монтирующего структуру каталогов с файлами конфигураций. Развёртывание должно происходить без дополнительных действий на хосте - все предварительные подготовки должны быть проведены посредством ansible.
3. json-моделей dashboard’ов, готовых для импорта в развёрнутое решение.

Проект должен быть загружен в git репозиторий (с публичным доступом) в виде ansible проекта, (включающего шаблоны и файлы, используемые в процессе). 
Также должно присутствовать описание проекта, позволяющее его использовать для развёртывания описанного решения.

# Решение
## Структура файлов и каталогов решения

```
└── project_DDOS_GUARD
    ├── ansible
    │   ├── Ansible_VM
    │   │   ├── ansible.cfg
    │   │   ├── ansible.sh
    │   │   └── playbook.yml
    │   ├── Docker_VM
    │   │   ├── ansible.cfg
    │   │   ├── ansible.sh
    │   │   └── playbook.yml
    │   └── hosts.ini
    ├── configs
    │   ├── .my.cnf
    │   ├── mysql_metrics.json
    │   ├── nftables.conf
    │   └── os_metrics.json
    ├── docker
    │   ├── docker-compose.yaml
    │   ├── grafana
    │   │   └── .my.cnf
    │   └── prometheus
    │       └── prometheus.yml
        ├── pkgs
    │   ├── mariadb-server-10.5_1%3a10.11.6-0+deb12u1_amd64.deb
    │   ├── nftables_1.0.6-2+deb12u2_amd64.deb
    │   ├── prometheus-mysqld-exporter_0.14.0-3+b5_amd64.deb
    │   └── prometheus-node-exporter_1.5.0-1+b6_amd64.deb
    |── scripts
    |    └── create_user.sh
    ├── README.md
        ```
## Проверка структуры
Проверка была выполнена на виртуальных хостах:
#### 89.104.66.160 - Docker/Prometheus/Grafana
#### 89.104.66.136 - Prometheus-node-exporter, mariadb, mysqld_exporter + фаерволл (nftables)

## Сценарий работы с решением

1. Обновление целевых хостов (Ansible)
Файл: ansible/hosts.ini
Замените существующие IP-адреса на актуальные значения для ваших серверов.
2. Настройка сбора метрик (Prometheus)
Файл: docker/prometheus/prometheus.yml
Обновите IP-адреса в секциях targets для следующих job:

node_exporter (метрики серверов)

mysqld_exporter (метрики MySQL/MariaDB)
3. Настройка учетных данных MySQL
Скрипт: scripts/create_user.sh
Замените значения переменных:
export MYSQL_ROOT_PASSWORD="ваш_пароль_root"          # Пароль администратора БД
export MYSQL_EXPORTER_PASSWORD="ваш_пароль_экспортера" # Пароль для сбора метрик

Конфиг: configs/.my.cnf
Приведите в соответствие параметры доступа:
[client]
user = exporter
password = ваш_пароль_экспортера
4. Параметры подключения Ansible
Файлы:
ansible/Docker_VM/ansible.sh
ansible/Ansible_VM/ansible.sh
Обновите авторизационные данные:
### Пример строки для подключения:
ansible-playbook ... -e "ansible_user=ваш_пользователь ansible_password=ваш_пароль ansible_become_method=ваш_метод_повышения_прав"
Где:

ansible_user — пользователь для SSH-подключения

ansible_password — пароль пользователя

Рекомендации:

Для Grafana оставьте конфигурацию без изменений, если имя контейнера в docker-compose.yaml не менялось.

Проверьте доступность портов (9100, 9104, 9090) в firewall после развертывания.

## Сценарий развертки:
1. Развернуть систему Docker:
	```
	- cd ansible/Docker_VM/
	- ./ansible.sh 
	```
2. Развернуть систему Ansible:
	```
	- cd ansible/Ansible_VM/
	- ./ansible.sh 
	```
3. Импортировать dashboards в Grafana:
	Открыть веб-интерфейс Grafana и войти под учетной записью администратора.
	Перейти в раздел Dashboards -> Manage, выбрать опцию Import и загрузить подготовленные JSON-файлы.
	
Таким образом, вы получите готовое решение для мониторинга вашей инфраструктуры с использованием Prometheus, Grafana и MariaDB.

