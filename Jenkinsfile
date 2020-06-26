library "jenkinsci-unstashParam-library"

def config = [
    dev_us_east_1: [ 
        awsRegion: 'us-east-1',
        awsRole: 'arn:aws:iam::927571343313:role/DevelopmentPerformanceInsights_Administrator',
        eksCluster: 'pi-dev-eks',
        k8sNamespace: 'dev'
    ],
    staging_us_east_1: [ 
        awsRegion: 'us-east-1',
        awsRole: 'arn:aws:iam::404675694124:role/UAT_Administrator',
        eksCluster: 'perf-insights-stage-eks',
        k8sNamespace: 'staging-istio'
    ],
    prod_us_east_1: [ 
        awsRegion: 'us-east-1',
        awsRole: 'arn:aws:iam::379236661308:role/ProductionShared_Administrator',
        eksCluster: 'perf-insights-prod-eks',
        k8sNamespace: 'prod'
    ],
    prod_ap_south_1: [ 
        awsRegion: 'ap-south-1',
        awsRole: 'arn:aws:iam::379236661308:role/ProductionShared_Administrator',
        eksCluster: 'perf-insights-prod-eks',
        k8sNamespace: 'prod'
    ],
]

pipeline {
    agent {
        label 'mcpi-k8s-build'
    }

    options {        
        buildDiscarder(logRotator(numToKeepStr: '10'))
        ansiColor('xterm')
        timeout(time: 40, unit: 'MINUTES')
    }

    parameters {
        choice(name: 'ENV', choices: ['', 'dev_us_east_1', 'staging_us_east_1', 'prod_us_east_1', 'prod_ap_south_1'], description: 'Environment for run')
        string(name: 'REDIS_NAME', defaultValue: 'tenant:658:audience:1111:2020.06.25.11.41', description: 'RedisName for this run (ex tenant:658:audience:1111:2020.06.25.11.41)')
        string(name: 'JWT', defaultValue: 'eyJhbGciOiJSUzI1NiIsImtpZCI6ImltYy1hcGkifQ.eyJpc3MiOiJSVFAgQVBJIiwiaWF0IjoxNTkzMTkzNTgyLCJqdGkiOiJKZ2EtZGhENUp3MkVNYWFnNE50TWpBIiwib3JnYW5pemF0aW9uSWQiOiI2NTgiLCJ0aW1lem9uZSI6IkFtZXJpY2EvTmV3X1lvcmsiLCJ1c2VyTmFtZSI6IjY1OCIsInVzZXJJZCI6IjY1OCIsImN1bHR1cmFsTG9jYWxlIjoiZW5fVVMiLCJleHAiOjE1OTMyMjIzODJ9.o3b9Q3uhskK4IzU_rxgL3-B_w2KkpYWD_d0f_nqxsvB5krG_nhpoYDJImyDKWkJOi1iCLqcunDTeHyMzIvhUFjmUEK374ntBq8U4PoLvEs1XzD7s_1vUISUyMuUwMvrRuhA52j-SFqvZHjqjVGTnLkIeKfXEtNsKR2f6btzH2azIPDFLz5x_nyaDoXfBv798sXXuL6qAVNttcYmdfa-uA3SF3aUNOsFrPtOdXpOCLa43QN0fATA0y4LY0Rnvo6iP-n-jfpoWjwjo_0jrH7hkIV5hAwiHi_o8VCFWvJrrcA1qCU0bMslaaa09UXY-oSvZtXlV7Ya-ulNGys6qgt_Edg', description: 'JWT to use for this run - NO need for BEARER')
        file(name: 'INPUT_FILE', description:'File of clientIds to scan for')
    }

    environment {
        AWS_DEFAULT_REGION="${config.get(env.ENV)['awsRegion']}"
        EKS_NAMESPACE="${config.get(env.ENV)['k8sNamespace']}"
        CONTACT_ID="${env.CONTACT_ID}"
        REDIS_NAME="${env.REDIS_NAME}"
        // Add okta credentials for gimme-aws-creds auth 
        OKTA = credentials('perf_ins_okta_credentials')
        OKTA_USERNAME="${OKTA_USR}"
        OKTA_PASSWORD="${OKTA_PSW}"        
    }

    stages {
        stage('Find clientIds') {
            steps {
                script {
                    // Authorize to aws account with okta creds
                    sh "gimme-aws-creds --role ${config.get(env.ENV)['awsRole']}"
                    // Authorzie to kubectl
                    sh "aws eks update-kubeconfig --name ${config.get(env.ENV)['eksCluster']}"

                    sh "bash -x findClientId.sh"
                }
            }
        }
    stage("Post build") {
      steps {
        script {
          publishHTML (target : [
            allowMissing: false,
            alwaysLinkToLastBuild: true,
            keepAll: true,
            reportDir: '',
            reportFiles: 'output.txt',
            reportName: 'jobResponse',
            reportTitles: 'jobResponse'])
        }
      }
    }
    }

}
