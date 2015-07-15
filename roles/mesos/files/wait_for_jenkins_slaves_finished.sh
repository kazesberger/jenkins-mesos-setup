#!/bin/sh

while test `/usr/bin/docker ps | grep jenkins-slave | wc -l` -gt 0 ; do echo "waiting for jenkins-slaves to stop..."; sleep 1s ; done
