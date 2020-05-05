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
