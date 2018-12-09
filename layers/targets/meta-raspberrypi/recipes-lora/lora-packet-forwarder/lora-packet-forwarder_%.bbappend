SRC_URI_append = "file://lora-packet-forwarder.default \
                  file://ic880a/global_conf.eu868.json \
                  file://ic880a/global_conf.us915.json \
                  file://rak381/global_conf.eu868.json \
                  file://rak381/global_conf.eu868.json.gps \
                  file://rak381/global_conf.us915.json \
                  file://rak381/global_conf.us915.json.gps \
                  file://rhf0m301/global_conf.eu868.json \
                  file://rhf0m301/global_conf.us915.json \
"

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

do_install_append() {
    install -d ${D}${LORA_CONF_DIR}/ic880a
    install -d ${D}${LORA_CONF_DIR}/rak381
    install -d ${D}${LORA_CONF_DIR}/rhf0m301

    install -m 0644 ${WORKDIR}/ic880a/* ${D}${LORA_CONF_DIR}/ic880a
    install -m 0644 ${WORKDIR}/rak381/* ${D}${LORA_CONF_DIR}/rak381
    install -m 0644 ${WORKDIR}/rhf0m301/* ${D}${LORA_CONF_DIR}/rhf0m301
}
