# Without this patch, the RAK2245 failed to start on a Raspberry Pi (3).

SRC_URI_append = " \
    file://loragw_spi.native.c.patch \
"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
