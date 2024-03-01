#!/bin/bash

i=1
while IFS= read -r line; do
    var="server${i}ip"
    eval "$var=$(echo "$line" | awk '{print $1}')"
    i=$((i+1))
done < "ips"

# Check if any of the IP addresses are already in /etc/hosts
if grep -qF "${server1ip}" /etc/hosts ||  grep -qF "${server2ip}" /etc/hosts ||  grep -qF "${server3ip}" /etc/hosts ||  grep -qF "${server4ip}" /etc/hosts; then
    # If any of the IPs are not found in /etc/hosts, then append the entries
    echo "$server2ip  cartservice" | sudo tee -a /etc/hosts
    echo "$server2ip  shippingservice" | sudo tee -a /etc/hosts
    echo "$server2ip  currencyservice" | sudo tee -a /etc/hosts
    echo "$server3ip  checkoutservice" | sudo tee -a /etc/hosts
    echo "$server4ip  adservice" | sudo tee -a /etc/hosts
fi


# maak een docker netwerk aan
docker network create front-network


# kijk of er al containers running zijn en stop ze
if [ $(docker ps -q | wc -l) -gt 0 ]; then
    docker stop $(docker ps -q)
fi

# run alle containers
docker run -d --rm --env-file /home/ec2-user/online-boutique/src/variables.env --env PORT=80 --network front-network --name frontend -p 8080:80 public.ecr.aws/j1n2c2p2/microservices-demo/frontend:latest

docker run -d --rm --env-file /home/ec2-user/online-boutique/src/variables.env --env PORT=8081 --network front-network --name recommendationservice -p 8081:8081 public.ecr.aws/j1n2c2p2/microservices-demo/recommendationservice:latest

docker run -d --rm --env-file /home/ec2-user/online-boutique/src/variables.env --env PORT=3550 --network front-network --name productcatalogservice -p 3550:3550 public.ecr.aws/j1n2c2p2/microservices-demo/productcatalogservice:latest