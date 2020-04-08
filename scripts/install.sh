#!/bin/bash
set -e

# Get the running script's base directory
baseDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Check what OS we're running on
unameOut="$(uname -s)"
if [ "$unameOut" != "Linux" ]; then
	echo "Script for $unameOut not supported. :("
	exit 1
fi

# Setup neovim on Ubuntu-based systems.
setup_ubuntu () {
	# Install NeoVim and dependencies, along with some base plugin dependencies
	sudo add-apt-repository ppa:neovim-ppa/unstable
	sudo apt update && sudo apt install -y curl git neovim python-dev python python-pip python3-dev python3 python3-pip python-demjson pep8 flake8 silversearcher-ag yamllint puppet-lint shellcheck exuberant-ctags xclip fonts-powerline python-jedi python3-jedi
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

	# Setup golang and plugin dependencies
	sudo apt install golang-go
	if ! grep GOPATH ~/.bashrc; then
		{
			echo ''
			echo '# GOPATH'
			echo "export GOPATH=\"\$HOME/Projects/go\""
			echo "export PATH=\"\$PATH:\$GOPATH/bin\""
		} >> ~/.bashrc
		export GOPATH="$HOME/Projects/go"
	fi
	mkdir -p "$GOPATH"
	go get -u github.com/saibing/bingo
	go get -u github.com/go-delve/delve/cmd/dlv

	# Setup Python and plugin dependencies
	sudo pip install python-language-server
	sudo pip3 install python-language-server

	# Setup npm and plugin dependencies for Javascript/CSS/Typescript/Docker
	sudo apt install npm
	sudo npm install -g dockerfile-language-server-nodejs
	sudo npm install -g vscode-css-languageserver-bin
	sudo npm install -g typescript typescript-language-server
	sudo npm install -g prettier

	# Setup C/C++ plugin dependencies
	sudo apt install clang-tools
}

# Check which distro we're running
distro="$(lsb_release -si)"

# Configure NeoVim based on the Linux distribution
case "${distro}" in
	Ubuntu)
		setup_ubuntu
		;;
	Arch|ArchLinux|Manjaro|ManjaroLinux)
		;;
	*)
		echo "Linux distribution '${distro}' not supported."
		exit 1
esac

# Link our vimrc to the appropriate locations
mkdir -p ~/.config/nvim
ln -s "$baseDir/.vimrc" ~/.vimrc
ln -s "$baseDir/.vimrc" ~/.config/nvim/init.vim
