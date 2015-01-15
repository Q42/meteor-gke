#!/bin/bash

# Make sure to edit meteor-controller.json and set the right image version there before running this script.

echo "Deleting old meteor-controller:"
gcloud preview container replicationcontrollers delete meteor-controller

echo "Creating new meteor-controller:"
gcloud preview container replicationcontrollers create --config-file meteor-controller.json

echo "Doing a rolling update by deleting all old meteor pods and letting the replication controller create new ones:"
OLD_PODS=`gcloud preview container pods list | grep name=meteor | cut -f1 -d ' '`
while read -r POD; do
  gcloud preview container pods delete $POD
  # You might want to do the rolling update slower in practice:
  sleep 30
done <<< "$OLD_PODS"

echo "Current pods:"
gcloud preview container pods list
