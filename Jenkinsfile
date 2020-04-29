pipeline {
  agent any
  parameters {
      choice(name: 'TARGET_ENVIRONMENT',
          choices: 'develop\nstage',
          description: 'The environment to deploy to (develop, stage).')

      // string(name: 'ENVIRONMENT', defaultValue: "${env.BRANCH_NAME.replaceAll('^origin/', '').replaceAll('/', '-')}-SNAPSHOT",
      //         description: "Development version to use in maven artifacts and in image names.")

      choice(name: 'REGION',
          choices: 'us-east-1',
          description: 'The region to deploy to (only us-east-1 for now).')


  }
  stages {
    stage('Starting') {
      steps {
        echo "Hi again"
      }
    }
  }
}
