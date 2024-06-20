pipeline{
    agent any
    environment{
        AWS_ACCESS_KEY_ID=credentials('Access_key_ID')
        AWS_SECRET_ACCESS_KEY=credentials('Secret_Key_ID')
        AWS_DEFAULT_REGION="US-EAST-1"
    }
    stages{
        stage('git checkout'){
            steps{
                script{
                    
                    checkout scmGit(branches: [[name: '*/master']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/Raviteja3399/webhooksproject.git']])
                }
                
            }
        }
        stage('terraform init'){
            steps{
                script{
                    dir('Webhook'){
                        sh 'terraform init'
                    }
                }
                
            }
        }
        stage('terraform plan'){
            steps{
                script{
                    dir('Webhook'){
                        sh 'terraform plan'
                    }
                }
                
            }
        }
        stage('terraform apply'){
            steps{
                script{
                    dir('Webhook'){
                        sh 'terraform apply -auto-approve'
                    }
                }
                
            }
        }
    }
}
