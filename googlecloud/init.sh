#!/bin/bash
password="jh76fht568"
repo="https://github.com/rea-cruitment/simple-sinatra-app.git"

echo " Get the project name: "
project=`gcloud config list project | grep project | awk  -F'=' '{print $2}' | sed 's/ //g  '`
echo "Project name is :${project}"

echo "Clonning the Sinatra Repo .."
rm -Rf ../docker/sinatra
git clone ${repo} ../docker/sinatra

echo " Build the docker image: " 
docker build -t gcr.io/${project}/sinatra-webapp:v1 ../docker/

echo " Push the image to Google Cloud Container Registry : "
gcloud docker push gcr.io/${project}/sinatra-webapp:v1

echo " Create the Cluster : "
gcloud container clusters create sinatra-webapp --disk-size 10 --num-nodes 2 --zone asia-east1-a --password ${password} --username admin

echo " Create the Pod: "
kubectl run sinatra-node --image=gcr.io/${project}/sinatra-webapp:v1 --port=80

echo " Get the created Pods: "
kubectl get pods

echo " Expose Cluster to external traffic: "
kubectl expose deployment sinatra-node --type="LoadBalancer"
exit 1

echo " Get the External IP (it might take 5 minutes or so..) : "
while :; do clear;  kubectl get services sinatra-node ; sleep 2; done
