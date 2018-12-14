FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI_append = "file://ntp.conf"

do_install_append() {
    install -m 0644 ${WORKDIR}/ntp.conf ${D}${sysconfdir}
}

