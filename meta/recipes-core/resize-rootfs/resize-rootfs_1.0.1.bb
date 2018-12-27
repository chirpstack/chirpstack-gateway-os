DESCRIPTION = "Resize root FS to maximum size"
HOMEPAGE = "https://www.loraserver.io/"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

RDEPENDS_${PN} = "parted e2fsprogs-resize2fs"

SRC_URI = " \
    file://resize-rootfs.init \
    file://resize-rootfs.sh \
"

PR = "r1"

do_install() {
    install -d ${D}/usr
    install -d ${D}/usr/bin
    install -m 0755 ${WORKDIR}/resize-rootfs.sh ${D}/usr/bin/resize-rootfs

    install -d ${D}${sysconfdir}/init.d
    install -m 0755 ${WORKDIR}/resize-rootfs.init ${D}${sysconfdir}/init.d/resize-rootfs
}

FILES_${PN} = " \
    /etc/init.d/resize-rootfs \
    /usr/bin/resize-rootfs \
"
