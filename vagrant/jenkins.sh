#!/bin/bash
set -e

JENKINS_URL="http://127.0.0.1:8080"

# Install Jenkins
if [ ! -d /var/lib/jenkins ]; then
    wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
    rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
    yum install -y \
        jenkins-2.289.3 \
        java-1.8.0-openjdk-headless-1.8.0.292.b10 \
        java-1.8.0-openjdk-devel-1.8.0.292.b10
    systemctl daemon-reload
    systemctl start jenkins && systemctl enable jenkins
    i=0
    while [[ $(curl -s -w "%{http_code}" $JENKINS_URL/jnlpJars/jenkins-cli.jar -o /dev/null) != "200" ]]; do
        echo "=> Jenkins is starting ... ${i}s"
        sleep 1
        i=$(( i+1 ))
    done
    echo "=> Jenkins started!"
fi

# Configuring Jenkins
if [ ! -f $HOME/jenkins-cli.jar ]; then
    echo "admin:$(sudo cat /var/lib/jenkins/secrets/initialAdminPassword)" > $HOME/.jenkins-cli
    wget $JENKINS_URL/jnlpJars/jenkins-cli.jar
    mv jenkins-cli.jar $HOME/jenkins-cli.jar
fi
java -jar $HOME/jenkins-cli.jar -s $JENKINS_URL -auth @$HOME/.jenkins-cli install-plugin \
    cloudbees-folder:6.15 \
    antisamy-markup-formatter:2.1 \
    build-timeout:1.20 \
    credentials-binding:1.24 \
    timestamper:1.13 \
    ws-cleanup:0.39 \
    ant:1.11 \
    gradle:1.36 \
    workflow-aggregator:2.6 \
    pipeline-github-lib:1.0 \
    pipeline-stage-view:2.19 \
    git:4.7.1 \
    ssh-slaves:1.31.5 \
    matrix-auth:2.6.7 \
    pam-auth:1.6 \
    ldap:2.7 \
    email-ext:2.82 \
    mailer:1.34 \
    terraform:1.0.10 \
    ansible:1.1 \
    aws-credentials:1.29 \
    ansicolor:1.0.0 \
    blueocean:1.24.6 \
    generic-webhook-trigger:1.72
java -jar $HOME/jenkins-cli.jar -s $JENKINS_URL -auth @$HOME/.jenkins-cli restart
i=0
while [[ $(curl -s -w "%{http_code}" $JENKINS_URL/jnlpJars/jenkins-cli.jar -o /dev/null) != "200" ]]; do
    echo "=> Jenkins is restarting ... ${i}s"
    sleep 1
    i=$(( i+1 ))
done
echo "=> Jenkins restarted!"
