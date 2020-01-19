FILESEXTRAPATHS_prepend_rpi := "${THISDIR}/patches:"

SRC_URI_append_rpi = " \
    file://bootcount.patch \
    file://disable-console-to-fix-gps.patch \
"


