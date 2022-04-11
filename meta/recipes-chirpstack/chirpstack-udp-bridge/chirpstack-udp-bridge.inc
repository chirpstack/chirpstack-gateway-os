LIC_FILES_CHKSUM = " \
    file://LICENSE;md5=09fe2246a30dca84af09ac8608093cd7 \
"

SRC_URI += "\
    file://chirpstack-udp-bridge.toml \
    file://chirpstack-udp-bridge.init \
"

do_install:append() {
    install -d ${D}${sysconfdir}/init.d
    install -m 0755 ${WORKDIR}/chirpstack-udp-bridge.init ${D}${sysconfdir}/init.d/chirpstack-udp-bridge

    install -d ${D}${sysconfdir}/chirpstack-udp-bridge
    install -m 0640 ${WORKDIR}/chirpstack-udp-bridge.toml ${D}${sysconfdir}/chirpstack-udp-bridge/chirpstack-udp-bridge.toml
}

CONFFILES_${PN} += "${sysconfdir}/chirpstack-udp-bridge/chirpstack-udp-bridge.toml"
