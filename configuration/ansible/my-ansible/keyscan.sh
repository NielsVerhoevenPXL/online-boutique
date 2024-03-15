#!/bin/bash

echo >> ~/.ssh/known_hosts

ssh-keyscan -H server1 >> ~/.ssh/known_hosts
ssh-keyscan -H server2 >> ~/.ssh/known_hosts
ssh-keyscan -H server3 >> ~/.ssh/known_hosts
ssh-keyscan -H server4 >> ~/.ssh/known_hosts
