#!/bin/bash

# Ensure the script is run from the dotfiles directory
if [ "$(basename "$PWD")" != "dotfiles" ]; then
  echo "Please run this script from the dotfiles directory."
  exit 1
fi

export DEBIAN_FRONTEND=noninteractive
export INSTALL_ZSH=true
export USERNAME=`whoami`

## update and install required packages
sudo apt-get update
sudo apt-get upgrade -yqq

sudo apt-get -y install --no-install-recommends apt-utils dialog 2>&1
sudo apt-get -y install \
  qemu-guest-agent \
  spice-vdagent \
  curl \
  telnet \
  git \
  gnupg2 \
  jq \
  openssh-client \
  less \
  iproute2 \
  procps \
  wget \
  unzip \
  apt-transport-https \
  lsb-release 
  
# change time zone
sudo ln -fs /usr/share/zoneinfo/America/Los_Angeles /etc/localtime
sudo dpkg-reconfigure --frontend noninteractive tzdata


# Install & Configure Zsh
if [ "$INSTALL_ZSH" = "true" ]
then
    sudo apt-get install -y \
    fonts-powerline \
    zsh

    # Install oh-my-zsh
    wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh

    echo "==========================================================="
    echo "             cloning zsh-autosuggestions                   "
    echo "-----------------------------------------------------------"
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    echo "==========================================================="
    echo "             cloning zsh-syntax-highlighting               "
    echo "-----------------------------------------------------------"
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    echo "==========================================================="
    echo "             cloning powerlevel10k                         "
    echo "-----------------------------------------------------------"
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
    echo "==========================================================="

    # symlink zshrc
    if [ -f "$HOME/.zshrc" ]; then
      mv "$HOME/.zshrc" "$HOME/.zshrc.bak.$(date +'%Y%m%d%H%M')"
    fi
    ln -s $PWD/.zshrc $HOME/.zshrc

    # symlink p10k.zsh
    if [ -f "$HOME/.p10k.zsh" ]; then
      mv "$HOME/.p10k.zsh" "$HOME/.p10k.zsh.bak.$(date +'%Y%m%d%H%M')"
    fi
    ln -s $PWD/.p10k.zsh $HOME/.p10k.zsh

    # change shell to zsh by default
    chsh -s $(which zsh)
    # echo 'chsh'
    # FILE=/etc/pam.d/chsh
    # if test -f "$FILE"; then
    #   sudo sed -i 's/auth       required   pam_shells.so/auth       sufficient   pam_shells.so/'  /etc/pam.d/chsh
    #   chsh -s $(which zsh)
    #   sudo sed -i 's/auth       sufficient   pam_shells.so/auth       required   pam_shells.so/'  /etc/pam.d/chsh    
    # else 
    #   sudo bash -c "echo 'auth       sufficient   pam_shells.so' > /etc/pam.d/chsh"
    # fi

fi


  # symlink gitconfig
  if [ -f "$HOME/.gitconfig" ]; then
    mv "$HOME/.gitconfig" "$HOME/.gitconfig.bak.$(date +'%Y%m%d%H%M')"
  fi
  ln -s $PWD/.gitconfig $HOME/.gitconfig

  # symlink gitignore_global
  if [ -f "$HOME/.gitignore_global" ]; then
    mv "$HOME/.gitignore_global" "$HOME/.gitignore_global.bak.$(date +'%Y%m%d%H%M')"
  fi
  ln -s $PWD/.gitignore_global $HOME/.gitignore_global

# Cleanup
sudo apt-get autoremove -y
sudo apt-get autoremove -y
sudo rm -rf /var/lib/apt/lists/*
