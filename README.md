Meteor on Container Engine
=============

## v0.1

This is an initial attempt at a deploy script for running Meteor on Google Container Engine.

## Background

At [Q42](http://q42.com) we view Cloud Platform and Meteor as core technologies that enable us to focus on building great products and apps instead of managing servers and doing client side dev ops. So it made sense for us to explore combining them, not in the least because Meteor doesn't yet have a "go to" scalable hosting solution. As we're working on a startup of our own, it seemed like a good idea to explore this.

## Getting started

This repository represents our first exploration of the shell scripts required to deploy your Meteor app to Container Engine. It takes care of basic configuration of your cluster, sets up pods and a replication controller and initialises replicas. We use a persistent disk for MongoDB, which means that even if you tear down the cluster, your data remains safe. And by binding sesson affinity to your client's IP, you should get a nice sticky session.

To get started, read [the documentation](documentation.md). We're accepting any issues you run into and any pull requests you think are relevant and would love to hear from you at @q42 on Twitter!
