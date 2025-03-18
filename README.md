# project_DDOS_GUARD
Техническое задание для компании DDOS-GUARD
Индивидуальное тестовое задание для DevOps-инженера

Цель: создание сценария развёртывания сервисов и систем

## Требования к ПО
Debian 12
MariaDB - 10.3 или новее
docker + docker-compose (или плагин docker compose)
grafana, prometheus - последние стабильные версии
prometheus-node-exporter, mysqld_exporter - версии, доступные в соответствии с выбранными ОС и ПО

## Описание
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