#!/bin/bash

#
# WHY and HOW?
# * Use this with --vault-password-file=./askpass.sh on Jenkins
# * Inject a passowrd variable with the vault password into the build (for example $THE_PASSWORD_VARIABLE)
# * Password (variable) has to be encrypted and masked!    
# * call ansible-playbook ... << EOF\n$THE_PASSWORD_VARIABLE\n << EOF
#

read PASS
echo $PASS

