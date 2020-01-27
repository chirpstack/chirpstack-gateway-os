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
SRC_URI[md5sum] = "47a1466edecc6e2dd9d7046ef37e8db1"
SRC_URI[sha256sum] = "e7840514fce4c45479bc204b1af594d6c86cb96bf4614955d8f7cec53ce33550"
PR = "r1"

inherit update-rc.d

INITSCRIPT_NAME = "chirpstack-application-server"
INITSCRIPT_PARAMS = "defaults"

S = "${WORKDIR}"

do_install() {
    install -d ${D}${bindir}
    install -m 0755 chirpstack-application-server ${D}${bindir}

    install -d ${D}${sysconfdir}/chirpstack-application-server
    install -m 0640 ${WORKDIR}/chirpstack-application-server.toml ${D}${sysconfdir}/chirpstack-application-server/chirpstack-application-server.toml

    install -d ${D}${sysconfdir}/init.d
    install -m 0755 ${WORKDIR}/chirpstack-application-server.init ${D}${sysconfdir}/init.d/chirpstack-application-server

    install -d ${D}${sysconfdir}/monit.d
    install -m 0644 ${WORKDIR}/chirpstack-application-server.monit ${D}${sysconfdir}/monit.d/chirpstack-application-server
}

CONFFILES_${PN} += "${sysconfdir}/chirpstack-application-server/chirpstack-application-server.toml"
