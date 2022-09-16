SUMMARY = "The Device Repository contains information about LoRaWAN end devices."
HOMEPAGE = "https://github.com/TheThingsNetwork/lorawan-devices"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=5335066555b14d832335aa4660d6c376"

SRC_URI = "\
	git://git@github.com/TheThingsNetwork/lorawan-devices.git;protocol=ssh;branch=master \
	file://import-lorawan-devices.init \
	file://import-lorawan-devices.sh \
"
SRCREV = "285163e828f6c188583bdcee927e63477cd0aca5"

inherit update-rc.d

INITSCRIPT_NAME = "import-lorawan-devices"
INITSCRIPT_PARAMS = "defaults"

S = "${WORKDIR}/git"

do_install() {
    install -d ${D}${sysconfdir}/init.d
	install -m 0755 ${WORKDIR}/import-lorawan-devices.init ${D}/${sysconfdir}/init.d/import-lorawan-devices

	install -d ${D}/opt/lorawan-devices
	find ./vendor -type d -exec install -d ${D}/opt/lorawan-devices/{} \;
	find ./vendor -regex ".*\.\(yaml\|js\)" -exec install -m 0644 {} ${D}/opt/lorawan-devices/{} \;
	echo ${SRCREV} > ${D}/opt/lorawan-devices/SRCREV
	echo "" > ${D}/opt/lorawan-devices/SRCREV.lastimport
	install -m 0755 ${WORKDIR}/import-lorawan-devices.sh ${D}/opt/lorawan-devices/import-lorawan-devices
}

FILES:${PN} = "\
	/opt/lorawan-devices \
	/etc/init.d/import-lorawan-devices \
"

do_compile[noexec] = "1"
do_configure[noexec] = "1"
