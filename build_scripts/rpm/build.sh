#!/usr/bin/env bash

if [ -z "$1" ]
  then
    echo "Argument should be path to local repo."
    exit 1
fi

export REPO_PATH=$1

sudo yum repolist
sudo yum update
sudo yum install -y gcc git rpm-build rpm-devel rpmlint make bash coreutils diffutils patch rpmdevtools python libffi-devel python-devel openssl-devel libunwind

# Clean output dir.
rm -rf ~/rpmbuild
rm -rf ${REPO_PATH}/../rpm_output
rm -rf ${REPO_PATH}/python_env

# create virtualenv
deactivate
virtualenv ${REPO_PATH}/python_env --python=python3
source ${REPO_PATH}/python_env/bin/activate

rpmbuild -v -bb --clean ${REPO_PATH}/build_scripts/rpm/mssql-cli.spec

# Copy build artifact to output dir.
mkdir ${REPO_PATH}/../rpm_output
cp ~/rpmbuild/RPMS/x86_64/*.rpm ${REPO_PATH}/../rpm_output
# Create a second copy for latest dev version to be used by homepage.
cp ~/rpmbuild/RPMS/x86_64/*.rpm ${REPO_PATH}/../rpm_output/mssql-cli-dev-latest.rpm
echo "The archive has also been outputted to ${REPO_PATH}/../rpm_output"

deactivate