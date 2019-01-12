#!/bin/sh

# original source:
# https://github.com/cmhe/meta-readonly-rootfs-overlay

# Enable strict shell mode
set -euo pipefail

PATH=/sbin:/bin:/usr/sbin:/usr/bin

MOUNT="/bin/mount"
UMOUNT="/bin/umount"
INIT="/sbin/init"

ROOT_MOUNT="/mnt/rootrw"

ROOT_RODEVICE=""
ROOT_ROFSTYPE="ext4"
ROOT_ROMOUNT="/mnt/root"
ROOT_ROMOUNTOPTIONS_DEVICE="ro,noatime,nodiratime"

ROOT_RWDEVICE="/dev/mmcblk0p4"
ROOT_RWFSTYPE="ext4"
ROOT_RWMOUNT="/data"
ROOT_RWMOUNTOPTIONS_DEVICE="rw,noatime"


early_setup() {
	mkdir -p /proc
	mkdir -p /sys
	$MOUNT -t proc proc /proc
	$MOUNT -t sysfs sysfs /sys
	grep -w "/dev" /proc/mounts >/dev/null || $MOUNT -t devtmpfs none /dev
}

read_args() {
	[ -z "${CMDLINE+x}" ] && CMDLINE=`cat /proc/cmdline`
	for arg in $CMDLINE; do
		# Set optarg to option parameter, and '' if no parameter was
		# given
		optarg=`expr "x$arg" : 'x[^=]*=\(.*\)' || echo ''`
		case $arg in
			root=*)
				ROOT_RODEVICE=$optarg ;;
			rootfstype=*)
				ROOT_ROFSTYPE="$optarg" ;;
			rootrw=*)
				ROOT_RWDEVICE=$optarg ;;
			rootrwfstype=*)
				ROOT_RWFSTYPE="$optarg" ;;
			rootrwoptions=*)
				ROOT_RWMOUNTOPTIONS_DEVICE="$optarg" ;;
			init=*)
				INIT=$optarg ;;
		esac
	done
}

fatal() {
	echo "rorootfs-overlay: $1" >$CONSOLE
	echo >$CONSOLE
	exec sh
}

log() {
	echo "rorootfs-overlay: $1" >$CONSOLE
}

early_setup

[ -z "${CONSOLE+x}" ] && CONSOLE="/dev/console"

read_args

mount_and_boot() {
    log "mkdir -p $ROOT_MOUNT $ROOT_ROMOUNT $ROOT_RWMOUNT"
	mkdir -p $ROOT_MOUNT $ROOT_ROMOUNT $ROOT_RWMOUNT

	# Mount root file system as read only.
	ROOT_ROMOUNTPARAMS="-t $ROOT_ROFSTYPE -o ${ROOT_ROMOUNTOPTIONS_DEVICE} $ROOT_RODEVICE"
    log "$MOUNT $ROOT_ROMOUNTPARAMS $ROOT_ROMOUNT"
	if ! $MOUNT $ROOT_ROMOUNTPARAMS "$ROOT_ROMOUNT"; then
		fatal "Could not mount rootfs as read-only"
	fi

	# Mount data file system as read-write.
	ROOT_RWMOUNTPARAMS="-t $ROOT_RWFSTYPE -o $ROOT_RWMOUNTOPTIONS_DEVICE $ROOT_RWDEVICE"
    log "$MOUNT $ROOT_RWMOUNTPARAMS $ROOT_RWMOUNT"
	if ! $MOUNT $ROOT_RWMOUNTPARAMS $ROOT_RWMOUNT ; then
		fatal "Could not mount read-write rootfs"
	fi

	# Determine if the overlay file-system is available.
	if ! grep -w "overlay" /proc/filesystems >/dev/null; then
		fatal "overlay is not available as a file-system"
	fi

	mkdir -p $ROOT_RWMOUNT/upperdir $ROOT_RWMOUNT/work
	$MOUNT -t overlay overlay \
		-o "$(printf "%s%s%s" \
			"lowerdir=$ROOT_ROMOUNT," \
			"upperdir=$ROOT_RWMOUNT/upperdir," \
			"workdir=$ROOT_RWMOUNT/work")" \
		$ROOT_MOUNT

	# Move read-only and read-write root file system into the overlay
	# file system
	mkdir -p $ROOT_MOUNT/$ROOT_ROMOUNT $ROOT_MOUNT/$ROOT_RWMOUNT
	$MOUNT -n --move $ROOT_ROMOUNT ${ROOT_MOUNT}/$ROOT_ROMOUNT
	$MOUNT -n --move $ROOT_RWMOUNT ${ROOT_MOUNT}/$ROOT_RWMOUNT

	$MOUNT -n --move /proc ${ROOT_MOUNT}/proc
	$MOUNT -n --move /sys ${ROOT_MOUNT}/sys
	$MOUNT -n --move /dev ${ROOT_MOUNT}/dev

	cd $ROOT_MOUNT

	exec chroot $ROOT_MOUNT $INIT ||
		fatal "Couldn't chroot, dropping to shell"
}

mount_and_boot
