#!/bin/bash
# © Copyright 2020-2020 UCAR
# This software is licensed under the terms of the Apache Licence Version 2.0 which can be obtained at
# http://www.apache.org/licenses/LICENSE-2.0.


#------------------------------------------------------------------------
if [ $# -ne 1 ]; then
   echo "Usage: "
   echo "./build_container.sh <container-name> <tag>"
   exit 1
fi

# Stop if anything goes wrong
set -e

export CNAME=${1:-"gnu-openmpi-dev"}
export TAG=${2:-"beta"}

#------------------------------------------------------------------------
# Build image
# tag it as beta for testing purposes - this will be retagged as latest

docker image build --no-cache -f Dockerfile.${CNAME} -t jcsda/docker-${CNAME}:${TAG} . 2>&1 | tee build.log

#------------------------------------------------------------------------
