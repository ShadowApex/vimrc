#!/bin/bash
PIPE="$HOME/.cache/nvim/godot.pipe"
line=$2
col=$3
[ -n "$1" ] && file=$1
echo "Opening $file:$line:$col"
if [ ! -S $PIPE ]; then
	echo "No neovim server running. Starting one."
	wezterm start nvim --listen $PIPE
	#kitty --detach nvim --listen $PIPE
	sleep 1
fi
echo "Sending command"
nvim --server $PIPE --remote-send ':e '$file'<CR>'
