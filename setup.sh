#!/bin/bash

DISK_NAME=mongo-disk
DISK_SIZE=200GB
ZONE=europe-west1-c


# TODO make project, zone, region and cluster configurable and pass it to every gcloud command?
# TODO set CLOUDSDK_CONTAINER_CLUSTER ?

# Create a new cluster called "meteor". This will take a few minutes.
gcloud alpha container clusters create meteor


if gcloud compute disks list $DISK_NAME | grep READY > /dev/null
then
  echo "$DISK_NAME already exists."
else
  echo "Creating $DISK_NAME:"
  gcloud compute disks create --size=$DISK_SIZE --zone=$ZONE $DISK_NAME
  echo "Attaching disk to Kubernetes master node:"
  gcloud compute instances attach-disk --zone=$ZONE --disk=$DISK_NAME --device-name temp-data k8s-meteor-master
  echo "Safe formatting the disk:"
  gcloud compute ssh --zone=$ZONE k8s-meteor-master --command "sudo mkdir /mnt/tmp && sudo /usr/share/google/safe_format_and_mount /dev/disk/by-id/google-temp-data /mnt/tmp"
  echo "Detaching disk from master node:"
  gcloud compute instances detach-disk --zone=$ZONE --disk $DISK_NAME k8s-meteor-master
  echo "Disk is ready for containers to use."
fi


# Create pods and a service based on the JSON configuration
gcloud alpha container kubectl create -f mongo-pod.json
gcloud alpha container kubectl create -f mongo-service.json

echo "Waiting for Mongo to boot before creating the Meteor pods..."
while true; do
  MONGO_STATUS=`gcloud alpha container kubectl describe pods mongo | grep Status: | awk '{print $2}'`
  if [ "$MONGO_STATUS" == "Running" ]; then
    echo
    break
  fi
  printf "."
  sleep 2
done

# Sleep some extra time for the mongodb to start up
sleep 20

# Create our replication controller and service, also based on the JSON configuration
gcloud alpha container kubectl create -f meteor-controller.json
gcloud alpha container kubectl create -f meteor-service.json

# We need to configure the correct firewall rules or nothing will get through
gcloud compute firewall-rules create meteor-80 --allow=tcp:80 --target-tags k8s-meteor-node

echo
echo "Your Meteor app should now be available on the following ip address:"
gcloud compute forwarding-rules list k8s-meteor-default-meteor | grep k8s-meteor-default-meteor | awk '{print $3}'

