FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append = "\
    file://sx1302/global.toml \
    file://sx1302/eu868.toml \
    file://sx1302/eu868_0.toml \
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

do_install_append() {
    install -d ${D}${sysconfdir}/chirpstack-concentratord/sx1302/examples
    install -m 0644 ${WORKDIR}/sx1302/* ${D}${sysconfdir}/chirpstack-concentratord/sx1302/examples
}
