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
