LIC_FILES_CHKSUM = " \
    file://LICENSE;md5=bc4546f147d6f9892ca1b7d23bf41196 \
"

SRC_URI += "\
    file://remove-release-profile.patch \
    file://chirpstack-mqtt-forwarder.init \
    file://chirpstack-mqtt-forwarder.monit \
    file://chirpstack-mqtt-forwarder.toml \
"

inherit update-rc.d

INITSCRIPT_NAME = "chirpstack-mqtt-forwarder"
INITSCRIPT_PARAMS = "defaults"

do_install:append() {
    install -d ${D}${sysconfdir}/init.d
    install -m 0755 ${WORKDIR}/chirpstack-mqtt-forwarder.init ${D}${sysconfdir}/init.d/chirpstack-mqtt-forwarder

    install -d ${D}${sysconfdir}/monit.d
    install -m 0644 ${WORKDIR}/chirpstack-mqtt-forwarder.monit ${D}${sysconfdir}/monit.d/chirpstack-mqtt-forwarder

    install -d ${D}${sysconfdir}/chirpstack-mqtt-forwarder
    install -m 0640 ${WORKDIR}/*.toml ${D}${sysconfdir}/chirpstack-mqtt-forwarder/
}


export OPENSSL_NO_VENDOR="1"
export OPENSSL_LIB_DIR="${STAGING_LIBDIR}"
export OPENSSL_INCLUDE_DIR="${STAGING_INCDIR}/openssl"

DEPENDS = "\
    protobuf-native \
    openssl \
    clang-native \
"

CONFFILES:${PN} += "${sysconfdir}/chirpstack-mqtt-forwarder/chirpstack-mqtt-forwarder.toml"
