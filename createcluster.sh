#!/bin/bash

# TODO set default project

gcloud config set compute/zone europe-west1-c
gcloud config set compute/region europe-west1

gcloud preview container clusters create meteor

gcloud preview container pods create --config-file mongo-pod.json
gcloud preview container services create --config-file mongo-service.json

echo "Waiting for Mongo to start..."
while true; do
  MONGO_STATUS=`gcloud preview container pods describe mongo | tr -d '\n' | tr ' ' '\n' | tail -n1`
  if [ "$MONGO_STATUS" == "Running" ]; then
    break
  fi
  printf "."
  sleep 2
done

gcloud preview container replicationcontrollers create --config-file meteor-controller.json
gcloud preview container services create --config-file meteor-service.json

gcloud compute firewall-rules create meteor-80 --allow=tcp:80 --target-tags k8s-meteor-node

gcloud compute forwarding-rules list
