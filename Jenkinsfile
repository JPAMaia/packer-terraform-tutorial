pipeline {
    agent any

    environment {
        PATH = "$PATH:/usr/bin:/usr/local/bin"
        WORKDIR = "/vagrant"
        PACKER = "/usr/bin/packer"
        TERRAFORM = "/usr/bin/terraform"
        ANSIBLE_ROLES = "$WORKDIR/ansible/roles"
        ANSIBLE_PLAYBOOKS = "$WORKDIR/ansible/playbooks"
    }

    parameters {
        string(name: "instanceType", defaultValue: "t3.small", description: "Instance Type")
    }

    stages {
        stage("INIT") {
            steps {
                echo "Starting ..."
                sh "$TERRAFORM --version"
                sh "$PACKER --version"
                sh "ansible --version"
            }
        }

        stage("PACKER") {
            steps {
                script {
                    withCredentials([
                        aws(credentialsId: 'aws-creds', accessKeyVariable: 'AWS_ACCESS_KEY_ID', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')
                    ]) {
                        def cmds = ["init", "fmt", "validate", "build"]
                        dir("$WORKDIR/packer") {
                            cmds.each { cmd ->
                                sh "$PACKER $cmd -var instance_type=$instanceType ."
                            }
                        }
                    }
                }
            }
        }

        stage("TERRAFORM") {
            steps {
                script {
                    withCredentials([
                        aws(credentialsId: 'aws-creds', accessKeyVariable: 'AWS_ACCESS_KEY_ID', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')
                    ]) {
                        dir("$WORKDIR/terraform") {
                            def key_exist = sh(script: "ls $WORKDIR/terraform/key_tutorial", returnStatus: true)
                            if (key_exist == 1) {
                                sh "sh $WORKDIR/terraform/key_pair.sh"
                            }
                            sh "$TERRAFORM init"
                            sh "$TERRAFORM fmt"
                            sh "$TERRAFORM validate"
                            sh "$TERRAFORM plan -var instance_type=$instanceType"
                            sh "$TERRAFORM apply -auto-approve -var instance_type=$instanceType"
                            sh "$TERRAFORM show"
                        }
                    }
                }
            }
        }
    }
}