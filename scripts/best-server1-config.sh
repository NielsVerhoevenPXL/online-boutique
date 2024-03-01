#!/bin/bash

# defineer variabelen
server2ip="172.31.60.72"
server3ip="172.31.53.10"
server4ip="172.31.55.191"

echo "$server2ip  cartservice" | sudo tee -a /etc/hosts
echo "$server2ip  shippingservice" | sudo tee -a /etc/hosts
echo "$server2ip  currencyservice" | sudo tee -a /etc/hosts
echo "$server3ip  checkoutservice" | sudo tee -a /etc/hosts
echo "$server4ip  adservice" | sudo tee -a /etc/hosts

docker network create front-network

docker run -d --rm --env-file ~/online-boutique/src/variables.env --env PORT=80 --network front-network --name frontend -p 8080:80 public.ecr.aws/j1n2c2p2/microservices-demo/frontend:latest

docker run -d --rm --env-file ~/online-boutique/src/variables.env --env PORT=8081 --network front-network --name recommendationservice -p 8081:8081 public.ecr.aws/j1n2c2p2/microservices-demo/recommendationservice:latest

docker run -d --rm --env-file ~/online-boutique/src/variables.env --env PORT=3550 --network front-network --name productcatalogservice -p 3550:3550 public.ecr.aws/j1n2c2p2/microservices-demo/productcatalogservice:latest