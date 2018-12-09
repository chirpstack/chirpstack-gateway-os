SRC_URI_append = "file://lora-packet-forwarder.default \
                  file://lorixone/global_conf_AU915_2dBi_indoor.json \
                  file://lorixone/global_conf_AU915_4dBi_outdoor.json \
                  file://lorixone/global_conf_EU868_2dBi_indoor.json \
                  file://lorixone/global_conf_EU868_4dBi_outdoor.json \
                  file://lorixone/global_conf_US915_2dBi_indoor.json \
                  file://lorixone/global_conf_US915_4dBi_outdoor.json \
"

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

do_install_append() {
    install -d ${D}${LORA_CONF_DIR}/lorixone

    install -m 0644 ${WORKDIR}/lorixone/* ${D}${LORA_CONF_DIR}/lorixone
}
