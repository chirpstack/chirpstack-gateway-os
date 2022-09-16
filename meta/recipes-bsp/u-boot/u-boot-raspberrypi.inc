FILESEXTRAPATHS:prepend := "${THISDIR}/patches:"
FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append = " \
    file://bootcount.patch \
    file://rpi.patch \
    file://pi3-device-tree.patch \
    file://pi0-wifi-device-tree.patch \
"

do_install:append() {
  install -d ${D}${sysconfdir}
  install -m 0644 ${WORKDIR}/fw_env.config ${D}${sysconfdir}/fw_env.config
}
