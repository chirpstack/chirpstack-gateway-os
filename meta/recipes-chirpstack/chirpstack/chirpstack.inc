LIC_FILES_CHKSUM = " \
    file://LICENSE;md5=e52a56a5b272102f5f53d67fdc2dd122 \
"

SRC_URI += "\
    file://chirpstack.init \
    file://chirpstack.monit \
    file://chirpstack.toml \
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
	install -m 0640 ${WORKDIR}/chirpstack.toml ${D}${sysconfdir}/chirpstack/chirpstack.toml
	install -m 0640 ${S}/chirpstack/configuration/as923.toml ${D}${sysconfdir}/chirpstack/as923.toml
	install -m 0640 ${S}/chirpstack/configuration/as923_2.toml ${D}${sysconfdir}/chirpstack/as923_2.toml
	install -m 0640 ${S}/chirpstack/configuration/as923_3.toml ${D}${sysconfdir}/chirpstack/as923_3.toml
	install -m 0640 ${S}/chirpstack/configuration/as923_4.toml ${D}${sysconfdir}/chirpstack/as923_4.toml
	install -m 0640 ${S}/chirpstack/configuration/au915_0.toml ${D}${sysconfdir}/chirpstack/au915_0.toml
	install -m 0640 ${S}/chirpstack/configuration/cn779.toml ${D}${sysconfdir}/chirpstack/cn779.toml
	install -m 0640 ${S}/chirpstack/configuration/eu433.toml ${D}${sysconfdir}/chirpstack/eu433.toml
	install -m 0640 ${S}/chirpstack/configuration/eu868.toml ${D}${sysconfdir}/chirpstack/eu868.toml
	install -m 0640 ${S}/chirpstack/configuration/in865.toml ${D}${sysconfdir}/chirpstack/in865.toml
	install -m 0640 ${S}/chirpstack/configuration/ism2400.toml ${D}${sysconfdir}/chirpstack/ism2400.toml
	install -m 0640 ${S}/chirpstack/configuration/kr920.toml ${D}${sysconfdir}/chirpstack/kr920.toml
	install -m 0640 ${S}/chirpstack/configuration/ru864.toml ${D}${sysconfdir}/chirpstack/ru864.toml
	install -m 0640 ${S}/chirpstack/configuration/us915_0.toml ${D}${sysconfdir}/chirpstack/us915_0.toml
	install -m 0640 ${S}/chirpstack/configuration/us915_1.toml ${D}${sysconfdir}/chirpstack/us915_1.toml
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

CONFFILES_${PN} += "${sysconfdir}/chirpstack/chirpstack.toml"
