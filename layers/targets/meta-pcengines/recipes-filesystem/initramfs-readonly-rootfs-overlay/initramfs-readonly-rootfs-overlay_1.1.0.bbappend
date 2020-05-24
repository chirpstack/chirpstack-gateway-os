do_install_prepend() {
    # The device node in script is hardcoded to /dev/mmcblk0p4
    sed -e "s@^ROOT_RWDEVICE=\".*\"\$@ROOT_RWDEVICE=\"/dev/sda4\"@" -i ${WORKDIR}/init-readonly-rootfs-overlay-boot.sh
}
