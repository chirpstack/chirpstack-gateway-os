DESCRIPTION = "Driver/HAL to build a gateway using a concentrator board based on Semtech SX1302"
HOMEPAGE = "https://github.com/Lora-net/sx1302_hal"
PRIORITY = "optional"
LICENSE = "BSD"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/BSD;md5=3775480a712fc46a69647678acb234cb"
PR = "r9"

SRC_URI = "git://github.com/Lora-net/sx1302_hal.git;protocol=git \
           file://library.cfg \
           file://lora-sx1302-hal-packet-forwarder.monit \
           file://lora-sx1302-hal-packet-forwarder.init \
           file://corecell/global_conf.eu868.json \
           file://corecell/global_conf.us915_1.json \
"
SRCREV = "5942224602c5ee14469db6605b48a6fc57ff7a18"

inherit update-rc.d

INITSCRIPT_NAME = "lora-sx1302-hal-packet-forwarder"
INITSCRIPT_PARAMS = "defaults"

S = "${WORKDIR}/git"
CFLAGS += "-I inc -I ../libtools/inc"

do_configure_append() {
    cp ${WORKDIR}/library.cfg ${S}/libloragw/library.cfg
}

do_compile() {
    oe_runmake
}

do_install() {
    install -d ${D}${libdir}/lora-sx1302-hal
    install -d ${D}${includedir}/lora-sx1302-hal

    install -m 0644 libloragw/libloragw.a ${D}${libdir}/lora-sx1302-hal
    install -m 0644 libloragw/library.cfg ${D}${libdir}/lora-sx1302-hal
    install -m 0644 libloragw/inc/* ${D}${includedir}/lora-sx1302-hal

    install -d ${D}/opt/lora-sx1302-hal-utils
    install -d ${D}/opt/lora-sx1302-hal-packet-forwarder
    install -m 0755 util_chip_id/chip_id ${D}/opt/lora-sx1302-hal-utils
    install -m 0755 util_net_downlink/net_downlink ${D}/opt/lora-sx1302-hal-utils

    install -m 0755 packet_forwarder/lora_pkt_fwd ${D}/opt/lora-sx1302-hal-packet-forwarder
    install -m 0755 tools/reset_lgw.sh ${D}/opt/lora-sx1302-hal-packet-forwarder

    install -d ${D}${sysconfdir}/init.d
    install -m 0755 ${WORKDIR}/lora-sx1302-hal-packet-forwarder.init ${D}${sysconfdir}/init.d/lora-sx1302-hal-packet-forwarder

    install -d ${D}${sysconfdir}/monit.d
    install -m 0644 ${WORKDIR}/lora-sx1302-hal-packet-forwarder.monit ${D}${sysconfdir}/monit.d/lora-sx1302-hal-packet-forwarder

    install -d ${D}${sysconfdir}/lora-sx1302-hal-packet-forwarder
    install -d ${D}${sysconfdir}/lora-sx1302-hal-packet-forwarder/corecell
    install -m 0644 ${WORKDIR}/corecell/* ${D}${sysconfdir}/lora-sx1302-hal-packet-forwarder/corecell
}

PACKAGES += "${PN}-utils ${PN}-packet-forwarder"

FILES_${PN} = "${libdir}/lora-sx1302-hal/*"
FILES_${PN}-staticdev = "${libdir}/lora-sx1302-hal"
FILES_${PN}-dev = "${includedir}/lora-sx1302-hal"
FILES_${PN}-utils = "/opt/lora-sx1302-hal-utils"
FILES_${PN}-packet-forwarder = "/opt/lora-sx1302-hal-packet-forwarder /etc/*"
