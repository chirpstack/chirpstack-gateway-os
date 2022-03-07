FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

DEPENDS += " openssl"

SRC_URI:append = "\
    file://01-commit-upgrade \
"

do_install:append() {
    install -m 0644 ${WORKDIR}/01-commit-upgrade ${D}${libdir}/swupdate/conf.d/
}
