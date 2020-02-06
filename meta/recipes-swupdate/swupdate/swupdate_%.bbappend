FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

DEPENDS += " openssl"

SRC_URI_append = "\
    file://01-commit-upgrade \
"

do_install_append() {
    install -m 0644 ${WORKDIR}/01-commit-upgrade ${D}${libdir}/swupdate/conf.d/
}
