FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append = " file://fw_env.config"

do_install_append() {
	install -d ${D}${sysconfdir}
	install -m 644 ${WORKDIR}/fw_env.config ${D}${sysconfdir}
}

FILES_${PN}_append = " ${sysconfdir}"
