DESCRIPTION = "Driver/HAL to build a gateway using a concentrator board based on Semtech SX1301"
HOMEPAGE = "https://github.com/Lora-net/lora_gateway"
PRIORITY = "optional"
LICENSE = "BSD"
LIC_FILES_CHKSUM = "file://LICENSE;md5=a2bdef95625509f821ba00460e3ae0eb"
PR = "r8"
PRR = "r2"

SRC_URI = "\
    git://github.com/brocaar/lora_gateway.git;protocol=git;tag=v${PV}${PRR} \
    file://library.cfg \
"

S = "${WORKDIR}/git"

# Use clang as we will be linking against this library using Rust. With the
# default gcc we get link errors.
TOOLCHAIN = "clang"

CFLAGS += "-Iinc -I."

do_configure_append() {
    cp ${WORKDIR}/library.cfg ${S}/libloragw/library.cfg
}

do_compile() {
    oe_runmake
}

do_install() {
    install -d ${D}${libdir}/libloragw-sx1301
    install -d ${D}${includedir}/libloragw-sx1301

    install -m 0644 libloragw/libloragw.a ${D}${libdir}/libloragw-sx1301.a
    install -m 0644 libloragw/inc/* ${D}${includedir}/libloragw-sx1301

    install -d ${D}/opt/libloragw-sx1301/gateway-utils
    install -m 0755 libloragw/test_* ${D}/opt/libloragw-sx1301/gateway-utils/
    install -m 0755 util_pkt_logger/util_pkt_logger ${D}/opt/libloragw-sx1301/gateway-utils/
    install -m 0755 util_spectral_scan/util_spectral_scan ${D}/opt/libloragw-sx1301/gateway-utils/
    install -m 0755 util_spi_stress/util_spi_stress ${D}/opt/libloragw-sx1301/gateway-utils/
    install -m 0755 util_tx_test/util_tx_test ${D}/opt/libloragw-sx1301/gateway-utils/
    install -m 0755 util_tx_continuous/util_tx_continuous ${D}/opt/libloragw-sx1301/gateway-utils/
    install -m 0755 util_lbt_test/util_lbt_test ${D}/opt/libloragw-sx1301/gateway-utils/
}

PACKAGES += "${PN}-utils ${PN}-utils-dbg"

FILES_${PN}-staticdev = "${libdir}"
FILES_${PN}-utils = "/opt/libloragw-sx1301/gateway-utils/*"
FILES_${PN}-utils-dbg = "/opt/libloragw-sx1301/gateway-utils/.debug"
FILES_${PN}-dev = "${includedir}"

INSANE_SKIP_${PN}-utils = "ldflags"
