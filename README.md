# souljapanic_microservices
souljapanic microservices repository

[![Build Status](https://travis-ci.com/Otus-DevOps-2020-02/souljapanic_microservices.svg?branch=master)](https://travis-ci.com/Otus-DevOps-2020-02/souljapanic_microservices)

# docker-2

## Создание окружения:

* export GOOGLE_PROJECT=docker-275410

* docker-machine create --driver google --google-machine-image https://www.googleapis.com/compute/v1/projects/ubuntu-os-cloud/global/images/family/ubuntu-1604-lts --google-machine-type n1-standard-1 --google-zone europe-west1-b docker-host

* eval $(docker-machine env docker-host)

* docker-machine ssh docker-host

* cd docker-monolith && docker build -t reddit:latest .

* docker run --name reddit -d --network=host reddit:latest

* gcloud compute firewall-rules create reddit-app --allow tcp:9292 --target-tags=docker-machine --description="Allow PUMA connections" --direction=INGRESS

* curl -v http://104.155.110.167:9292

* docker login && docker tag reddit:latest souljapanic/reddit:1.0 && docker push souljapanic/reddit:1.0

## Дополнительное задание:

### Terraform:

* cd docker-monolith/infra/terraform

* terraform init

* terraform plan

* terraform apply

### Ansible:

* cd docker-monolith/infra/ansible

* ansible-inventory -i inventories/inventory.gcp.yml --graph

### Packer:

* cd docker-monolith/infra

* packer validate -var-file=packer/variables.json packer/docker.json

* packer build -var-file=packer/variables.json packer/docker.json

# docker-3

## Сборка образа:

* post: docker build -t souljapanic/post:1.0 ./src/post-py

* comment: docker build -t souljapanic/comment:1.0 ./src/comment

* ui: docker build -t souljapanic/ui:1.0 ./src/ui

* ui: docker build -t souljapanic/ui:2.0 -f src/ui/Dockerfile.Ubuntu ./src/ui

### Комментарии:

```
Во время сборки используется cache:

Step 2/13 : ARG APP_HOME
 ---> Using cache
```

## Запуск:

* создание сети: docker network create reddit

* запуск базы данных: docker run -d --network=reddit --network-alias=post_db --network-alias=comment_db mongo

* запуск post: docker run -d --network=reddit --network-alias=post souljapanic/post:1.0

* запуск comment: docker run -d --network=reddit --network-alias=comment souljapanic/comment:1.0

* запуск ui: docker run -d --network=reddit -p 9292:9292 souljapanic/ui:1.0

## Запуск дополнительное задание:

### 1:

* создание сети: docker network create reddit

* запуск базы данных: docker run -d --network=reddit --network-alias=post1 --network-alias=comment1 mongo

* запуск post: docker run -d -e POST_DATABASE_HOST=post1 --network=reddit --network-alias=post souljapanic/post:1.0

* запуск comment: docker run -d -e COMMENT_DATABASE_HOST=comment1 --network=reddit --network-alias=comment souljapanic/comment:1.0

* запуск ui: docker run -d --network=reddit -p 9292:9292 souljapanic/ui:1.0

### 2:

* создание сети: docker network create reddit

* запуск базы данных: docker run -d --network=reddit --network-alias=post1 --network-alias=comment1 mongo

* запуск post: docker run -d --network=reddit --network-alias=post2 --env-file ./env.list souljapanic/post:1.0

* запуск comment: docker run -d --network=reddit --network-alias=comment2 --env-file ./env.list souljapanic/comment:1.0

* запуск ui: docker run -d --network=reddit -p 9292:9292 --env-file ./env.list souljapanic/ui:1.0

## Сборка дополнительное задание:

* docker build --no-cache --rm --force-rm -t souljapanic/ui:4.0 -f src/ui/Dockerfile.Alpine ./src/ui

* docker build --no-cache --rm --force-rm -t souljapanic/comment:2.0 -f src/comment/Dockerfile.Alpine ./src/comment

```
otus/souljapanic_microservices [docker-3] » docker images
REPOSITORY            TAG                 IMAGE ID            CREATED             SIZE
souljapanic/ui        4.0                 c399c74dd555        2 minutes ago       94.2MB
souljapanic/ui        3.0                 f4391cad1afb        5 minutes ago       303MB
souljapanic/ui        2.0                 c8e191b7467a        13 minutes ago      436MB
souljapanic/ui        1.0                 15ec66701638        2 hours ago         775MB

otus/souljapanic_microservices [docker-3] » docker images
REPOSITORY            TAG                 IMAGE ID            CREATED             SIZE
souljapanic/comment   2.0                 e323c7198fef        30 seconds ago      91.7MB
souljapanic/comment   1.0                 6e07a9f44efd        3 hours ago         773MB
```

## Задание с volume:

* остановка (но так делать нельзя!): docker kill $(docker ps -q)

* удаление (и так тоже делать нельзя!): docker rm $(docker ps -a -q)

* создание volume: docker volume create reddit_db

* запуск базы данных: docker run -d --network=reddit --network-alias=post1 --network-alias=comment1 -v reddit_db:/data/db mongo

* запуск post: docker run -d --network=reddit --network-alias=post2 --env-file ./env.list souljapanic/post:1.0

* запуск comment: docker run -d --network=reddit --network-alias=comment2 --env-file ./env.list souljapanic/comment:2.0

* запуск ui: docker run -d --network=reddit -p 9292:9292 --env-file ./env.list souljapanic/ui:4.0

# docker-4

## Запуск:

* создание сети: docker network create back_net --subnet=10.0.2.0/24

* создание сети: docker network create front_net --subnet=10.0.1.0/24

```
otus/souljapanic_microservices [docker-4] » docker network ls
NETWORK ID          NAME                DRIVER              SCOPE
4a6cf33e65f5        back_net            bridge              local
3121f4923429        bridge              bridge              local
d5c661bff608        front_net           bridge              local
2d12c09b3fbe        host                host                local
8cad84a97367        none                null                local
120368c0a3cc        reddit              bridge              local
```

* запуск ui: docker run -d --network=front_net -p 9292:9292 --name ui souljapanic/ui:4.0

* запуск comment: docker run -d --network=back_net --name comment souljapanic/comment:2.0

* запуск post: docker run -d --network=back_net --name post souljapanic/post:1.0

* запуск базы данных: docker run -d --network=back_net --name mongo_db --network-alias=post_db --network-alias=comment_db mongo

* добавление контейнера в сеть: docker network connect front_net post && docker network connect front_net comment

## Сборка с помощью docker-compose:

* cd src/

* ui: docker-compose -f docker-compose.yml build ui

* post: docker-compose -f docker-compose.yml build post

* comment: docker-compose -f docker-compose.yml build comment

## Запуск проекта с помощью docker-compose:

* cd src/

* docker-compose up -d

```
В файле .env указана переменная COMPOSE_PROJECT_NAME для наименования контейнеров запускаемых через docker-compose
```

## Использование docker-compose.override.yml:

* cd src/

* docker-machine scp -r ui/ docker-host:/home/docker-user/ui

* docker-machine scp -r comment/ docker-host:/home/docker-user/comment

* docker-compose up -d

# gitlab-ci-1

## Подготовка окружения:

* Заказ машины:

```
cd machine-gitlab/terraform

terraform init

terraform plan

terraform apply

```

* Установка dockerd:

```
cd machine-gitlab/ansible

ansible-playbook -i inventory.gcp.yml docker.yml
```

* Запуск GitLab:

```
cd machine-gitlab/ansible

ansible-playbook -i inventory.gcp.yml gitlab.yml
```

* Загрузка проекта в GitLab:

```
git remote add gitlab ssh://git@34.78.224.181:2222/homework/example.git

git push gitlab gitlab-ci-1
```

## Установка GitLab и запуск GitLab Runner с помощью ansible:

* cd gitlab-ci/

* ansible-playbook -i inventory.gcp.yml gitlab.yml

* ansible-playbook -i inventory.gcp.yml gitlab_runner.yml

## Ссылка на канал уведомления в Slack:

* https://devops-team-otus.slack.com/archives/CV4QKMVMX

# monitoring-1

## Создание окружения:

* export GOOGLE_PROJECT=docker-275410

* docker-machine create --driver google --google-machine-image https://www.googleapis.com/compute/v1/projects/ubuntu-os-cloud/global/images/family/ubuntu-1604-lts --google-machine-type n1-standard-1 --google-zone europe-west1-b docker-host

* eval $(docker-machine env docker-host)

* gcloud compute firewall-rules create prometheus-default --allow tcp:9090 --target-tags=docker-machine

* gcloud compute firewall-rules create puma-default --allow tcp:9292 --target-tags=docker-machine

## Запуск Prometheus:

* docker run --rm -p 9090:9090 -d --name prometheus prom/prometheus:v2.1.0

* Проверка работоспособности:

```
~ » docker ps
CONTAINER ID        IMAGE                    COMMAND                  CREATED             STATUS              PORTS                    NAMES
58f75b11b471        prom/prometheus:v2.1.0   "/bin/prometheus --c…"   35 seconds ago      Up 33 seconds       0.0.0.0:9090->9090/tcp   prometheus
```

## Сборка Docker образов:

* cd monitoring/prometheus

* docker build --rm --no-cache -t souljapanic/prometheus .

* export USER_NAME=souljapanic

* cd src/ui && bash docker_build.sh

* cd src/post-py && bash docker_build.sh

* cd src/comment && bash docker_build.sh

* cd docker && docker-compose up -d

## Ссылка на репозиторий:

* https://hub.docker.com/u/souljapanic

## mongodb exporter (взят экспортер https://github.com/percona/mongodb_exporter, собирается свой образ):

* cd monitoring/mongodb_exporter

* docker build --rm -t souljapanic/mongodb_exporter .

* cd docker && docker-compose up -d

## blackbox (используется модуль http, собирается свой образ):

* cd monitoring/blackbox

* cd docker && docker-compose up -d

## Makefile (реализован только для образа prometheus)

* cd monitoring/prometheus

* make build

* make push

* build_and_push

# monitoring-2

## Создание окружения:

* export GOOGLE_PROJECT=docker-275410

* docker-machine create --driver google --google-machine-image https://www.googleapis.com/compute/v1/projects/ubuntu-os-cloud/global/images/family/ubuntu-1604-lts --google-machine-type n1-standard-1 --google-zone europe-west1-b docker-host

* eval $(docker-machine env docker-host)

* gcloud compute firewall-rules create prometheus-default --allow tcp:9090 --target-tags=docker-machine

* gcloud compute firewall-rules create puma-default --allow tcp:9292 --target-tags=docker-machine

* gcloud compute firewall-rules create cadvisor-default --allow tcp:8080 --target-tags=docker-machine

* gcloud compute firewall-rules create grafana-default --allow tcp:3000 --target-tags=docker-machine

* gcloud compute firewall-rules create alertmanager-default --allow tcp:9093 --target-tags=docker-machine

* gcloud compute firewall-rules create metrics-default --allow tcp:9323 --target-tags=docker-machine

* gcloud compute firewall-rules create telegraf-default --allow tcp:9126 --target-tags=docker-machine

* gcloud compute firewall-rules create stackdriver-default --allow tcp:9255 --target-tags=docker-machine

* Создание сети:

```
docker network create reddit
```

## Описание файлов:

* Файл с описание приложений: docker/docker-compose.yml

* Файл с описанием мониторинга: docker/docker-compose-monitoring.yml

## Сборка образа AlertManager:

* cd monitoring/alertmanager

* docker build --rm --no-cache -t souljapanic/alertmanager .

## Ссылка на репозиторий:

* https://hub.docker.com/u/souljapanic

## Дополнительные задания:

* Сборка Prometheus и Alertmanagers с помощью makefile:

```
cd monitoring && make build_and_push
```

* Настройка уведомления для процентиль:

```
cd prometheus

alerts.yml - описание правил уведомления
```

* Сборка образа telegraf

```
cd monitoring/telegraf
docker build --rm --no-cache -t souljapanic/telegraf .
```

* Сборка образа grafana с настроенными dashboards и datasources:

```
cd monitoring/grafana
docker build --rm --no-cache -t souljapanic/grafana .

dm.json - dashboard docker metrics prometheus

telegraf.json - dashboard docker metrics telegraf

blm.json - dashboard Business Logic Monitoring

usm.json - dashboards UI Service Monitoring

prometheus.yml - настройка datasource prometheus

prometheus_dashboards.yml - dashboard provider
```

* Сборка stackdriver-exporter:

```
cd monitoring/stackdriver-exporter

В контейнер подкладываем service_account от проекта в GCP и выполняем сборку (так делать нельзя, это для примера!)

docker build --rm --no-cache -t souljapanic/stackdriver-exporter .

Выполняется сбор следующих метрик:

- compute.googleapis.com/instance/cpu
- compute.googleapis.com/instance/disk

За основу взят exporter: https://github.com/prometheus-community/stackdriver_exporter
Пример метрик: https://cloud.google.com/monitoring/api/metrics
```

* Сборка trickster:

```
cd monitoring/trickster

docker build --rm --no-cache -t souljapanic/trickster .

Конфигураия trickster описана в файле trickster.conf, используется cache в памяти для prometheus

Добавлен сбор метрик с trickster в prometheus

В Grafana добавлен в provision доступ к prometheus через trickster
```

# logging-1

## Сборка образов приложения:

```
export USER_NAME=souljapanic

for i in ui post-py comment; do cd src/$i; bash docker_build.sh; cd -; done
```

## Настройка окружения в GCE:

```
gcloud compute firewall-rules create tcp5601 --allow tcp:5601 --target-tags=docker-machine

gcloud compute firewall-rules create tcp9292 --allow tcp:9292 --target-tags=docker-machine

gcloud compute firewall-rules create tcp9411 --allow tcp:9411 --target-tags=docker-machine
```

## Сборка fluentd:

```
cd logging/fluentd

export USER_NAME=souljapanic

docker build -t $USER_NAME/fluentd .
```

## Запуск проекта:

```
cd docker

sysctl -w vm.max_map_count=262144

docker-compose -f docker-compose-logging.yml up -d

docker-compose up -d
```
