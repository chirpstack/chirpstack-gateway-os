DESCRIPTION = "ChirpStack Gateway Bridge"
HOMEPAGE = "https://www.chirpstack.io/"
PRIORITY = "optional"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSE;md5=99e425257f8a67b7efd81dc0009ed8ff"
SRC_URI = "https://artifacts.chirpstack.io/downloads/chirpstack-gateway-bridge/chirpstack-gateway-bridge_${PV}_linux_armv5.tar.gz \
           file://chirpstack-gateway-bridge.toml \
           file://chirpstack-gateway-bridge.init \
           file://chirpstack-gateway-bridge.monit \
"
SRC_URI[md5sum] = "615354e704a070417a454c3baf6b34b4"
SRC_URI[sha256sum] = "fb15e9249a0cd331912233e833856062c6aa0bbce9397df4531512f21fd02579"
PR = "r1"

inherit update-rc.d

INITSCRIPT_NAME = "chirpstack-gateway-bridge"
INITSCRIPT_PARAMS = "defaults"

S = "${WORKDIR}"
BIN_DIR = "/opt/chirpstack-gateway-bridge"
CONF_DIR = "${sysconfdir}/chirpstack-gateway-bridge"

do_install() {
    install -d ${D}${BIN_DIR}
    install -m 0755 chirpstack-gateway-bridge ${D}${BIN_DIR}/

    install -d ${D}${CONF_DIR}
    install -m 0640 ${WORKDIR}/chirpstack-gateway-bridge.toml ${D}${CONF_DIR}/chirpstack-gateway-bridge.toml

    install -d ${D}${sysconfdir}/init.d
    install -m 0755 ${WORKDIR}/chirpstack-gateway-bridge.init ${D}${sysconfdir}/init.d/chirpstack-gateway-bridge

    install -d ${D}${sysconfdir}/monit.d
    install -m 0644 ${WORKDIR}/chirpstack-gateway-bridge.monit ${D}${sysconfdir}/monit.d/chirpstack-gateway-bridge
}

FILES_${PN} += "${BIN_DIR}"
FILES_${PN}-dbg += "${BIN_DIR}/.debug"

CONFFILES_${PN} += "${CONF_DIR}/chirpstack-gateway-bridge.toml"
