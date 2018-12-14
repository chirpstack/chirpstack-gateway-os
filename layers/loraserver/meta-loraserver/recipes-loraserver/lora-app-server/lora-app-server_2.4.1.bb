DESCRIPTION = "LoRa App Server"
HOMEPAGE = "https://www.loraserver.io/"
PRIORITY = "optional"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSE;md5=5301050fd7cd58850085239d559297be"
SRC_URI = " \
    https://artifacts.loraserver.io/downloads/lora-app-server/lora-app-server_${PV}_linux_armv5.tar.gz \
    file://lora-app-server.init \
    file://lora-app-server.monit \
    file://lora-app-server.toml \
"
SRC_URI[md5sum] = "8ee6fe4d65a70fcad7bc653e889a266e"
SRC_URI[sha256sum] = "8bf79ab1a0cb9e6b467950c56c1148b2c9e22c69cf0ce235fbfe419b9f72da8c"
PR = "r1"

inherit update-rc.d

INITSCRIPT_NAME = "lora-app-server"
INITSCRIPT_PARAMS = "defaults"

S = "${WORKDIR}"
BIN_DIR = "/opt/lora-app-server"
CONF_DIR = "${sysconfdir}/lora-app-server"

do_install() {
    install -d ${D}${BIN_DIR}
    install -m 0755 lora-app-server ${D}${BIN_DIR}/

    install -d ${D}${CONF_DIR}
    install -m 0640 ${WORKDIR}/lora-app-server.toml ${D}${CONF_DIR}/lora-app-server.toml

    install -d ${D}${sysconfdir}/init.d
    install -m 0755 ${WORKDIR}/lora-app-server.init ${D}${sysconfdir}/init.d/lora-app-server

    install -d ${D}${sysconfdir}/monit.d
    install -m 0644 ${WORKDIR}/lora-app-server.monit ${D}${sysconfdir}/monit.d/lora-app-server
}


FILES_${PN} += "${BIN_DIR}"
FILES_${PN}-dbg += "${BIN_DIR}/.debug"

CONFFILES_${PN} += "${CONF_DIR}/lora-app-server.toml"
