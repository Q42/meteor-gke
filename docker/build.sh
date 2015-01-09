#!/bin/bash

echo -n "Which version do you want to give this build?: "
read VERSION

cd ../meteor-gke-example
meteor build ../build --architecture os.linux.x86_64
cd ../build
tar zxf meteor-gke-example.tar.gz
cd bundle
cp ../../docker/Dockerfile .

echo 'version: '
echo "$VERSION"
echo
docker build -t="chees/meteor-testje:$VERSION" .
docker push chees/meteor-testje
