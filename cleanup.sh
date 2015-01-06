#!/bin/bash

gcloud preview container clusters delete meteor
gcloud compute forwarding-rules delete meteor
gcloud compute target-pools delete meteor
gcloud compute firewall-rules delete meteor-80
