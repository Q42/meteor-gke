#!/bin/bash

DISK_NAME=mongo-disk
DISK_SIZE=200GB
ZONE=europe-west1-c

gcloud compute disks create --size=$DISK_SIZE --zone=$ZONE $DISK_NAME
gcloud compute instances attach-disk --zone=$ZONE --disk=$DISK_NAME --device-name temp-data k8s-meteor-master
gcloud compute ssh --zone=$ZONE k8s-meteor-master --command "sudo mkdir /mnt/tmp && sudo /usr/share/google/safe_format_and_mount /dev/disk/by-id/google-temp-data /mnt/tmp"
gcloud compute instances detach-disk --zone=$ZONE --disk $DISK_NAME k8s-meteor-master
