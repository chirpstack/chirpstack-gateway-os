SRC_URI_append = "file://lora-packet-forwarder.default \
                  file://rak831/global_conf.us_902_928.json \
                  file://rak831/global_conf.ru_864_870.json \
                  file://rak831/global_conf.kr_920_923.json \
                  file://rak831/global_conf.in_865_867.json \
                  file://rak831/global_conf.eu_863_870.json \
                  file://rak831/global_conf.eu_433.json \
                  file://rak831/global_conf.cn_470_510.json \
                  file://rak831/global_conf.au_915_928.json \
                  file://rak831/global_conf.as_923.json \
	          file://dbs-data \
"

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

do_install_append() {
#    install -d ${D}${LORA_CONF_DIR}/ic880a
    install -d ${D}${LORA_CONF_DIR}/rak831
#    install -d ${D}${LORA_CONF_DIR}/rhf0m301  

#    install -m 0644 ${WORKDIR}/ic880a/* ${D}${LORA_CONF_DIR}/ic880a
    install -m 0644 ${WORKDIR}/rak831/* ${D}${LORA_CONF_DIR}/rak831
    install -m 644 ${WORKDIR}/dbs-data ${D}${LORA_CONF_DIR}/rak831/dbs-data.tar.gz
    install -m 0755 ${WORKDIR}/rak831/global_conf.eu_863_870.json ${D}${LORA_CONF_DIR}/global_conf.json
#    install -m 0644 ${WORKDIR}/rhf0m301/* ${D}${LORA_CONF_DIR}/rhf0m301
}
