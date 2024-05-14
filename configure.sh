#!/bin/bash

# Check if the script is being run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit 1
fi

# Install fbi package for image display
apt-get -y install fbi

# Remove or comment out GPIO screen configuration from /boot/config.txt
sed -i '/dtoverlay=piscreen/d' /boot/config.txt
sed -i '/dtparam=spi=on/d' /boot/config.txt

# Make sure spi-bcm2835 is not loaded
rmmod spi-bcm2835

# Make all .sh files executable
chmod +x *.sh

# Prompt the user to reboot the Raspberry Pi to apply the changes
echo "To see the screen, you need to reboot your Raspberry Pi. Do you want to do it now?"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) ./umbrel/scripts/stop; reboot; break;;
        No ) exit;;
    esac
done
