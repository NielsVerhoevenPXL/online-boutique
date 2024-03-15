#!/bin/bash

# maak een docker netwerk aan
docker network create cart-network


# kijk of er al containers running zijn en stop ze
if [ $(docker ps -q | wc -l) -gt 0 ]; then
    docker stop $(docker ps -q)
fi

# run alle containers
docker run -d --rm --env-file variables.env --env PORT=7070 --network cart-network --name cartservice -p 7070:7070 public.ecr.aws/j1n2c2p2/microservices-demo/cartservice:latest
docker run -d --rm --env-file variables.env --env PORT=50051 --network cart-network --name shippingservice -p 50051:50051 public.ecr.aws/j1n2c2p2/microservices-demo/shippingservice:latest
docker run -d --rm --env-file variables.env --env PORT=7000  --network cart-network --name currencyservice -p 50000:50000 -p 60000:60000 -p 7000:7000 public.ecr.aws/j1n2c2p2/microservices-demo/currencyservice:latest
