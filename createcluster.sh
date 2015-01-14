#!/bin/bash

# TODO set default project

# First we must tell Cloud Platform which region we want our Compute Engine servers to run in
gcloud config set compute/zone europe-west1-c
gcloud config set compute/region europe-west1

# Create a new cluster called "meteor". This will take a few minutes.
gcloud preview container clusters create meteor

# Create pods and a service based on the JSON configuration
gcloud preview container pods create --config-file mongo-pod.json
gcloud preview container services create --config-file mongo-service.json

# Because line 30, setting up a replication controller, depends on MongoDB
# (since it will boot Meteor), we have to wait
echo "Waiting for Mongo to start..."
while true; do
  MONGO_STATUS=`gcloud preview container pods describe mongo | tr -d '\n' | tr ' ' '\n' | tail -n1`
  if [ "$MONGO_STATUS" == "Running" ]; then
    echo
    break
  fi
  printf "."
  sleep 2
done

# Create our replication controller and service, also based on the JSON configuration
gcloud preview container replicationcontrollers create --config-file meteor-controller.json
gcloud preview container services create --config-file meteor-service.json

# We need to configure the correct firewall rules or nothing will get through
gcloud compute firewall-rules create meteor-80 --allow=tcp:80 --target-tags k8s-meteor-node

# End the program by showing us a list of what's running
gcloud compute forwarding-rules list
