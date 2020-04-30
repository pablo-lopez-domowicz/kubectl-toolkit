def AWS_ROLE="arn:aws:iam::404675694124:role/UAT_Administrator"
pipeline {
  agent {
        label 'mcpi-k8s-build'
    }
  parameters {
      choice(name: 'TARGET_CLUSTER',
          choices: 'pi-dev-eks\nperf-insights-stage-eks',
          description: 'The cluster to deploy to (develop, stage).')

      choice(name: 'TARGET_REGION',
          choices: 'us-east-1',
          description: 'The region to deploy to (only us-east-1 for now).')

      choice(name: 'TARGET_SERVICE',
              choices: 'mcpi-ui\naudience-service',
              description: 'Service to restart')
  }
  stages {
    stage('Setting vars') {
      steps {
        script {
          if(env.TARGET_CLUSTER.contains("dev")){
            AWS_ROLE="arn:aws:iam::927571343313:role/DevelopmentPerformanceInsights_Administrator"
          }
          sh """ echo "Cluster: ${TARGET_CLUSTER} - Region: ${TARGET_REGION} - Service: ${TARGET_SERVICE} -- AS: ${AWS_ROLE}" """
        }
      }
    }
    stage("Executing") {
      steps {
        script {
          sh """ echo "XYZ Cluster: ${TARGET_CLUSTER} - Region: ${TARGET_REGION} - Service: ${TARGET_SERVICE} -- AS: ${AWS_ROLE}" """

          withCredentials([
                        usernamePassword(credentialsId: 'perf_ins_okta_credentials', usernameVariable: 'OKTA_USERNAME', passwordVariable: 'OKTA_PASSWORD'),
                        usernamePassword(credentialsId: 'mcpi-artifactory-key-ro', usernameVariable: 'ARTIF_USERNAME', passwordVariable: 'ARTIF_PASSWORD')]) {
                            withEnv(["OKTA_USERNAME=${OKTA_USERNAME}", "OKTA_PASSWORD=${OKTA_PASSWORD}", "AWS_DEFAULT_REGION=${TARGET_REGION}"]) {
                                sh "gimme-aws-creds --role ${AWS_ROLE}"
                                sh "aws eks update-kubeconfig --name ${TARGET_CLUSTER}"
                                sh "./restartingService.sh" $TARGET_CLUSTER $TARGET_REGION $TARGET_SERVICE


            }
          }
        }
      }
    }
  }
}
