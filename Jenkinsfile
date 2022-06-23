pipeline {
  agent {
    docker {
      image 'fiifikrampah/aws_infra_setup:latest'
      args '-v /etc/passwd:/etc/passwd -v /etc/group:/etc/group'
      args '-u root:root -v /var/lib/jenkins/workspace/myworkspace:/tmp/' + ' -v /var/lib/jenkins/.ssh:/root/.ssh'
    }
  }
  stages {
    stage('Init') {
      steps {
        sh 'packer init packer/'
      }
    }
    stage('Create Packer AMI') {
        steps {
          withCredentials([
            usernamePassword(credentialsId: 'aws_credentials_id', passwordVariable: 'AWS_SECRET_ACCESS_KEY', usernameVariable: 'AWS_ACCESS_KEY_ID')
          ]) {
            sh 'packer build -var aws_access_key=${AWS_ACCESS_KEY_ID} -var aws_secret_key=${AWS_SECRET_ACCESS_KEY} packer/'
        }
      }
    }
    stage('Deploy Infrastructure') {
      steps {
          withCredentials([
            usernamePassword(credentialsId: 'aws_credentials_id', passwordVariable: 'AWS_SECRET_ACCESS_KEY', usernameVariable: 'AWS_ACCESS_KEY_ID')
          ]) {
            sh '''
               cd terraform
               terraform init
               terraform apply -auto-approve -var aws_access_key=${AWS_ACCESS_KEY_ID} -var aws_secret_key=${AWS_SECRET_ACCESS_KEY}
            '''
        }
      }
    }
  }
}
