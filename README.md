# souljapanic_microservices
souljapanic microservices repository

# docker-2

## Создание окружения:

* export GOOGLE_PROJECT=docker-275410

* docker-machine create --driver google --google-machine-image https://www.googleapis.com/compute/v1/projects/ubuntu-os-cloud/global/images/family/ubuntu-1604-lts --google-machine-type n1-standard-1 --google-zone europe-west1-b docker-host

* eval $(docker-machine env docker-host)

* docker-machine ssh docker-host
