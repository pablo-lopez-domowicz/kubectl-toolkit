def AWS_ROLE="arn:aws:iam::927571343313:role/DevelopmentPerformanceInsights_Administrator"
def NAMESPACE="dev"
def TARGET_CLUSTER="pi-dev-eks"
pipeline {
  agent {
        label 'mcpi-k8s-build'
    }
  parameters {
      choice(name: 'FRIENDLY_CLUSTER',
          choices: 'DEV\nSTAGE',
          description: 'The cluster to deploy to (develop, stage).')

      choice(name: 'TARGET_REGION',
          choices: 'us-east-1',
          description: 'The region to deploy to (only us-east-1 for now).')

      choice(name: 'TARGET_SERVICE',
              choices: """mcpi-ui\n
                        aggregation-engine\n
                        audience\n
                        authentication\n
                        data-generator\n
                        data-location\n
                        dimension\n
                        provisioning\n
                        query-engine\n
                        ubx-audience-job\n
                        ubx-client\n
                        ubx-registration\n
                        unique-fact\n
                        warehouse-load\n
                        warehouse-metadata\n
                        workspace\n
                        workspace-template\n
                        """,
              description: 'Service to restart')
  }
  stages {
    stage('Setting vars') {
      steps {
        script {
          if(env.FRIENDLY_CLUSTER.contains("STAGE")){
            AWS_ROLE="arn:aws:iam::404675694124:role/UAT_Administrator"
            NAMESPACE="staging-istio"
            TARGET_CLUSTER="perf-insights-stage-eks"
          }
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
                                sh "bash -x restartService.sh ${TARGET_CLUSTER} ${TARGET_REGION} ${TARGET_SERVICE} ${NAMESPACE}" 
            }
          }
        }
      }
    }
  }
}
