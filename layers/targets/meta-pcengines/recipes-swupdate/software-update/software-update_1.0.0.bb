DESCRIPTION = "Script for performing software upgrades"
HOMEPAGE = "https://www.chirpstack.io/"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = " \
    file://software-update.sh \
"

PR = "r1"

RDEPENDS_${PN} = "grub-editenv"

do_install() {
    install -d ${D}${bindir}
    install -m 0755 ${WORKDIR}/software-update.sh ${D}${bindir}/software-update
}

FILES_${PN} = "${bindir}/software-update"
