DEPENDS = "\
    clang-native \
    libloragw-2g4 \
"

LIC_FILES_CHKSUM = " \
    file://LICENSE;md5=99e425257f8a67b7efd81dc0009ed8ff \
"

export BINDGEN_EXTRA_CLANG_ARGS="-I${STAGING_INCDIR} -mfloat-abi=${TARGET_FPU}"

do_install:append() {
    install -d ${D}${sysconfdir}/chirpstack-concentratord/2g4/examples
	install -m 0644 ${S}/chirpstack-concentratord-2g4/config/*.toml ${D}${sysconfdir}/chirpstack-concentratord/2g4/examples
}
