#!/bin/bash
scrot /tmp/screen.png
convert /tmp/screen.png -filter Gaussian -blur 0x32 /tmp/screen.png
i3lock  -i /tmp/screen.png
rm /tmp/screen.png

