#!/bin/bash

# Make sure to edit meteor-controller.json and set the right image version there before running this script.

echo "Deleting old meteor-controller:"
gcloud alpha container replicationcontrollers delete meteor-controller

echo "Creating new meteor-controller:"
gcloud alpha container replicationcontrollers create --config-file meteor-controller.json

echo "Doing a rolling update by deleting all old meteor pods and letting the replication controller create new ones:"
OLD_PODS=`gcloud alpha container pods list | grep name=meteor | cut -f1 -d ' '`
while read -r POD; do
  gcloud alpha container pods delete $POD
  # You might want to do the rolling update slower in practice:
  sleep 30
done <<< "$OLD_PODS"

echo "Current pods:"
gcloud alpha container pods list
