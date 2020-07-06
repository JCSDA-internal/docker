#!/bin/bash
# © Copyright 2020-2020 UCAR
# This software is licensed under the terms of the Apache Licence Version 2.0 which can be obtained at
# http://www.apache.org/licenses/LICENSE-2.0.

#----------------------------------------------------------------------
# This script pulls the data files needed for the tutorials from S3
#----------------------------------------------------------------------

set -e

# when we have more than one tutorial, make this a list and loop over it
name=run-jedi

# Get git branch
branch=`git rev-parse --abbrev-ref HEAD`

# Download from s3
mkdir -p ${name}
cd ${name}
aws s3 cp s3://jedi-test-files/docker/${branch}/tutorials/${name}_Data.tar.gz ${name}_Data.tar.gz
aws s3 cp s3://jedi-test-files/docker/${branch}/tutorials/${name}_Data.tar.gz.md5 ${name}_Data.tar.gz.md5

# Check MD5 checksum
if [[ "$OSTYPE" == "darwin"* ]]; then
    md5 -r ${name}_Data.tar.gz > pull-checksum.md5
else
    md5sum ${name}_Data.tar.gz > pull-checksum.md5
fi

if [[ pull-checksum.md5 -ne ${name}_Data.tar.gz.md5 ]]; then
    echo "ERROR: in downloading ${name} Data files from S3"
    exit 1
fi

# Unpack
tar -xvzf ${name}_Data.tar.gz Data
rm ${name}_Data.tar.gz
rm ${name}_Data.tar.gz.md5
rm pull-checksum.md5
