DESCRIPTION = "LoRa Server"
HOMEPAGE = "https://www.loraserver.io/"
PRIORITY = "optional"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSE;md5=e3a340e43ab9867d3e5d0ea79a54b0e1"
SRC_URI = " \
    https://artifacts.loraserver.io/downloads/loraserver/loraserver_${PV}_linux_armv5.tar.gz \
    file://loraserver.init \
    file://loraserver.monit \
    file://loraserver.toml \
    file://loraserver-eu868.toml \
    file://loraserver-us915.toml \
"
SRC_URI[md5sum] = "6e661cbd2edd67ff53c377f56a729974"
SRC_URI[sha256sum] = "c5dc6506db90e89e626fb454524ef517ad4559bd2c8b8f75607050977f25336c"
PR = "r1"

inherit update-rc.d

INITSCRIPT_NAME = "loraserver"
INITSCRIPT_PARAMS = "defaults"

S = "${WORKDIR}"
BIN_DIR = "/opt/loraserver"
CONF_DIR = "${sysconfdir}/loraserver"

do_install() {
    install -d ${D}${BIN_DIR}
    install -m 0755 loraserver ${D}${BIN_DIR}/

    install -d ${D}${CONF_DIR}
    install -m 0640 ${WORKDIR}/loraserver.toml ${D}${CONF_DIR}/loraserver.toml
    install -m 0640 ${WORKDIR}/loraserver-eu868.toml ${D}${CONF_DIR}/loraserver-eu868.toml
    install -m 0640 ${WORKDIR}/loraserver-us915.toml ${D}${CONF_DIR}/loraserver-us915.toml

    install -d ${D}${sysconfdir}/init.d
    install -m 0755 ${WORKDIR}/loraserver.init ${D}${sysconfdir}/init.d/loraserver

    install -d ${D}${sysconfdir}/monit.d
    install -m 0644 ${WORKDIR}/loraserver.monit ${D}${sysconfdir}/monit.d/loraserver
}

FILES_${PN} += "${BIN_DIR}"
FILES_${PN}-dbg += "${BIN_DIR}/.debug"

CONFFILES_${PN} += "${CONF_DIR}/loraserver.toml"
