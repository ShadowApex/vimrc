# Detect what OS we're running on.
OS_FAMILY := $(shell uname -s)
ifeq ($(OS_FAMILY),Darwin)
	OS_DIST := $(OS_FAMILY)
else
	OS_DIST := $(shell lsb_release -is)
endif

# List of packages that need to be installed
UBUNTU_PKGS := neovim git npm python-pip python3-pip curl
ARCH_PKGS   := neovim python-pynvim git npm python-pip curl
DARWIN_PKGS := neovim git npm curl
PIP_PKGS    := pynvim
PIP3_PKGS   := pynvim
NPM_PKGS    := neovim n yarn

# This is a list of COC plugins to install for different completion support
# https://github.com/neoclide/coc.nvim
COC_PLUGINS := coc-json coc-highlight coc-tag coc-pairs \
	coc-emoji coc-syntax coc-prettier coc-godot

# Setup function for Ubuntu
define install_Ubuntu
	sudo apt-get install -y software-properties-common
	sudo add-apt-repository -y ppa:neovim-ppa/unstable
	sudo apt install -y $(UBUNTU_PKGS)

	# Set NeoVim as the default editor
	sudo update-alternatives --install /usr/bin/vi vi /usr/bin/nvim 60
	sudo update-alternatives --config vi --skip-auto
	sudo update-alternatives --install /usr/bin/vim vim /usr/bin/nvim 60
	sudo update-alternatives --config vim --skip-auto
	sudo update-alternatives --install /usr/bin/editor editor /usr/bin/nvim 60
	sudo update-alternatives --config editor --skip-auto
endef

# Setup function for Elementry
define install_elementary
	$(call install_Ubuntu)
endef

# Setup function for Arch
define install_Arch
	sudo pacman -S --noconfirm $(ARCH_PKGS)
endef

# Setup function for Mac OSX
define install_Darwin
	brew install $(DARWIN_PKGS)
endef

# Install will install the vimrc configuration and its plugins.
install:
	$(call install_$(OS_DIST))
	
	# Install specific packages
	sudo pip install $(PIP_PKGS)
	sudo pip3 install $(PIP3_PKGS)
	sudo npm install -g $(NPM_PKGS)

	# Install Node.js
	sudo n lts

	# Link our vimrc to the appropriate locations
	mkdir -p $(HOME)/.config/nvim
	rm -rf "$(HOME)/.vimrc"
	rm -rf "$(HOME)/.config/nvim/init.vim"
	rm -rf "$(HOME)/.config/nvim/coc-settings.json"
	ln -s "$(PWD)/.vimrc" $(HOME)/.vimrc
	ln -s "$(PWD)/.vimrc" $(HOME)/.config/nvim/init.vim
	ln -s "$(PWD)/coc-settings.json" $(HOME)/.config/nvim/coc-settings.json

	# Install vim plugins
	nvim +PlugInstall +qall

	# Install coc plugins
	nvim -c "CocInstall -sync $(COC_PLUGINS)|q"

update:
	vim +PlugInstall +PlugUpdate +PlugUpgrade +qall
	vim -c "CocInstall -sync $(COC_PLUGINS)|q"

clean:
	vim +PlugClean +qall

image:
	sudo docker build -t vimrc-test:latest ./docker

debug_info:
	@echo "OS_FAMILY: $(OS_FAMILY)"
	@echo "OS_DIST:   $(OS_DIST)"
	@echo "HOME_DIR:  $(HOME)"

test:
	sudo docker run -it --rm -v $(PWD):/vimrc -w /vimrc vimrc-test:latest

.PHONY: install image debug_info test update clean
