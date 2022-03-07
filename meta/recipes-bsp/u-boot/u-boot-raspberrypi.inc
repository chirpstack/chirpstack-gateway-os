FILESEXTRAPATHS:prepend := "${THISDIR}/patches:"

SRC_URI:append = " \
    file://bootcount.patch \
    file://rpi.patch \
    file://pi3-device-tree.patch \
    file://pi0-wifi-device-tree.patch \
"
