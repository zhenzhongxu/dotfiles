#!/bin/sh

export DEBIAN_FRONTEND=noninteractive
export INSTALL_ZSH=true
export USERNAME=`whoami`

## update and install required packages
sudo apt-get update
sudo apt-get -y install --no-install-recommends apt-utils dialog 2>&1
sudo apt-get install -y \
  curl \
  git \
  gnupg2 \
  jq \
  sudo \
  openssh-client \
  less \
  iproute2 \
  procps \
  wget \
  unzip \
  apt-transport-https \
  lsb-release 

zshrc() {
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
    echo "             import zshrc                                  "
    echo "-----------------------------------------------------------"
    cat .zshrc > $HOME/.zshrc
    echo "==========================================================="
    echo "             import powerlevel10k                          "
    echo "-----------------------------------------------------------"
    cat .p10k.zsh > $HOME/.p10k.zsh
}

# change time zone
sudo ln -fs /usr/share/zoneinfo/America/Los_Angeles /etc/localtime
sudo dpkg-reconfigure --frontend noninteractive tzdata


# Install & Configure Zsh
if [ "$INSTALL_ZSH" = "true" ]
then
    sudo apt-get install -y \
    fonts-powerline \
    zsh

    # cp -f ~/dotfiles/.zshrc ~/.zshrc
    # chsh -s /usr/bin/zsh $USERNAME
    wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git
    echo "source $PWD/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ${ZDOTDIR:-$HOME}/.zshrc

    zshrc

    # change shell to zsh by default
    if [ "$CODESPACES" = "true" ]
    then
      echo 'chsh'
      FILE=/etc/pam.d/chsh
      if test -f "$FILE"; then
        sudo sed -i 's/auth       required   pam_shells.so/auth       sufficient   pam_shells.so/'  /etc/pam.d/chsh
        chsh -s $(which zsh)
        sudo sed -i 's/auth       sufficient   pam_shells.so/auth       required   pam_shells.so/'  /etc/pam.d/chsh    
      else 
        sudo bash -c "echo 'auth       sufficient   pam_shells.so' > /etc/pam.d/chsh"
      fi
    fi
fi


# Cleanup
sudo apt-get autoremove -y
sudo apt-get autoremove -y
sudo rm -rf /var/lib/apt/lists/*

# needs to be after zshrc
echo "" >> ~/.zshrc
echo "# remove ls and directory completion highlight color" >> ~/.zshrc
echo "_ls_colors=':ow=01;33'" >> ~/.zshrc
echo 'zstyle ":completion:*:default" list-colors "${(s.:.)_ls_colors}"' >> ~/.zshrc
echo 'LS_COLORS+=$_ls_colors' >> ~/.zshrc
