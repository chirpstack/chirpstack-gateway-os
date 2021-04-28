#!/bin/sh

part_active=`fw_printenv part_active |cut -d '=' -f 2`

if [ -z "$part_active" ] || [ "$part_active" = 2 ]; then
        selection="stable,copy2"
else
        selection="stable,copy1"
fi

swupdate -H raspberrypi4:1.0 -e ${selection} -i $1
