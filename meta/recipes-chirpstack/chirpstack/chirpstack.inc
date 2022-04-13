LIC_FILES_CHKSUM = " \
    file://LICENSE;md5=e52a56a5b272102f5f53d67fdc2dd122 \
"

SRC_URI += "\
    file://chirpstack.init \
    file://chirpstack.monit \
    file://chirpstack.toml \
    file://region_as923.toml \
    file://region_as923_2.toml \
    file://region_as923_3.toml \
    file://region_as923_4.toml \
    file://region_au915_0.toml \
    file://region_au915_1.toml \
    file://region_au915_2.toml \
    file://region_au915_3.toml \
    file://region_au915_4.toml \
    file://region_au915_5.toml \
    file://region_au915_6.toml \
    file://region_au915_7.toml \
    file://region_cn779.toml \
    file://region_eu433.toml \
    file://region_eu868.toml \
    file://region_in865.toml \
    file://region_ism2400.toml \
    file://region_kr920.toml \
    file://region_ru864.toml \
    file://region_us915_0.toml \
    file://region_us915_1.toml \
    file://region_us915_2.toml \
    file://region_us915_3.toml \
    file://region_us915_4.toml \
    file://region_us915_5.toml \
    file://region_us915_6.toml \
    file://region_us915_7.toml \
"

inherit update-rc.d

INITSCRIPT_NAME = "chirpstack"
INITSCRIPT_PARAMS = "defaults"

do_compile:prepend() {
    cd "${S}/ui"
    oe_runmake
}

do_install:append() {
    install -d ${D}${sysconfdir}/init.d
    install -m 0755 ${WORKDIR}/chirpstack.init ${D}${sysconfdir}/init.d/chirpstack

    install -d ${D}${sysconfdir}/monit.d
    install -m 0644 ${WORKDIR}/chirpstack.monit ${D}${sysconfdir}/monit.d/chirpstack

    install -d ${D}${sysconfdir}/chirpstack
    install -m 0640 ${WORKDIR}/*.toml ${D}${sysconfdir}/chirpstack/
}

export OPENSSL_NO_VENDOR="1"
export OPENSSL_LIB_DIR="${STAGING_LIBDIR}"
export OPENSSL_INCLUDE_DIR="${STAGING_INCDIR}/openssl"
export PQ_LIB_DIR="#{STAGING_LIBDIR}"
export NODE_OPTIONS="--openssl-legacy-provider"
export OPENSSL_MODULES="${WORKDIR}/recipe-sysroot-native/usr/lib/ossl-modules"

DEPENDS = "\
    openssl-native \
    postgresql \
    clang-native \
    nodejs-native \
    yarn-native \
"

CONFFILES:${PN} += "${sysconfdir}/chirpstack/chirpstack.toml"
