#!/bin/bash
# © Copyright 2021 UCAR
# This software is licensed under the terms of the Apache Licence Version 2.0 which can be obtained at
# http://www.apache.org/licenses/LICENSE-2.0.

# This is the build script for the ci container.  To build the dev container, simply run
#
# docker build -f Dockerfile.jopa-gnu-ompi-dev -t jcsda/jopa-gnu-ompi-dev:latest context

# Stop if anything goes wrong
set -e

export TAG=${1:-"beta"}
KEY=$HOME/.ssh/githubnew_rsa

docker build --secret id=pwd,src=./credentials/mosrs --ssh github_ssh_key=${KEY} --progress=plain -f Dockerfile.jopa-gnu-ompi-ci -t jopa-gnu-ompi-ci:$TAG context
