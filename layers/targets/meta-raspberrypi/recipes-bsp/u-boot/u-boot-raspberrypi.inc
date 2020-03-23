FILESEXTRAPATHS_prepend_rpi := "${THISDIR}/patches:"

SRC_URI_append_rpi = " \
    file://bootcount.patch \
    file://rpi.patch \
    file://pi3-device-tree.patch \
    file://pi0-wifi-device-tree.patch \
"


