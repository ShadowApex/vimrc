# vimrc

## Setup

### Ubuntu

* Install NeoVim and dependencies    
`sudo add-apt-repository ppa:neovim-ppa/unstable`    
`sudo apt update && sudo apt install curl git neovim python-dev python python-pip python3-dev python3 python3-pip python-demjson pep8 flake8 silversearcher-ag yamllint puppet-lint shellcheck exuberant-ctags xclip`    
`sudo pip install -U neovim`    
`sudo pip3 install -U neovim`    

* Set NeoVim as the default editor:    
`sudo update-alternatives --install /usr/bin/vi vi /usr/bin/nvim 60`    
`sudo update-alternatives --config vi --skip-auto`    
`sudo update-alternatives --install /usr/bin/vim vim /usr/bin/nvim 60`    
`sudo update-alternatives --config vim --skip-auto`    
`sudo update-alternatives --install /usr/bin/editor editor /usr/bin/nvim 60`    
`sudo update-alternatives --config editor --skip-auto`    

* Clone the vimrc repository    
`git clone https://github.com/ShadowApex/vimrc ~/Projects/vimrc`    

* Link our vimrc to the appropriate locations    
`mkdir -p ~/.config/nvim`    
`ln -s ~/Projects/vimrc/.vimrc ~/.vimrc`    
`ln -s ~/Projects/vimrc/.vimrc ~/.config/nvim/init.vim`    

* Install plugin manager    
`curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim`    
`mkdir -p ~/.local/share/nvim/site/autoload`    
`ln -s ~/.vim/autoload/plug.vim ~/.local/share/nvim/site/autoload/plug.vim`    

* Install Plugins    
`vim +PlugInstall +qall`    
`vim +VimEnter +UpdateRemotePlugins +qall`    

* (Optional) Install Go support    
`sudo apt install golang`    
`echo "# GOPATH" >> ~/.bashrc"`    
`echo 'export GOPATH="$HOME/Projects/go"' >> ~/.bashrc`    
`echo 'export PATH="$PATH:$GOPATH/bin"' >> ~/.bashrc`    
`echo 'export PATH="$PATH:/usr/local/go/bin"' >> ~/.bashrc`    
`vim +GoInstallBinaries +qall`    

* (Optional) Install C/C++ support    
`sudo apt install clang clang-format libclang1 libclang-4.0-dev`

### Mac OS X

* Install Brew    
`/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"`    

* Install NeoVim and dependencies    
`brew install neovim curl python python3 git flake8 ag grip shellcheck`    
`sudo pip install -U neovim`    
`sudo pip3 install -U neovim`    

* Create a command alias for vim    
`echo "alias vim='nvim'" >> ~/.bashrc`    

* Clone the vimrc repository    
`git clone https://github.com/ShadowApex/vimrc ~/Projects/vimrc`    

* Link our vimrc to the appropriate locations    
`mkdir -p ~/.config/nvim`    
`ln -s ~/Projects/vimrc/.vimrc ~/.vimrc`    
`ln -s ~/Projects/vimrc/.vimrc ~/.config/nvim/init.vim`    

* Install plugin manager    
`curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim`    
`mkdir -p ~/.local/share/nvim/site/autoload`    
`ln -s ~/.vim/autoload/plug.vim ~/.local/share/nvim/site/autoload/plug.vim`    

* Install Plugins    
`vim +PlugInstall +qall`    
`vim +VimEnter +UpdateRemotePlugins +qall`    

* (Optional) Install Go support    
`brew install golang`    
`echo "# GOPATH" >> ~/.bashrc"`    
`echo 'export GOPATH="$HOME/Projects/go"' >> ~/.bashrc`    
`echo 'export PATH="$PATH:$GOPATH/bin"' >> ~/.bashrc`    
`echo 'export PATH="$PATH:/usr/local/go/bin"' >> ~/.bashrc`    
`vim +GoInstallBinaries +qall`    

* (Optional) Install C/C++ support    
`brew install llvm --with-clang`    
`brew install clang-format`    
