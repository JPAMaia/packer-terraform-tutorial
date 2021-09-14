#!/bin/bash
set -e

# Generate key
if [ ! -f key_tutorial ] || [ ! -f key_tutorial.pub ]; then
    ssh-keygen -q -f key_tutorial -N ""
fi
echo "=> Keys created !"
