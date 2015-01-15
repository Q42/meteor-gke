Prerequisites
-------------

Follow the steps in [Before You Begin](https://cloud.google.com/container-engine/docs/before-you-begin) to create a project, enable billing, and activate the Container Engine and Compute Engine APIs. Don't forget to turn on the preview component!

Now you'll need to sign in to your Google account.

    gcloud auth login

Set the [Google Compute Engine zone](https://cloud.google.com/compute/docs/zones#available) and region to use. You won't need to specify the --zone flag in your gcloud commands once this is set.

    gcloud config set compute/zone europe-west1-c
    gcloud config set compute/region europe-west1



Build a container for your Meteor app
-------------------------------------

To be able to run your Meteor app on GKE you need to build a container for it first. To do that you need to install [Docker](https://www.docker.com) and get an account on [Docker Hub](https://hub.docker.com/). Once you have that you need to add 2 files to your Meteor project "Dockerfile" and ".dockerignore".

"Dockerfile" should contain this:

    FROM chees/meteor-kubernetes
    ENV ROOT_URL http://myawesomeapp.com

You should replace the ROOT_URL with the actual hostname of your app.

The .dockerignore file should contain this:

    .meteor/local
    packages/*/.build*

This tells docker to ignore the files on those directories when it's building your container.

You can see an example of a Dockerfile in our [meteor-gke-example](https://github.com/Q42/meteor-gke-example) project.

Now you can build your container by running something like this in your Meteor project directory:

    docker build -t chees/meteor-gke-example:1 .

Here you should replace "chees" with your own username on Docker Hub, "meteor-gke-example" with the name of your project and "1" with the version name of your build.

Push the container to your Docker hub account (replace the username and project with your own again):

    docker push chees/meteor-gke-example



Setting up the Google Container Engine cluster
----------------------------------------------

Now that you have containerized your Meteor app it's time to set up your cluster. Edit "meteor-controller.json" and make sure the "image" points to the container you just pushed to the Docker Hub.

Now setup the cluster:

    ./setup.sh

The script sets up a cluster with 3 nodes and a master, adds a Persistent Disk for Mongo, boots a Mongo pod, creates 3 pods for your Meteor container and finally sets up rules for the firewall and load balancer.

At the end of the script it will show you the IP address of the load balancer at which your app should be running. Note that it could still take a bit at that point for your Meteor containers to start.



Cleanup
-------

If you want to delete your cluster you can run:

    ./cleanup.sh

This will delete your whole cluster except the persistent disk for Mongo, so setting up the cluster again will get you back in the same state.

