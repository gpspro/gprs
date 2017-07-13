#!/bin/bash

# Prerequisites
echo "Installing required packages for GPRS gem..."
sudo apt-get update

# Required for C extension
sudo apt-get -y install build-essential

# Ruby Dependencies
sudo apt-get -y install ruby ruby-dev

# Bundler for gprs gem
sudo gem install bundler

# Install Kaitai Struct (with dependencies)
echo "deb https://dl.bintray.com/kaitai-io/debian jessie main" | sudo tee /etc/apt/sources.list.d/kaitai.list
sudo apt-key adv --keyserver hkp://pool.sks-keyservers.net --recv 379CE192D401AB61
sudo apt-get update
sudo apt-get -y install kaitai-struct-compiler zlib1g-dev default-jre
