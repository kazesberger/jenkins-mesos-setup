#!/bin/bash

export ANSIBLE_HOST_KEY_CHECKING=False

ansible-galaxy install -f -p roles/ -r requirements.yml

if [ -z "$2" ] ; then
    echo "usage: ./run.sh <inventory_file> <playbook> [<args> ...]"
    exit 1
fi

INVENTORY_FILE=$1
PLAYBOOK=$2
shift
shift

ansible-playbook -c paramiko --ask-sudo-pass --vault-password-file="/path/to/vault/passwordfile" -vvi $INVENTORY_FILE $PLAYBOOK.yml $@
