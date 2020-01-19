FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append = "\
    file://fstab \
"

do_install_append() {
    install -d ${D}/etc
    install -d ${D}/data
    install -m 644 ${WORKDIR}/fstab ${D}/etc/fstab
}
