pipeline {
    agent any

    environment {
        AWS_REGION      = 'ap-south-1'
        TF_DIR          = '.'
        S3_BUCKET       = 'raghuterraform'
        DYNAMODB_TABLE  = 'raghuterraform-lock'
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Bootstrap S3 & DynamoDB') {
            steps {
                sh '''
                    # Create S3 bucket if not exists
                    aws s3api head-bucket --bucket $S3_BUCKET 2>/dev/null || \
                    aws s3api create-bucket \
                        --bucket $S3_BUCKET \
                        --region $AWS_REGION \
                        --create-bucket-configuration LocationConstraint=$AWS_REGION

                    aws s3api put-bucket-versioning \
                        --bucket $S3_BUCKET \
                        --versioning-configuration Status=Enabled

                    # Create DynamoDB table if not exists
                    aws dynamodb describe-table --table-name $DYNAMODB_TABLE --region $AWS_REGION 2>/dev/null || \
                    aws dynamodb create-table \
                        --table-name $DYNAMODB_TABLE \
                        --attribute-definitions AttributeName=LockID,AttributeType=S \
                        --key-schema AttributeName=LockID,KeyType=HASH \
                        --billing-mode PAY_PER_REQUEST \
                        --region $AWS_REGION
                '''
            }
        }

        stage('Terraform Init') {
            steps {
                dir("${TF_DIR}") {
                    sh 'terraform init'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                dir("${TF_DIR}") {
                    sh 'terraform plan -out=tfplan'
                }
            }
        }

        stage('Approval') {
            steps {
                input message: 'Review the plan above. Approve to apply?', ok: 'Apply'
            }
        }

        stage('Terraform Apply') {
            steps {
                dir("${TF_DIR}") {
                    sh 'terraform apply -auto-approve tfplan'
                }
            }
        }

        stage('Update kubeconfig') {
            steps {
                sh '''
                    CLUSTER=$(aws eks list-clusters --region $AWS_REGION --query "clusters[?contains(@,'task-management')]" --output text)
                    aws eks update-kubeconfig --region $AWS_REGION --name $CLUSTER
                '''
            }
        }
    }

    post {
        failure {
            echo 'Infrastructure pipeline failed!'
        }
        success {
            echo 'Infrastructure provisioned successfully!'
        }
    }
}
