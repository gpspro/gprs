#!/bin/bash

# Will install dev environment for GPRS gem and run "bundle install"

# Defaults to the current directory.
# NOTE: This requires that you run the script from the root directory of this project only
export PROJECT_DIR=$(pwd)

# Install dev dependencies for Ubuntu
${PROJECT_DIR}/provision/provision_ubuntu.sh

# Install bundle requirements for gem
bundle install
