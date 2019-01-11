SYSTEMD_AUTO_ENABLE = "disable"
MENDER_FEATURES_DISABLE_append = " mender-systemd"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append = " \
    file://mender.default \
    file://mender.init \
"

inherit update-rc.d

INITSCRIPT_NAME = "mender"
INITSCRIPT_PARAMS = "defaults"

do_install_append() {
    install -d ${D}${sysconfdir}/init.d
    install -m 0750 ${WORKDIR}/mender.init ${D}${sysconfdir}/init.d/mender

    install -d ${D}${sysconfdir}/default
    install -m 0644 ${WORKDIR}/mender.default ${D}${sysconfdir}/default/mender
}
