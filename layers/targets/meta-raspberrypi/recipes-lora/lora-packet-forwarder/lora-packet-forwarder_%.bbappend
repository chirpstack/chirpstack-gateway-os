SRC_URI_append = "file://lora-packet-forwarder.default \
                  file://ic880a/global_conf.eu868.json \
                  file://lorago_port/global_conf.eu868.json \
                  file://lorago_port/global_conf.us915_0.json \
                  file://lorago_port/global_conf.us915_1.json \
                  file://lorago_port/global_conf.us915_2.json \
                  file://lorago_port/global_conf.us915_3.json \
                  file://lorago_port/global_conf.us915_4.json \
                  file://lorago_port/global_conf.us915_5.json \
                  file://lorago_port/global_conf.us915_6.json \
                  file://lorago_port/global_conf.us915_7.json \
                  file://rak831/global_conf.au915_0.json \
                  file://rak831/global_conf.au915_1.json \
                  file://rak831/global_conf.au915_2.json \
                  file://rak831/global_conf.au915_3.json \
                  file://rak831/global_conf.au915_4.json \
                  file://rak831/global_conf.au915_5.json \
                  file://rak831/global_conf.au915_6.json \
                  file://rak831/global_conf.au915_7.json \
                  file://rak831/global_conf.eu868.json \
                  file://rak831/global_conf.us915_0.json \
                  file://rak831/global_conf.us915_1.json \
                  file://rak831/global_conf.us915_2.json \
                  file://rak831/global_conf.us915_3.json \
                  file://rak831/global_conf.us915_4.json \
                  file://rak831/global_conf.us915_5.json \
                  file://rak831/global_conf.us915_6.json \
                  file://rak831/global_conf.us915_7.json \
                  file://rhf0m301/global_conf.eu868.json \
                  file://rhf0m301/global_conf.us915.json \
"

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

do_install_append() {
    install -d ${D}${LORA_CONF_DIR}/ic880a
    install -d ${D}${LORA_CONF_DIR}/lorago_port
    install -d ${D}${LORA_CONF_DIR}/rak831
    install -d ${D}${LORA_CONF_DIR}/rhf0m301

    install -m 0644 ${WORKDIR}/ic880a/* ${D}${LORA_CONF_DIR}/ic880a
    install -m 0644 ${WORKDIR}/lorago_port/* ${D}${LORA_CONF_DIR}/lorago_port
    install -m 0644 ${WORKDIR}/rak831/* ${D}${LORA_CONF_DIR}/rak831
    install -m 0644 ${WORKDIR}/rhf0m301/* ${D}${LORA_CONF_DIR}/rhf0m301
}
