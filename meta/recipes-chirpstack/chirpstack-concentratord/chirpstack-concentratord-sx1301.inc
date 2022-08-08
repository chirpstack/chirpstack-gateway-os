DEPENDS = "\
    clang-native \
    libloragw-sx1301 \
"

LIC_FILES_CHKSUM = " \
    file://LICENSE;md5=bc4546f147d6f9892ca1b7d23bf41196 \
"

export BINDGEN_EXTRA_CLANG_ARGS="-I${STAGING_INCDIR} -mfloat-abi=${TARGET_FPU}"

do_install:append() {
    install -d ${D}${sysconfdir}/chirpstack-concentratord/sx1301/examples
	install -m 0644 ${S}/chirpstack-concentratord-sx1301/config/*.toml ${D}${sysconfdir}/chirpstack-concentratord/sx1301/examples
}
