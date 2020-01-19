DESCRIPTION = "Script for performing software upgrades"
HOMEPAGE = "https://www.chirpstack.io/"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = " \
    file://software-update.sh \
"

PR = "r1"

do_install() {
    install -d ${D}/usr/bin
    install -m 0755 ${WORKDIR}/software-update.sh ${D}/usr/bin/software-update
}

FILES_${PN} = "/usr/bin/software-update"
