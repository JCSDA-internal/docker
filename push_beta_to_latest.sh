#!/bin/bash
# © Copyright 2020-2020 UCAR
# This software is licensed under the terms of the Apache Licence Version 2.0 which can be obtained at
# http://www.apache.org/licenses/LICENSE-2.0.


#
# push_beta_to_latest.sh - Make test version of Docker image the latest on Docker Hub
#
# Useage:
# push_beta_to_latest.sh <name> <tag>
#
# <name> - name of image to build in format <compiler>-<mpi>-<type>
#           where <type> is dev (development) or app (application)
#           Default: gnu-openmpi-dev
#
# <tag> - optional tag for input docker image (default beta)
#
#------------------------------------------------------------------------
function get_ans {
    ans=''
    while [[ $ans != y ]] && [[ $ans != n ]]; do
      echo $1
      read ans < /dev/stdin
      if [[ $ans != y ]] && [[ $ans != n ]]; then echo "You must enter y or n"; fi
    done
}

#------------------------------------------------------------------------
if [[ $# -lt 1 ]]; then
   echo "usage: push_beta_to_latest <name> [<tag>]"
   exit 1
fi

CNAME=${1:-"gnu-openmpi-dev"}
TAG=${2:-"beta"}

#------------------------------------------------------------------------
get_ans "Push to Docker Hub and back up?"

if [[ $ans == y ]] ; then

    # save previous image in case something goes wrong
    docker pull jcsda/docker-$CNAME:latest
    docker tag jcsda/docker-$CNAME:latest jcsda/docker-$CNAME:revert
    docker push jcsda/docker-$CNAME:revert
    docker rmi jcsda/docker-$CNAME:latest

    # push new image and re-tag it with latest
    docker tag jcsda/docker-$CNAME:${TAG} jcsda/docker-$CNAME:latest
    docker rmi jcsda/docker-$CNAME:${TAG}
    docker push jcsda/docker-$CNAME:latest

fi
    #------------------------------------------------------------------------
