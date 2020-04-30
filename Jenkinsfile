def AWS_ROLE="arn:aws:iam::404675694124:role/UAT_Administrator"
pipeline {
  agent any
  parameters {
      choice(name: 'CLUSTER',
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
          if(env.CLUSTER.contains("dev")){
            AWS_ROLE="arn:aws:iam::927571343313:role/DevelopmentPerformanceInsights_Administrator"
          }
          sh """ echo "Cluster: ${CLUSTER} - Region: ${TARGET_REGION} - Service: ${TARGET_SERVICE} -- AS: ${AWS_ROLE}" """
        }
      }
    }
    stage("Executing") {
      steps {
        script {
          // sh """ echo " ZZZZ Cluster: ${CLUSTER} - Region: ${TARGET_REGION} - Service: ${TARGET_SERVICE} -- AS: ${AWS_ROLE}" """
            echo "wtf"
        }
      }
    }
  }
}
