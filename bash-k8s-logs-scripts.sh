#!/bin/bash

# Get current date
today=Logs@$(date +"%F#%T")

# Get the namespace name
namespace=zenith

# Create a directory to store the logs with the current date
mkdir -p $today

# Get a list of all deployments in the specified namespace
deployments=$(kubectl get deployments -n $namespace -o jsonpath=‘{.items[*].metadata.name}‘)
pods=$(kubectl get pods -n $namespace -o jsonpath=‘{.items[*].metadata.name}‘)

# Loop through the pods
for pod in $pods; do
  
  # Get the logs for the pods and save to a file
  kubectl logs $pod --all-containers=true -n $namespace > $today/$pod.log 2>>$today/err.log

done