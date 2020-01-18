#!/usr/bin/env bash

CLI_VERSION=0.18.0

if [ "${MSSQL_CLI_OFFICIAL_BUILD}" != "True" ]
    then
        time_stamp=$(date +%y%m%d%H%M)
        CLI_VERSION=$CLI_VERSION.dev$time_stamp
fi

if [ -z "$1" ]
  then
    echo "Argument should be path to local repo."
    exit 1
fi
local_repo=$1
source_dir=$local_repo

python3 dev_setup.py

# create .deb and move to debian_output folder
dpkg-buildpackage -us -uc
deb_file=$local_repo/../mssql-cli_$CLI_VERSION-${CLI_VERSION_REVISION:=1}_all.deb

# clean up old build output
rm -rf $source_dir/../debian_output

# Create a second copy for latest dev version to be used by homepage.
cp $deb_file $source_dir/../debian_output
cp $deb_file $source_dir/../debian_output/mssql-cli-dev-latest.deb
echo "The archive has also been outputted to $source_dir/../debian_output"
