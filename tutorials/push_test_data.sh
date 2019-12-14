#!/bin/sh
#----------------------------------------------------------------------
# This script pushes the data files needed for the tutorials to S3
#----------------------------------------------------------------------

# when we have more than one tutorial, make this a list and loop over it
name=run-jedi

# Archive
cd $name
tar -cvzf ${name}_Data.tar.gz Data

# Compute MD5 checksum
if [[ "$OSTYPE" == "darwin"* ]]; then
    md5 -r ${name}_Data.tar.gz > ${name}_Data.tar.gz.md5
else
    md5sum ${name}_Data.tar.gz > ${name}_Data.tar.gz.md5
fi

# Get git branch
branch=`git rev-parse --abbrev-ref HEAD`

# Send to S3
aws s3 cp ${name}_Data.tar.gz s3://jedi-test-files/docker/${branch}/tutorials/${name}_Data.tar.gz --grants read=uri=http://acs.amazonaws.com/groups/global/AllUsers
aws s3 cp ${name}_Data.tar.gz.md5 s3://jedi-test-files/docker/${branch}/tutorials/${name}_Data.tar.gz.md5 --grants read=uri=http://acs.amazonaws.com/groups/global/AllUsers
