#!/usr/bin/env bash

sudo export IMAGE=$1 
sudo docker-compose -f docker-compose.yaml up -d
echo "success"