HOMEPAGE = "https://www.chirpstack.io/"
DESCRIPTION = "ChirpStack Concentratord"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSE;md5=99e425257f8a67b7efd81dc0009ed8ff"
PR = "r1"

SRC_URI = "\
    git://github.com/brocaar/chirpstack-concentratord.git;protocol=git;tag=v${PV} \
    file://chirpstack-concentratord.default \
    file://chirpstack-concentratord.init \
    file://chirpstack-concentratord.monit \
"
DEPENDS = "\
    clang-native \
    libloragw-sx1301 \
    libloragw-sx1302 \
"

inherit cargo update-rc.d

INITSCRIPT_NAME = "chirpstack-concentratord"
INITSCRIPT_PARAMS = "defaults"

S = "${WORKDIR}/git"

export BINDGEN_EXTRA_CLANG_ARGS="-I${STAGING_INCDIR}"

do_install() {
    install -d ${D}${sysconfdir}/init.d
    install -d ${D}${sysconfdir}/monit.d
    install -d ${D}${sysconfdir}/default
    install -d ${D}${bindir}

    if [ "${CARGO_BUILD_TYPE}" = "--release" ]; then
        local cargo_bindir="${CARGO_RELEASE_DIR}"
    else
        local cargo_bindir="${CARGO_DEBUG_DIR}"
    fi

    install -m 0755 ../chirpstack-concentratord.init ${D}${sysconfdir}/init.d/chirpstack-concentratord
    install -m 0644 ../chirpstack-concentratord.monit ${D}${sysconfdir}/monit.d/chirpstack-concentratord
    install -m 0644 ../chirpstack-concentratord.default ${D}${sysconfdir}/default/chirpstack-concentratord

    install -m 0755 ${cargo_bindir}/chirpstack-concentratord-sx1301 ${D}${bindir}
    install -m 0755 ${cargo_bindir}/chirpstack-concentratord-sx1302 ${D}${bindir}
    install -m 0755 ${cargo_bindir}/gateway-id ${D}${bindir}
}

PACKAGES += "${PN}-sx1301 ${PN}-sx1302"

FILES_${PN} = "${sysconfdir} ${bindir}/gateway-id"
FILES_${PN}-sx1301 = "${bindir}/chirpstack-concentratord-sx1301"
FILES_${PN}-sx1302 = "${bindir}/chirpstack-concentratord-sx1302"
