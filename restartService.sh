#!/bin/bash

gimme-aws-creds --role ${AWS_ROLE}

aws eks update-kubeconfig --name ${TARGET_CLUSTER}

kubectl get pods -n $NAMESPACE

kubectl get pods -n $NAMESPACE --no-headers=true | awk '/'$TARGET_SERVICE'/{print $1}'| xargs  kubectl delete -n $NAMESPACE pod
