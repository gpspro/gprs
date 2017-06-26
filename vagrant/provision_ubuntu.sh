#!/bin/bash

VAGRANT_USER=vagrant

# Prerequisites
echo "Installing/updating base packages..."
sudo apt-get update

# Basic packages
sudo apt-get -y install zsh vim curl git build-essential htop tmux valgrind

# Ruby Dependencies
sudo apt-get -y install ruby ruby-dev

# Bundler for gprs gem
sudo gem install bundler

# Oh My Zsh
if [ -d /home/${VAGRANT_USER}/.oh-my-zsh ]; then
  echo "Oh My Zsh is already installed, skipping..."
else
  echo "Installing Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
  sudo chsh -s /usr/bin/zsh ${VAGRANT_USER}

  zsh
fi

# Update bundle for new Ruby DB-tools scripts
echo "Updating bundle for gprs gem dependencies..."
cd /vagrant
bundle install
