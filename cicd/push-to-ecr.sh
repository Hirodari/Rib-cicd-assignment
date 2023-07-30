#!/bin/bash

# fail on any error
set -eu

# build docker image 
docker build -t hirodaridevdock/angular ../angular-demo/.

# retag docker image 
docker tag hirodaridevdock/angular $AWS_ACCOUNT.dkr.ecr.us-east-1.amazonaws.com/angular

# login to ecr
aws ecr get-login-password | docker login --username AWS --password-stdin $AWS_ACCOUNT.dkr.ecr.us-east-1.amazonaws.com

# push docker image to ecr repository 
docker push $AWS_ACCOUNT.dkr.ecr.us-east-1.amazonaws.com/angular