DEPENDS = "\
    clang-native \
    libloragw-sx1302 \
"

LIC_FILES_CHKSUM = " \
    file://LICENSE;md5=99e425257f8a67b7efd81dc0009ed8ff \
"

export BINDGEN_EXTRA_CLANG_ARGS="-I${STAGING_INCDIR} -mfloat-abi=${TARGET_FPU}"

SRC_URI += "\
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
"

do_install:append() {
    install -d ${D}${sysconfdir}/chirpstack-concentratord/sx1302/examples

    install -m 0644 ${WORKDIR}/sx1302/*.toml ${D}${sysconfdir}/chirpstack-concentratord/sx1302/examples
}
