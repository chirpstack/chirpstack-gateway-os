FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append = "file://admin \
"

do_install:append() {
    install -d ${D}/etc/sudoers.d
    install -m 0644 ${WORKDIR}/admin ${D}/etc/sudoers.d/admin
}
