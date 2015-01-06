Prerequisites
-------------

Follow the steps in [Before You Begin](https://cloud.google.com/container-engine/docs/before-you-begin) to create a project, enable billing, and activate the Container Engine and Compute Engine APIs. Don't forget to turn on the preview component!

Now you'll need to sign in to your Google account.

    gcloud auth login

Set the [Google Compute Engine zone](https://cloud.google.com/compute/docs/zones#available) and region to use. You won't need to specify the --zone flag in your gcloud commands once this is set.

    gcloud config set compute/zone europe-west1-c
    gcloud config set compute/region europe-west1

### TODO: just run createcluster.sh
- and create a disk
- create a docker container from your meteor app
- publish the container
- 




Create a Container Engine cluster
---------------------------------

Create a cluster named `meteor`:

    gcloud preview container clusters create meteor



Setup Mongo
-----------

Create a Mongo pod:

    gcloud preview container pods create --config-file mongo-pod.json

Verify that it is running:

    gcloud preview container pods list

After a couple of minutes the Status should be "Running".

Create a Mongo service:

    gcloud preview container services create --config-file mongo-service.json



Build your container
--------------------

TODO



Setup Meteor
------------

Create a replication controller for your Meteor container:

    gcloud preview container replicationcontrollers create --config-file meteor-controller.json

Create a Meteor service:

    gcloud preview container services create --config-file meteor-service.json

Open the firewall:

    gcloud compute firewall-rules create meteor-80 --allow=tcp:80 --target-tags k8s-meteor-node

Get the external IP address:

    gcloud compute forwarding-rules list



Cleanup
-------

Delete the cluster:

    gcloud preview container clusters delete meteor

Delete the loadbalancer:

    gcloud compute forwarding-rules delete meteor
    gcloud compute target-pools delete meteor

Delete the firewall rule:

    gcloud compute firewall-rules delete meteor-80

