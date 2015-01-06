#!/bin/bash

gcloud preview container clusters delete meteor
gcloud compute forwarding-rules delete meteor --quiet
gcloud compute target-pools delete meteor --quiet
gcloud compute firewall-rules delete meteor-80 --quiet
