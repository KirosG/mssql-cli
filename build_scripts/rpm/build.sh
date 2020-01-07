#!/usr/bin/env bash

if [ -z "$1" ]
  then
    echo "Argument should be path to local repo."
    exit 1
fi

export REPO_PATH=$1

# install dependencies
sudo yum repolist
sudo yum update
sudo yum install libffi-devel openssl-devel 

# Create virtualenv
deactivate
rm -rf ${REPO_PATH}/python_env
virtualenv ${REPO_PATH}/python_env --python=python3
source ${REPO_PATH}/python_env/bin/activate

# Build mssql-cli wheel from source.
${REPO_PATH}/python_env/bin/python3 ${REPO_PATH}/dev_setup.py
${REPO_PATH}/python_env/bin/python3 ${REPO_PATH}/build.py build

# Clean output dir.
rm -rf ~/rpmbuild
rm -rf ${REPO_PATH}/../rpm_output

rpmbuild -v -bb --clean build_scripts/rpm/mssql-cli.spec

# Copy build artifact to output dir.
mkdir ${REPO_PATH}/../rpm_output
cp ~/rpmbuild/RPMS/x86_64/*.rpm ${REPO_PATH}/../rpm_output
# Create a second copy for latest dev version to be used by homepage.
cp ~/rpmbuild/RPMS/x86_64/*.rpm ${REPO_PATH}/../rpm_output/mssql-cli-dev-latest.rpm
echo "The archive has also been outputted to ${REPO_PATH}/../rpm_output"

deactivate