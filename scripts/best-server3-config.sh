#!/bin/bash

# maak een docker netwerk aan
docker network create checkout-network

# kijk of er al containers running zijn en stop ze
if [ $(docker ps -q | wc -l) -gt 0 ]; then
    docker stop $(docker ps -q)
fi

docker run -d --rm --env-file ~/online-boutique/src/variables.env --env PORT=5050 --network checkout-network --name checkoutservice -p 5050:5050 public.ecr.aws/j1n2c2p2/microservices-demo/checkoutservice:latest
docker run -d --rm --env-file ~/online-boutique/src/variables.env --env PORT=50051 --network checkout-network --name paymentservice -p 50051:50051 public.ecr.aws/j1n2c2p2/microservices-demo/paymentservice:latest
docker run -d --rm --env-file ~/online-boutique/src/variables.env --env PORT=5000 --network checkout-network --name emailservice -p 5000:5000 public.ecr.aws/j1n2c2p2/microservices-demo/emailservice:latest


# get server IP addresses
i=1
while IFS= read -r line; do
    var="server${i}ip"
    eval "$var=$(echo "$line" | awk '{print $1}')"
    i=$((i+1))
done < "ips"

docker exec checkoutservice sh -c "echo '$server1ip  productcatalogservice' | tee -a /etc/hosts"
docker exec checkoutservice sh -c "echo '$server2ip  cartservice' | tee -a /etc/hosts"
docker exec checkoutservice sh -c "echo '$server2ip  shippingservice' | tee -a /etc/hosts"
docker exec checkoutservice sh -c "echo '$server2ip  currencyservice' | tee -a /etc/hosts"