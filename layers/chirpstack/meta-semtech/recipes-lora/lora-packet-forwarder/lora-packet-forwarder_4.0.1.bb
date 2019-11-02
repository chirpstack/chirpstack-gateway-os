DESCRIPTION = "LoRa Packet Forwarder"
HOMEPAGE = "https://github.com/lora-net/packet_forwarder"
PRIORITY = "optional"
LICENSE = "BSD"
LIC_FILES_CHKSUM = "file://LICENSE;md5=22af7693d7b76ef0fc76161c4be76c45"
DEPENDS = "lora-gateway"
RDEPENDS_${PN} = "iproute2"
PR = "r8"

SRCREV = "v${PV}"
SRC_URI = "git://github.com/Lora-net/packet_forwarder.git;protocol=git \
           file://lora-packet-forwarder.init \
           file://lora-packet-forwarder.monit \
           file://lora-packet-forwarder.default \
"

inherit update-rc.d

INITSCRIPT_NAME = "lora-packet-forwarder"
INITSCRIPT_PARAMS = "defaults"

S = "${WORKDIR}/git"
LORA_DIR = "/opt/lora-packet-forwarder"
LORA_CONF_DIR = "${sysconfdir}/lora-packet-forwarder"

export LGW_PATH = "${STAGING_LIBDIR}/lora"
export LGW_INC = "${STAGING_INCDIR}/lora"
CFLAGS += "-I${STAGING_INCDIR}/lora -Iinc -I."

do_compile() {
    oe_runmake
}

do_install() {
    install -d ${D}${LORA_DIR}
    install -d ${D}${LORA_DIR}/utils

    install -m 0755 lora_pkt_fwd/lora_pkt_fwd ${D}${LORA_DIR}/
    install -m 0755 ${S}/lora_pkt_fwd/update_gwid.sh ${D}${LORA_DIR}/

    install -m 0755 util_sink/util_sink ${D}${LORA_DIR}/utils/
    install -m 0755 util_ack/util_ack ${D}${LORA_DIR}/utils/
    install -m 0755 util_tx_test/util_tx_test ${D}${LORA_DIR}/utils/

    install -d ${D}${sysconfdir}/init.d
    install -m 0755 ${WORKDIR}/lora-packet-forwarder.init ${D}${sysconfdir}/init.d/lora-packet-forwarder

    install -d ${D}${sysconfdir}/monit.d
    install -m 0644 ${WORKDIR}/lora-packet-forwarder.monit ${D}${sysconfdir}/monit.d/lora-packet-forwarder

    install -d ${D}${sysconfdir}/default
    install -m 0644 ${WORKDIR}/lora-packet-forwarder.default ${D}${sysconfdir}/default/lora-packet-forwarder

    install -d ${D}${LORA_CONF_DIR}
    install -d ${D}${LORA_CONF_DIR}/semtech
    install -m 0644 ${S}/lora_pkt_fwd/cfg/global_conf.json.* ${D}${LORA_CONF_DIR}/semtech
}

FILES_${PN} += "${LORA_DIR}"
FILES_${PN}-dbg += "${LORA_DIR}/.debug ${LORA_DIR}/utils/.debug"

INSANE_SKIP_${PN} = "ldflags"
