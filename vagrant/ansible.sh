#!/bin/bash
set -e

# Install Ansible
pip3 install netaddr==0.8.0
pip3 install ansible==4.0.0

# Configure Ansible
mkdir -p /etc/ansible
cp /vagrant/vagrant/ansible.cfg /etc/ansible/ansible.cfg
cp /vagrant/vagrant/.vault_pass /etc/ansible/.vault_pass
chmod -x /etc/ansible/ansible.cfg /etc/ansible/.vault_pass
