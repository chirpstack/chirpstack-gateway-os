LIC_FILES_CHKSUM = " \
    file://LICENSE;md5=bc4546f147d6f9892ca1b7d23bf41196 \
"

SRC_URI += "\
    file://chirpstack-udp-forwarder.toml \
    file://chirpstack-udp-forwarder.init \
"

do_install:append() {
    install -d ${D}${sysconfdir}/init.d
    install -m 0755 ${WORKDIR}/chirpstack-udp-forwarder.init ${D}${sysconfdir}/init.d/chirpstack-udp-forwarder

    install -d ${D}${sysconfdir}/chirpstack-udp-forwarder
    install -m 0640 ${WORKDIR}/chirpstack-udp-forwarder.toml ${D}${sysconfdir}/chirpstack-udp-forwarder/chirpstack-udp-forwarder.toml
}

DEPENDS = "\
    protobuf-native \
"

CONFFILES_${PN} += "${sysconfdir}/chirpstack-udp-forwarder/chirpstack-udp-forwarder.toml"
