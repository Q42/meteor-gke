#!/bin/bash

echo "Deleting the cluster, load balancer and firewall rules."
echo "This won't delete the persistent disk for Mongo, so setting up the cluster again will get you back in the same state."

gcloud alpha container clusters delete meteor
#gcloud compute forwarding-rules delete meteor --quiet
gcloud compute forwarding-rules delete k8s-meteor-default-meteor --quiet
gcloud compute target-pools delete k8s-meteor-default-meteor --quiet
gcloud compute firewall-rules delete meteor-80 --quiet
