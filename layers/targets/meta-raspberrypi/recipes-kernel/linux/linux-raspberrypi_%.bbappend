# This will be automatically appended in u-boot based on the active partition.
CMDLINE_remove = "root=/dev/mmcblk0p2"

# Needed for the SX1302.
KERNEL_MODULE_AUTOLOAD += "i2c-dev"

do_configure_prepend() {
    kernel_configure_variable OVERLAY_FS y
}
