DESCRIPTION = "Driver/HAL to build a gateway using a concentrator board based on Semtech 2.4GHz"
HOMEPAGE = "https://github.com/Lora-net/gateway_2g4_hal"
PRIORITY = "optional"
LICENSE = "BSD"
LIC_FILES_CHKSUM = "file://LICENSE.TXT;md5=ca326f6e7b5a58bffccfde6e1c998d69"
PR = "r1"
RDEPENDS_${PN}-utils = "dfu-util"

SRC_URI = "\
	git://github.com/Lora-net/gateway_2g4_hal.git;protocol=git;tag=V${PV} \
    file://library.cfg \
"

S = "${WORKDIR}/git"

# Use clang as we will be linking against this library using Rust. With the
# default gcc we get link errors.
TOOLCHAIN = "clang"

CFLAGS += "-I inc -I ../libtools/inc"

do_configure:append() {
    cp ${WORKDIR}/library.cfg ${S}/libloragw/library.cfg
}

do_compile() {
    oe_runmake
}

do_install() {
    install -d ${D}${libdir}/libloragw-2g4
    install -d ${D}${includedir}/libloragw-2g4

    install -m 0644 libloragw/libloragw.a ${D}${libdir}/libloragw-2g4.a
    install -m 0644 libloragw/inc/* ${D}${includedir}/libloragw-2g4

	install -d ${D}/opt/libloragw-2g4/gateway-utils
	install -d ${D}/opt/libloragw-2g4/mcu_bin
	install -m 0755 util_boot/boot ${D}/opt/libloragw-2g4/gateway-utils/

	# Note: if the .bin version changes, make sure to update gateway-config.sh too!
	install -m 0644 mcu_bin/rlz_fwm_gtw_2g4_01.00.01.bin ${D}/opt/libloragw-2g4/mcu_bin/
}

PACKAGES += "${PN}-utils ${PN}-utils-dbg"

FILES:${PN}-staticdev = "${libdir}"
FILES:${PN}-utils = "/opt/libloragw-2g4/gateway-utils/* /opt/libloragw-2g4/mcu_bin/*"
FILES:${PN}-utils-dbg = "/opt/libloragw-2g4/gateway-utils/.debug"
FILES:${PN}-dev = "${includedir}"

INSANE_SKIP:${PN}-utils = "ldflags"
