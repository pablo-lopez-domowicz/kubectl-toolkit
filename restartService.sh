#!/bin/bash

CLUSTER=$1
REGION=$2
SERVICE=$3
NAMESPACE=$4


gimme-aws-creds --role ${AWS_ROLE}
aws eks update-kubeconfig --name ${TARGET_CLUSTER}
kubectl get pods -n $NAMESPACE
kubectl get pods -n $NAMESPACE --no-headers=true | awk '/'$SERVICE'/{print $1}'| xargs  kubectl delete -n $NAMESPACE pod
