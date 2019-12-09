#!/bin/bash

# This script creates a tutorial container.
# Currently it only creates a Singularity container from
# a singularity recipe file but in the future we may
# also want to create Docker and Charliecloud containers.

echo "===================================================="
echo "==== Making Singularity container =================="
echo "===================================================="

# this creates an emply overlay file system that will be embedded in
# the sif file to make the container writable
rm -f jedi-overlay.img
dd if=/dev/zero of=jedi-overlay.img bs=1M count=1000 && mkfs.ext3 jedi-overlay.img

# build the container and add the overlay
sudo singularity build jedi-tutorial.sif Singularity.gnu-openmpi-tut
singularity siftool add --datatype 4 --partfs 2 --parttype 4 --partarch 2 --groupid 1 jedi-tutorial.sif jedi-overlay.img
