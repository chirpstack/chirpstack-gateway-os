SUMMARY = "Read only rootfs with overlay init script"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/COPYING.MIT;md5=3da9cfbcb788c80a0384361b4de20420"
SRC_URI = "file://init-readonly-rootfs-overlay-boot.sh"
PR = "r3"

S = "${WORKDIR}"

do_install() {
        install -m 0755 ${WORKDIR}/init-readonly-rootfs-overlay-boot.sh ${D}/init
        install -d "${D}/mnt/root"
        install -d "${D}/data"

        install -d ${D}/dev
        mknod -m 622 ${D}/dev/console c 5 1
}


# Due to kernel dependency
PACKAGE_ARCH = "${MACHINE_ARCH}"

FILES_${PN} += " /init /mnt/root /data /dev"
FILES_${PN} += "/dev"
