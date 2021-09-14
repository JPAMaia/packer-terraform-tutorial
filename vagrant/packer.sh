#!/bin/bash
set -e

# Install Packer
yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
yum install -y packer-1.7.2
