#/bin/bash

set -e

FIRMWARE="$1"
if [ ! -f "$FIRMWARE" ]
then
	echo "Usage: $0 [firmware.uf2]"
	exit 1
fi

sudo mount /dev/sda /mnt/usb
sudo cp "$FIRMWARE" /mnt/usb/
sudo umount /mnt/usb
