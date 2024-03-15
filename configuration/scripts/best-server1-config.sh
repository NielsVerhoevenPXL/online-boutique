#!/bin/bash

# maak een docker netwerk aan
docker network create front-network

# kijk of er al containers running zijn en stop ze
if [ $(docker ps -q | wc -l) -gt 0 ]; then
    docker stop $(docker ps -q)
fi

# run alle containers
docker run -d --rm --env-file variables.env --env PORT=80 --network front-network --name frontend -p 8080:80 public.ecr.aws/j1n2c2p2/microservices-demo/frontend:latest

docker run -d --rm --env-file variables.env --env PORT=8081 --network front-network --name recommendationservice -p 8081:8081 public.ecr.aws/j1n2c2p2/microservices-demo/recommendationservice:latest

docker run -d --rm --env-file variables.env --env PORT=3550 --network front-network --name productcatalogservice -p 3550:3550 public.ecr.aws/j1n2c2p2/microservices-demo/productcatalogservice:latest

# get server IP addresses
i=1
while IFS= read -r line; do
    var="server${i}ip"
    eval "$var=$(echo "$line" | awk '{print $1}')"
    i=$((i+1))
done < "ips"


docker exec frontend sh -c "echo '$server2ip  cartservice' | tee -a /etc/hosts"
docker exec frontend sh -c "echo '$server2ip  shippingservice' | tee -a /etc/hosts"
docker exec frontend sh -c "echo '$server2ip  currencyservice' | tee -a /etc/hosts"
docker exec frontend sh -c "echo '$server3ip  checkoutservice' | tee -a /etc/hosts"
docker exec frontend sh -c "echo '$server4ip  adservice' | tee -a /etc/hosts"
