#!/bin/bash

# Check what OS we're running on
unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     machine=Linux;;
    Darwin*)    machine=Mac;;
    CYGWIN*)    machine=Cygwin;;
    MINGW*)     machine=MinGw;;
    *)          machine="UNKNOWN:${unameOut}"
esac

if [ "$unameOut" != "Linux" ]; then
	echo "Script for $unameOut not supported. :("
	exit 1
fi

# Get the running script's base directory
baseDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Install NeoVim and dependencies
sudo add-apt-repository ppa:neovim-ppa/unstable
sudo apt update && sudo apt install -y curl git neovim python-dev python python-pip python3-dev python3 python3-pip pep8 flake8 silversearcher-ag
sudo apt install -y clang clang-format libclang1 libclang-4.0-dev
sudo pip install -U neovim
sudo pip3 install -U neovim

# Set NeoVim as the default editor
sudo update-alternatives --install /usr/bin/vi vi /usr/bin/nvim 60
sudo update-alternatives --config vi --skip-auto
sudo update-alternatives --install /usr/bin/vim vim /usr/bin/nvim 60
sudo update-alternatives --config vim --skip-auto
sudo update-alternatives --install /usr/bin/editor editor /usr/bin/nvim 60
sudo update-alternatives --config editor --skip-auto

# Link our vimrc to the appropriate locations
mkdir -p ~/.config/nvim
ln -s $baseDir/vimrc/.vimrc ~/.vimrc
ln -s $baseDir/vimrc/.vimrc ~/.config/nvim/init.vim

# Install plugin manager
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
mkdir -p ~/.local/share/nvim/site/autoload
ln -s ~/.vim/autoload/plug.vim ~/.local/share/nvim/site/autoload/plug.vim

# Install Plugins
vim +PlugInstall +qall
vim +VimEnter +UpdateRemotePlugins +qall
