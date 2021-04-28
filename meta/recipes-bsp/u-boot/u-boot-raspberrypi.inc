FILESEXTRAPATHS_prepend := "${THISDIR}/patches:"

SRC_URI_append = " \
    file://bootcount.patch \
    file://rpi.patch \
    file://pi3-device-tree.patch \
    file://pi0-wifi-device-tree.patch \
"
