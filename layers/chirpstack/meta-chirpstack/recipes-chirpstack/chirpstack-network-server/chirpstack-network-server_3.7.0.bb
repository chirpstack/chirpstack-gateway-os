DESCRIPTION = "ChirpStack Network Server"
HOMEPAGE = "https://www.chirpstack.io/"
PRIORITY = "optional"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSE;md5=e3a340e43ab9867d3e5d0ea79a54b0e1"
SRC_URI = " \
    https://artifacts.chirpstack.io/downloads/chirpstack-network-server/chirpstack-network-server_${PV}_linux_armv5.tar.gz \
    file://chirpstack-network-server.init \
    file://chirpstack-network-server.monit \
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
SRC_URI[md5sum] = "e355d22f9c88c69f8d190d7d700e2f23"
SRC_URI[sha256sum] = "9dd4009fc36f124abafd27f40f233b90a42d6bdc00e3c88d4eeb45bf984ffcaf"
PR = "r1"

inherit update-rc.d

INITSCRIPT_NAME = "chirpstack-network-server"
INITSCRIPT_PARAMS = "defaults"

S = "${WORKDIR}"

do_install() {
    install -d ${D}${bindir}
    install -m 0755 chirpstack-network-server ${D}${bindir}

    install -d ${D}${sysconfdir}/chirpstack-network-server/config
    install -m 0640 ${WORKDIR}/config/* ${D}${sysconfdir}/chirpstack-network-server/config

    install -d ${D}${sysconfdir}/init.d
    install -m 0755 ${WORKDIR}/chirpstack-network-server.init ${D}${sysconfdir}/init.d/chirpstack-network-server

    install -d ${D}${sysconfdir}/monit.d
    install -m 0644 ${WORKDIR}/chirpstack-network-server.monit ${D}${sysconfdir}/monit.d/chirpstack-network-server
}
