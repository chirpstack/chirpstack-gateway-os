FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI_append = "file://admin \
"

do_install_append() {
    install -d ${D}/etc/sudoers.d
    install -m 0644 ${WORKDIR}/admin ${D}/etc/sudoers.d/admin
}
