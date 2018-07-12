#!/bin/bash


# Source arguments from Ansible
# These are passed into the module as $1 with a key=value format
# Sourcing this file sets the variables defined in the Ansible module
# Note that variables that are unused in the module are silently ignored
source $1

# Helper function to fail the module with the specified error
# This can accept $@ in printf for the full error
# Be aware that this may expose more information than desired
# Can also just directly echo a failure with the same JSON structure and exit 1
fail_module() {
  printf '{"failed": true, "msg": "%s"}\n' "$1"
  exit 1
}

# Helper function to report changed true or false
# Can also just directly output '{"changed": trueorfalse}' and omit this function
changed() {
  printf '{"changed": %s}' "$1"
}

# Helper function to set a default value for a variable of the given name if it is not set through Ansible
default() {
  if [ -z "$1" ]
  then
    ${!1}=$2
  fi
}

# Helper function to fail if a variable of the given name is not set
require() {
  if [ -z "${!1}" ]
  then
    printf '{"failed": true, "msg": "%s must be defined"}' "$1"
    exit 1
  fi
}

# Require the arguments of "username", "password", and "table" to be set
for argument in "name description state"
do
  require $argument
done




trap 'fail_module "Error in line ${LINENO}"' ERR


findApp() {
  ttnctl applications list |  gawk -v name="^$name\\\s*$" 'BEGIN { FS="\t" }; $2 ~ name { print $3;exit 0}; ENDFILE { exit 1 }';
}

createApp() {
  ttnctl applications add $name "$description" --skip-register
}

msg=`findApp`


if findApp; then
  if [ $state == "present" ]; then
    changed=false
    msg="already exists"
  fi
  if [ $state == "registered" ]; then
    msg="hoi" 
  fi
  if [ $state == "unregistered" ];then
    msg="llhoi"
  fi
else
  if createApp; then
    changed=true
    msg="created application $name"
  else
    fail_module "Did you try to create an app with the same name of a previously deleted app? OUT: $out" 
  fi
fi


printf '{"changed": %s, "msg": "%s", "state": "%s"}\n' $changed "$msg" "$state"
