FILESEXTRAPATHS:prepend := "${THISDIR}/mosquitto:"

SRC_URI:append = "\
    file://mosquitto.conf \
"

do_install:append() {
    install -m 0644 ${WORKDIR}/mosquitto.conf ${D}${sysconfdir}/mosquitto/mosquitto.conf
}
