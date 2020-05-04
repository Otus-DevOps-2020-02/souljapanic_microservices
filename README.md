# souljapanic_microservices
souljapanic microservices repository

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
