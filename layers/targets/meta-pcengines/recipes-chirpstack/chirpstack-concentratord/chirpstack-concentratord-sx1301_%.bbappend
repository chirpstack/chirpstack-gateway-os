FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append = "\
    file://sx1301/global.toml \
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
    file://sx1301/us915.toml \
    file://sx1301/us915_0.toml \
    file://sx1301/us915_1.toml \
    file://sx1301/us915_2.toml \
    file://sx1301/us915_3.toml \
    file://sx1301/us915_4.toml \
    file://sx1301/us915_5.toml \
    file://sx1301/us915_6.toml \
    file://sx1301/us915_7.toml \
"

do_install_append() {
    install -d ${D}${sysconfdir}/chirpstack-concentratord/sx1301/examples
    install -m 0644 ${WORKDIR}/sx1301/*.toml ${D}${sysconfdir}/chirpstack-concentratord/sx1301/examples
}
