pipeline {
  agent any
  parameters {
      choice(name: 'CLUSTER',
          choices: 'pi-dev-eks\nperf-insights-stage-eks',
          description: 'The cluster to deploy to (develop, stage).')

      choice(name: 'TARGET_REGION',
          choices: 'us-east-1',
          description: 'The region to deploy to (only us-east-1 for now).')


  }
  stages {
    stage('Starting') {
      steps {
        sh ./restartService.sh
        echo "${env.TARGET_REGION} ${env.TARGET_ENVIRONMENT}"
        echo "Done"
      }
    }
  }
}
