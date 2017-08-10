#!/bin/bash
docker stop $(docker ps -a -q) > /dev/null 2>&1 &&  docker rm $(docker ps -a -q) &&  docker rmi $(docker images -a -q)
