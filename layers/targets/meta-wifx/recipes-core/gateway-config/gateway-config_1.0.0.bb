DESCRIPTION = "Script for LoRa Gateway configuration."
HOMEPAGE = "https://www.loraserver.io/"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

RDEPENDS_${PN} = "dialog nano"

SRC_URI = "file://gateway-config.sh \
"
PR = "r1"

do_install() {
    install -d ${D}/usr
    install -d ${D}/usr/bin
    install -m 0755 ${WORKDIR}/gateway-config.sh ${D}/usr/bin/gateway-config
}

FILES_${PN} = "/usr/bin/gateway-config"
