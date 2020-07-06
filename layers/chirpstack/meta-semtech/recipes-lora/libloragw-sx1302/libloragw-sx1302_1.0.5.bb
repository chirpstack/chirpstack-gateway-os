DESCRIPTION = "Driver/HAL to build a gateway using a concentrator board based on Semtech SX1302"
HOMEPAGE = "https://github.com/Lora-net/sx1302_hal"
PRIORITY = "optional"
LICENSE = "BSD"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/BSD;md5=3775480a712fc46a69647678acb234cb"
PR = "r10"

SRC_URI = "\
    git://github.com/Lora-net/sx1302_hal.git;protocol=git;tag=V${PV} \
    file://library.cfg \
"

S = "${WORKDIR}/git"

# Use clang as we will be linking against this library using Rust. With the
# default gcc we get link errors.
TOOLCHAIN = "clang"

CFLAGS += "-I inc -I ../libtools/inc"

do_configure_append() {
    cp ${WORKDIR}/library.cfg ${S}/libloragw/library.cfg
}

do_compile() {
    oe_runmake
}

do_install() {
    install -d ${D}${libdir}/libloragw-sx1302
    install -d ${D}${includedir}/libloragw-sx1302

    install -m 0644 libtools/*.a ${D}${libdir}
    install -m 0644 libtools/inc/* ${D}${includedir}

    install -m 0644 libloragw/libloragw.a ${D}${libdir}/libloragw-sx1302.a
    install -m 0644 libloragw/inc/* ${D}${includedir}/libloragw-sx1302

    install -d ${D}/opt/libloragw-sx1302/gateway-utils
    install -m 0755 util_chip_id/chip_id ${D}/opt/libloragw-sx1302/gateway-utils
    install -m 0755 util_net_downlink/net_downlink ${D}/opt/libloragw-sx1302/gateway-utils

    install -m 0755 packet_forwarder/lora_pkt_fwd ${D}/opt/libloragw-sx1302/gateway-utils
    install -m 0755 tools/reset_lgw.sh ${D}/opt/libloragw-sx1302/gateway-utils
}

PACKAGES += "${PN}-utils"

FILES_${PN} = "${libdir}"
FILES_${PN}-staticdev = "${libdir}"
FILES_${PN}-dev = "${includedir}"
FILES_${PN}-utils = "/opt/libloragw-sx1302/gateway-utils"

INSANE_SKIP_${PN}-utils = "ldflags"
