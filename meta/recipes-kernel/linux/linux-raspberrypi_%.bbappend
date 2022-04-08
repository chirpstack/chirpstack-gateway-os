FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

# This will be automatically appended in u-boot based on the active partition.
CMDLINE:remove = "root=/dev/mmcblk0p2"

# Needed for the SX1302.
KERNEL_MODULE_AUTOLOAD += "i2c-dev"

SRC_URI += " \
	file://modules.cfg \
"
