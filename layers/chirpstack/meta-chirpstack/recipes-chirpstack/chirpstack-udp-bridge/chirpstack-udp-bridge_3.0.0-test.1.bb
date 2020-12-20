HOMEPAGE = "https://www.chirpstack.io/"
DESCRIPTION = "ChirpStack UDP Bridge"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSE;md5=09fe2246a30dca84af09ac8608093cd7"
PR = "r1"

SRC_URI = "\
    git://github.com/brocaar/chirpstack-udp-bridge.git;protocol=git;tag=v${PV} \
    file://chirpstack-udp-bridge.toml \
    file://chirpstack-udp-bridge.init \
"
DEPENDS = "\
    clang-native \
"

inherit cargo

S = "${WORKDIR}/git"

export BINDGEN_EXTRA_CLANG_ARGS="-I${STAGING_INCDIR}"

do_install() {
    if [ "${CARGO_BUILD_TYPE}" = "--release" ]; then
        local cargo_bindir="${CARGO_RELEASE_DIR}"
    else
        local cargo_bindir="${CARGO_DEBUG_DIR}"
    fi

    install -d ${D}${bindir}
    install -m 0755 ${cargo_bindir}/chirpstack-udp-bridge ${D}${bindir}

    install -d ${D}${sysconfdir}/init.d
    install -m 0755 ${WORKDIR}/chirpstack-udp-bridge.init ${D}${sysconfdir}/init.d/chirpstack-udp-bridge

    install -d ${D}${sysconfdir}/chirpstack-udp-bridge
    install -m 0640 ${WORKDIR}/chirpstack-udp-bridge.toml ${D}${sysconfdir}/chirpstack-udp-bridge/chirpstack-udp-bridge.toml
}

CONFFILES_${PN} += "${sysconfdir}/chirpstack-udp-bridge/chirpstack-udp-bridge.toml"
