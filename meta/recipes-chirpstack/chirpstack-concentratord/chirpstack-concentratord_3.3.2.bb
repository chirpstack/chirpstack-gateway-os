HOMEPAGE = "https://www.chirpstack.io/"
DESCRIPTION = "ChirpStack Concentratord"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSE;md5=99e425257f8a67b7efd81dc0009ed8ff"
PR = "r1"

SRC_URI = "\
    git://github.com/brocaar/chirpstack-concentratord.git;protocol=https;tag=v${PV} \
    file://chirpstack-concentratord.default \
    file://chirpstack-concentratord.init \
    file://chirpstack-concentratord.monit \
    file://sx1301/global.toml \
    file://sx1301/as923.toml \
    file://sx1301/as923_0.toml \
    file://sx1301/au915.toml \
    file://sx1301/au915_0.toml \
    file://sx1301/au915_1.toml \
    file://sx1301/au915_2.toml \
    file://sx1301/au915_3.toml \
    file://sx1301/au915_4.toml \
    file://sx1301/au915_5.toml \
    file://sx1301/au915_6.toml \
    file://sx1301/au915_7.toml \
    file://sx1301/eu868.toml \
    file://sx1301/eu868_0.toml \
    file://sx1301/in865.toml \
    file://sx1301/in865_0.toml \
    file://sx1301/ru864.toml \
    file://sx1301/ru864_0.toml \
    file://sx1301/us915.toml \
    file://sx1301/us915_0.toml \
    file://sx1301/us915_1.toml \
    file://sx1301/us915_2.toml \
    file://sx1301/us915_3.toml \
    file://sx1301/us915_4.toml \
    file://sx1301/us915_5.toml \
    file://sx1301/us915_6.toml \
    file://sx1301/us915_7.toml \
    file://sx1302/global.toml \
    file://sx1302/as923.toml \
    file://sx1302/as923_0.toml \
    file://sx1302/au915.toml \
    file://sx1302/au915_0.toml \
    file://sx1302/au915_1.toml \
    file://sx1302/au915_2.toml \
    file://sx1302/au915_3.toml \
    file://sx1302/au915_4.toml \
    file://sx1302/au915_5.toml \
    file://sx1302/au915_6.toml \
    file://sx1302/au915_7.toml \
    file://sx1302/eu868.toml \
    file://sx1302/eu868_0.toml \
    file://sx1302/in865.toml \
    file://sx1302/in865_0.toml \
    file://sx1302/kr920.toml \
    file://sx1302/kr920_0.toml \
    file://sx1302/ru864.toml \
    file://sx1302/ru864_0.toml \
    file://sx1302/us915.toml \
    file://sx1302/us915_0.toml \
    file://sx1302/us915_1.toml \
    file://sx1302/us915_2.toml \
    file://sx1302/us915_3.toml \
    file://sx1302/us915_4.toml \
    file://sx1302/us915_5.toml \
    file://sx1302/us915_6.toml \
    file://sx1302/us915_7.toml \
    file://2g4/global.toml \
    file://2g4/ism2400.toml \
    file://2g4/ism2400_0.toml \
"
DEPENDS = "\
    clang-native \
    libloragw-2g4 \
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
    install -d ${D}${sysconfdir}/chirpstack-concentratord/sx1301/examples
    install -d ${D}${sysconfdir}/chirpstack-concentratord/sx1302/examples
    install -d ${D}${sysconfdir}/chirpstack-concentratord/2g4/examples
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
    install -m 0755 ${cargo_bindir}/chirpstack-concentratord-2g4 ${D}${bindir}
    install -m 0755 ${cargo_bindir}/gateway-id ${D}${bindir}

    install -m 0644 ${WORKDIR}/sx1301/*.toml ${D}${sysconfdir}/chirpstack-concentratord/sx1301/examples
    install -m 0644 ${WORKDIR}/sx1302/* ${D}${sysconfdir}/chirpstack-concentratord/sx1302/examples
    install -m 0644 ${WORKDIR}/2g4/* ${D}${sysconfdir}/chirpstack-concentratord/2g4/examples
}

PACKAGES += "${PN}-sx1301 ${PN}-sx1302 ${PN}-2g4"

FILES_${PN} = "${sysconfdir} ${bindir}/gateway-id"
FILES_${PN}-sx1301 = "${bindir}/chirpstack-concentratord-sx1301"
FILES_${PN}-sx1302 = "${bindir}/chirpstack-concentratord-sx1302"
FILES_${PN}-2g4 = "${bindir}/chirpstack-concentratord-2g4"
