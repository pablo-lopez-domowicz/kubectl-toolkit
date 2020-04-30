pipeline {
  agent any
  parameters {
      choice(name: 'TARGET_ENVIRONMENT',
          choices: 'develop\nstage',
          defaultValue: 'develop',
          description: 'The environment to deploy to (develop, stage).')

      // string(name: 'ENVIRONMENT', defaultValue: "${env.BRANCH_NAME.replaceAll('^origin/', '').replaceAll('/', '-')}-SNAPSHOT",
      //         description: "Development version to use in maven artifacts and in image names.")

      choice(name: 'TARGET_REGION',
          choices: 'us-east-1',
          defaultValue: 'us-east-1',
          description: 'The region to deploy to (only us-east-1 for now).')


  }
  stages {
    stage('Starting') {
      steps {
        echo "${env.TARGET_REGION} ${env.TARGET_ENVIRONMENT}"
        echo "Done"
      }
    }
  }
}
