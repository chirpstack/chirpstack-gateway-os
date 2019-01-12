SRC_URI_remove = "file://0006-env-Kconfig-Add-descriptions-so-environment-options-.patch"

do_mender_uboot_auto_configure_prepend() {
    do_copy_wifx_config
}

