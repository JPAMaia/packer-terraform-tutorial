#!/bin/bash
set -e

# Update repos
yum install -y epel-release-7
yum install -y yum-utils-1.1.31
yum update -y

# Install base packages
yum install -y \
    htop-2.2.0 \
    vim-enhanced-2:7.4.629 \
    curl-7.29.0 \
    wget-1.14 \
    gcc-4.8.5 \
    unzip-6.0 \
    dos2unix-6.0.3 \
    jq-1.6

# Install Python 3.6
yum install -y \
    python3-3.6.8 \
    python3-pip-9.0.3 \
    python3-setuptools-39.2.0 \
    python3-devel-3.6.8 \
    libffi-devel-3.0.13
pip3 install --upgrade \
    pip==21.2.4 \
    wheel==0.36.2
cat >/etc/profile.d/aliases.sh <<EOF
alias python=python3
alias pip=pip3
EOF
chmod +x /etc/profile.d/aliases.sh

# Install AWS CLI
if [ ! -f "/usr/local/bin/aws" ]; then
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip -o awscliv2.zip -d $HOME/ > /dev/null
    ~/aws/install > /var/log/aws-cli_out.log
fi

# Configure AWS CLI
AWS_ID=$(jq '."aws-user"' /vagrant/vagrant/conf.json | sed 's/"//g')
AWS_SECRET=$(jq '."aws-secret"' /vagrant/vagrant/conf.json | sed 's/"//g')
mkdir -p $HOME/.aws
cat >$HOME/.aws/credentials <<EOF
[default]
aws_access_key_id=$AWS_ID
aws_secret_access_key=$AWS_SECRET
EOF
cat >$HOME/.aws/config <<EOF
[default]
region=eu-west-1
output=json
EOF
mkdir -p /home/vagrant/.aws/
cp $HOME/.aws/credentials /home/vagrant/.aws/
cp $HOME/.aws/config /home/vagrant/.aws/
chown -R vagrant:vagrant /home/vagrant/.aws/
