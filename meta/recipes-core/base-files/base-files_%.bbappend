FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI_append = "\
	file://path.sh \
    file://fstab \
    file://connman/main.conf \
    file://connman/settings \
"

do_install_append() {
    install -d ${D}/etc/profile.d
    install -d ${D}/etc
    install -d ${D}/data

    install -m 755 ${WORKDIR}/path.sh ${D}/etc/profile.d/path.sh
    install -m 644 ${WORKDIR}/fstab ${D}/etc/fstab
}

# wifi access-point settings
do_install_append_raspberrypi3() {
    install -d ${D}/etc/connman
    install -d ${D}/var/lib/connman
    install -m 644 ${WORKDIR}/connman/main.conf ${D}/etc/connman/main.conf
    install -m 644 ${WORKDIR}/connman/settings ${D}/var/lib/connman/settings
}

# wifi access-point settings
do_install_append_raspberrypi4() {
    install -d ${D}/etc/connman
    install -d ${D}/var/lib/connman
    install -m 644 ${WORKDIR}/connman/main.conf ${D}/etc/connman/main.conf
    install -m 644 ${WORKDIR}/connman/settings ${D}/var/lib/connman/settings
}

# wifi access-point settings
do_install_append_raspberrypi0-wifi() {
    install -d ${D}/etc/connman
    install -d ${D}/var/lib/connman
    install -m 644 ${WORKDIR}/connman/main.conf ${D}/etc/connman/main.conf
    install -m 644 ${WORKDIR}/connman/settings ${D}/var/lib/connman/settings
}
