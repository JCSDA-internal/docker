#!/bin/bash

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
if [ $# -ne 1 ]; then
   echo "Usage: "
   echo "./build_container.sh <container-name>"
   exit 1
fi

# Stop if anything goes wrong
set -e

export CNAME=${1:-"gnu-openmpi-dev"}


#------------------------------------------------------------------------
# Build image
# tag it as beta for testing purposes - this will be retagged as latest

docker image build --no-cache -f Dockerfile.${CNAME} -t jcsda/docker-${CNAME}:beta . 2>&1 | tee build.log

#------------------------------------------------------------------------
get_ans "Push to Docker Hub?"

if [[ $ans == y ]] ; then

    # save previous image in case something goes wrong
    docker pull jcsda/docker-$CNAME:latest
    docker tag jcsda/docker-$CNAME:latest jcsda/docker-$CNAME:revert
    docker push jcsda/docker-$CNAME:revert
    docker rmi jcsda/docker-$CNAME:latest

    # push new image and re-tag it with latest
    docker tag jcsda/docker-$CNAME:beta jcsda/docker-$CNAME:latest
    docker rmi jcsda/docker-$CNAME:beta
    docker push jcsda/docker-$CNAME:latest
    
fi
#------------------------------------------------------------------------
