#!/bin/bash

CLUSTER=$1
REGION=$2
SERVICE=$3

AWS_ROLE="arn:aws:iam::404675694124:role/UAT_Administrator"
if [[ "$CLUSTER" == *"dev"* ]]; then
  AWS_ROLE="arn:aws:iam::927571343313:role/DevelopmentPerformanceInsights_Administrator"
fi

echo "**Restarting** Cluster: $CLUSTER - Region: $REGION - Service: $SERVICE -- AS: $AWS_ROLE"
withCredentials([
    usernamePassword(credentialsId: 'perf_ins_okta_credentials', usernameVariable: 'OKTA_USERNAME', passwordVariable: 'OKTA_PASSWORD'),
    usernamePassword(credentialsId: 'mcpi-artifactory-key-ro', usernameVariable: 'ARTIF_USERNAME', passwordVariable: 'ARTIF_PASSWORD')]) {
        withEnv(["OKTA_USERNAME=${OKTA_USERNAME}", "OKTA_PASSWORD=${OKTA_PASSWORD}", "AWS_DEFAULT_REGION=us-east-1"]) {
            gimme-aws-creds --role $AWS_ROLE
            aws eks update-kubeconfig --name $CLUSTER
}

# aws eks update-kubeconfig --name $CLUSTER

# aws eks --region $REGION update-kubeconfig --name $CLUSTER
#
# kubectl get pods -n dev
