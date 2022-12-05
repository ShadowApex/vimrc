#!/bin/bash
PIPE="$HOME/.cache/nvim/godot.pipe"
line=$2
col=$3
[ -n "$1" ] && file=$1
echo "Opening $file:$line:$col"
if [ ! -S $PIPE ]; then
	echo "No neovim server running. Starting one."
	/usr/bin/neovide -- --listen $PIPE
	# Workaround some shit
	sleep 1
	nvim --server $PIPE --remote-send '<F2><CR>'
fi
echo "Sending command"
nvim --server $PIPE --remote-send ':e '$file'<CR>'
