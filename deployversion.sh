#!/bin/bash

gcloud preview container replicationcontrollers delete meteor-controller

# TODO edit meteor-controller.json first
gcloud preview container replicationcontrollers create --config-file meteor-controller.json

# Delete all pods of the old version to make space for the new version:
gcloud preview container pods list | grep chees/meteor-testje:7 | cut -f1 -d ' ' | xargs -L1 gcloud preview container pods delete
