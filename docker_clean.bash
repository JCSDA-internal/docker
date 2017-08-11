#!/bin/bash
docker stop $(docker ps -a -q) > /dev/null 2>&1 
docker rm $(docker ps -a -q) > /dev/null 2>&1
docker rmi $(docker images -a -q) > /dev/null 2>&1
# no matter what's the return code, avoid it !
echo $?
