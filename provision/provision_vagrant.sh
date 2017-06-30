#!/bin/bash

VAGRANT_USER=vagrant

# Prerequisites
echo "Installing Vagrant base packages..."
sudo apt-get update

# Basic packages
sudo apt-get -y install zsh vim curl git htop tmux valgrind

# Oh My Zsh
if [ -d /home/${VAGRANT_USER}/.oh-my-zsh ]; then
  echo "Oh My Zsh is already installed, skipping..."
else
  echo "Installing Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
  sudo chsh -s /usr/bin/zsh ${VAGRANT_USER}

  zsh
fi

# Install bundle as well
echo "Updating bundle for gprs gem dependencies..."
cd /vagrant
bundle install
