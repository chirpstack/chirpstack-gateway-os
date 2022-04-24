FILESEXTRAPATHS:prepend := "${THISDIR}/mosquitto:"

SRC_URI:append = "\
    file://mosquitto.conf \
    file://mosquitto.monit \
    file://acl \
"

do_install:append() {
    install -m 0644 ${WORKDIR}/mosquitto.conf ${D}${sysconfdir}/mosquitto/mosquitto.conf
    install -m 0644 ${WORKDIR}/acl ${D}${sysconfdir}/mosquitto/acl

    install -d ${D}${sysconfdir}/monit.d
    install -m 0644 ${WORKDIR}/mosquitto.monit ${D}${sysconfdir}/monit.d/mosquitto
}

FILES:${PN}:append = " ${sysconfdir}/monit.d"
