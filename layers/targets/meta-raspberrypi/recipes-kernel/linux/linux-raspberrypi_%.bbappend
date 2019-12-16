CMDLINE_remove = "root=/dev/mmcblk0p2"
CMDLINE_append = " root=\${mender_kernel_root}"

KERNEL_MODULE_AUTOLOAD += "i2c-dev"

do_configure_prepend() {
    kernel_configure_variable OVERLAY_FS y
}

