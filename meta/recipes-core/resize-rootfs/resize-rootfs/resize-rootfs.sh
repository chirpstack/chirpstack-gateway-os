#!/bin/sh

mkdir -p /var/lib/resize-rootfs

do_resize_partition() {
    /usr/sbin/parted -s /dev/mmcblk0 -- resizepart 2 100%
    touch /var/lib/resize-rootfs/partition_resized
    reboot
}

do_resize_fs() {
    resize2fs /dev/mmcblk0p2
}


if [ -f /var/lib/resize-rootfs/partition_resized ]; then
    do_resize_fs

    # disable starting resize-rootfs on boot
    /usr/sbin/update-rc.d -f resize-rootfs remove
else
    # enable starting resize-rootfs on boot
    /usr/sbin/update-rc.d resize-rootfs defaults
    do_resize_partition
fi
