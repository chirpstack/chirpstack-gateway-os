DESCRIPTION = "ChirpStack Application Server"
HOMEPAGE = "https://www.chirpstack.io/"
PRIORITY = "optional"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSE;md5=5301050fd7cd58850085239d559297be"
SRC_URI = " \
    https://artifacts.chirpstack.io/downloads/chirpstack-application-server/chirpstack-application-server_${PV}_linux_armv5.tar.gz \
    file://chirpstack-application-server.init \
    file://chirpstack-application-server.monit \
    file://chirpstack-application-server.toml \
"
SRC_URI[md5sum] = "f84af892eb4313169652571acd1d3eda"
SRC_URI[sha256sum] = "8179988e8b4886f88605ebe447641a9a71c1c306ab541405e285a03718050f82"
PR = "r1"

inherit update-rc.d

INITSCRIPT_NAME = "chirpstack-application-server"
INITSCRIPT_PARAMS = "defaults"

S = "${WORKDIR}"
BIN_DIR = "/opt/chirpstack-application-server"
CONF_DIR = "${sysconfdir}/chirpstack-application-server"

do_install() {
    install -d ${D}${BIN_DIR}
    install -m 0755 chirpstack-application-server ${D}${BIN_DIR}/

    install -d ${D}${CONF_DIR}
    install -m 0640 ${WORKDIR}/chirpstack-application-server.toml ${D}${CONF_DIR}/chirpstack-application-server.toml

    install -d ${D}${sysconfdir}/init.d
    install -m 0755 ${WORKDIR}/chirpstack-application-server.init ${D}${sysconfdir}/init.d/chirpstack-application-server

    install -d ${D}${sysconfdir}/monit.d
    install -m 0644 ${WORKDIR}/chirpstack-application-server.monit ${D}${sysconfdir}/monit.d/chirpstack-application-server
}


FILES_${PN} += "${BIN_DIR}"
FILES_${PN}-dbg += "${BIN_DIR}/.debug"

CONFFILES_${PN} += "${CONF_DIR}/chirpstack-application-server.toml"
