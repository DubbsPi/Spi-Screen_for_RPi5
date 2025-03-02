#!/bin/bash

# Define the dtoverlay line to check and potentially add
dtoverlay_line="dtoverlay=piscreen,speed=100000000,rotate=270"

# Path to config.txt
config_file="/boot/firmware/config.txt"

# Check if dtoverlay line is already present in config.txt
if ! grep -Fxq "$dtoverlay_line" "$config_file"; then
    # Add the dtoverlay line if it's not found
    echo "$dtoverlay_line" | sudo tee -a "$config_file" > /dev/null

    # Reboot if we added the line
    echo "dtoverlay line added. Rebooting..."
    sudo reboot
else
    echo "dtoverlay line already exists. No reboot needed."
fi

# Run the specified command constantly after checking/configuring config.txt
while true; do
    grim -l 0 -t ppm - | ffmpeg -loglevel quiet -hide_banner -i - -vf 'scale=480:320,format=rgb565le' -f fbdev /dev/fb1
done
