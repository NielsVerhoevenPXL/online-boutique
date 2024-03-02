#!/bin/bash

# maak een docker netwerk aan
docker network create ad-network

# kijk of er al containers running zijn en stop ze
if [ $(docker ps -q | wc -l) -gt 0 ]; then
    docker stop $(docker ps -q)
fi

# get server IP addresses
i=1
while IFS= read -r line; do
    var="server${i}ip"
    eval "$var=$(echo "$line" | awk '{print $1}')"
    i=$((i+1))
done < "ips"

# run alle containers
docker run -d --rm --env FRONTEND_ADDR="$server1ip:8080" --env USERS=10 --network ad-network --name loadgenerator loadgenerator
docker run -d --rm --env-file variables.env --env PORT=9555 --network ad-network --name adservice -p 9555:9555 adservice


docker exec loadgenerator sh -c "echo '$server1ip  frontend' | tee -a /etc/hosts"
