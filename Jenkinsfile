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
    		string(name: 'CONTACT_ID', defaultValue: '', description: 'Contact id for this run')
    		string(name: 'REDIS_NAME', defaultValue: '', description: 'RedisName for this run')
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
        stage('Audience') {
            steps {
                script {
                    // Authorize to aws account with okta creds
                    sh "gimme-aws-creds --role ${config.get(env.ENV)['awsRole']}"
                    
                    // Authorzie to kubectl
                    sh "aws eks update-kubeconfig --name ${config.get(env.ENV)['eksCluster']}"

                    sh '''#!/bin/bash
                            audience_pod=$(kubectl -n $EKS_NAMESPACE get po -o=name | grep -m 1 audience | sed 's/^.\\{4\\}//')
                                    if [ -z "$audience_pod" ]
                                    then
                                          echo "Cannot find any audience pods in namespace $EKS_NAMESPACE"
                                          exit 1
                                    fi  
                						echo "Contact ID Used: "$CONTACT_ID
                						echo "RedisName Used: "$REDIS_NAME
                            kubectl -n $EKS_NAMESPACE -c audience exec $audience_pod \
                              -- curl -s "http://localhost:8080/private/audience/members?redisName=${REDIS_NAME}&contactId=${CONTACT_ID}" \
                              --header 'Content-Type:application/json' > response.json 
                        '''
                }
            }
        }
    }

}
