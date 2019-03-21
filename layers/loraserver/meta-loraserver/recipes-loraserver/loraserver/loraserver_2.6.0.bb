DESCRIPTION = "LoRa Server"
HOMEPAGE = "https://www.loraserver.io/"
PRIORITY = "optional"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSE;md5=e3a340e43ab9867d3e5d0ea79a54b0e1"
SRC_URI = " \
    https://artifacts.loraserver.io/downloads/loraserver/loraserver_${PV}_linux_armv5.tar.gz \
    file://loraserver.init \
    file://loraserver.monit \
    file://config/au915_0.toml \
    file://config/au915_1.toml \
    file://config/au915_2.toml \
    file://config/au915_3.toml \
    file://config/au915_4.toml \
    file://config/au915_5.toml \
    file://config/au915_6.toml \
    file://config/au915_7.toml \
    file://config/eu868.toml \
    file://config/us915_0.toml \
    file://config/us915_1.toml \
    file://config/us915_2.toml \
    file://config/us915_3.toml \
    file://config/us915_4.toml \
    file://config/us915_5.toml \
    file://config/us915_6.toml \
    file://config/us915_7.toml \
"
SRC_URI[md5sum] = "7b3beb5f736ccf4240ab700b66b11262"
SRC_URI[sha256sum] = "3a4ade85822c518b9f148f4c11e79b55d5c1efad1338e432c0ea9433eda18613"
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
    install -d ${D}${CONF_DIR}/config

    install -m 0640 ${WORKDIR}/config/* ${D}${CONF_DIR}/config

    install -d ${D}${sysconfdir}/init.d
    install -m 0755 ${WORKDIR}/loraserver.init ${D}${sysconfdir}/init.d/loraserver

    install -d ${D}${sysconfdir}/monit.d
    install -m 0644 ${WORKDIR}/loraserver.monit ${D}${sysconfdir}/monit.d/loraserver
}

FILES_${PN} += "${BIN_DIR}"
FILES_${PN}-dbg += "${BIN_DIR}/.debug"

