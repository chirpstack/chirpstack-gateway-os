DEPENDS = "\
    clang-native \
    libloragw-2g4 \
"

LIC_FILES_CHKSUM = " \
    file://LICENSE;md5=99e425257f8a67b7efd81dc0009ed8ff \
"

export BINDGEN_EXTRA_CLANG_ARGS="-I${STAGING_INCDIR} -mfloat-abi=${TARGET_FPU}"

SRC_URI += "\
    file://2g4/global.toml \
    file://2g4/ism2400.toml \
    file://2g4/ism2400_0.toml \
"

do_install:append() {
    install -d ${D}${sysconfdir}/chirpstack-concentratord/2g4/examples

    install -m 0644 ${WORKDIR}/2g4/*.toml ${D}${sysconfdir}/chirpstack-concentratord/2g4/examples
}
