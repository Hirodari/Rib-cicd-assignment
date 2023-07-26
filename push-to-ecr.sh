#!/bin/bash

# fail on any error
set -eu

# retag docker image 
docker tag hirodaridevdock/angular 763544978374.dkr.ecr.us-east-1.amazonaws.com/angular

# login to ecr
aws ecr get-login-password | docker login --username AWS --password-stdin 763544978374.dkr.ecr.us-east-1.amazonaws.com

# push docker image to ecr repository 
docker push 763544978374.dkr.ecr.us-east-1.amazonaws.com/angular