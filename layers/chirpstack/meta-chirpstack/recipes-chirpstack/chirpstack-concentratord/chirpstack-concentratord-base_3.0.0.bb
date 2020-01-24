DESCRIPTION = "ChirpStack Concentratord base files"
HOMEPAGE = "https://www.chirpstack.io/"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"
PR = "r2"

SRC_URI = "\
    file://chirpstack-concentratord.default \
    file://chirpstack-concentratord.init \
    file://chirpstack-concentratord.monit \
    file://sx1301-reset.init \
    file://sx1302-reset.init \
"

inherit update-rc.d

INITSCRIPT_NAME = "chirpstack-concentratord"
INITSCRIPT_PARAMS = "defaults"

S = "${WORKDIR}"

do_install() {
    install -d ${D}${sysconfdir}/init.d
    install -d ${D}${sysconfdir}/monit.d
    install -d ${D}${sysconfdir}/default

    install -m 0755 sx1301-reset.init ${D}${sysconfdir}/init.d/sx1301-reset
    install -m 0755 sx1302-reset.init ${D}${sysconfdir}/init.d/sx1302-reset

    install -m 0755 chirpstack-concentratord.init ${D}${sysconfdir}/init.d/chirpstack-concentratord
    install -m 0644 chirpstack-concentratord.monit ${D}${sysconfdir}/monit.d/chirpstack-concentratord
    install -m 0644 chirpstack-concentratord.default ${D}${sysconfdir}/default/chirpstack-concentratord
}
