#!/usr/bin/env bash

export IMAGE=hammedbabatunde/demo-app:java-maven-2.0 
docker-compose -f docker-compose.yaml up -d
echo "success"