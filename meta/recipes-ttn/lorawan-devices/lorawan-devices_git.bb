SUMMARY = "The Device Repository contains information about LoRaWAN end devices."
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=5335066555b14d832335aa4660d6c376"

SRC_URI = "git://git@github.com/TheThingsNetwork/lorawan-devices.git;protocol=ssh;branch=master"
SRCREV = "9e952e75eb6f2db204d9a19ff778bac12d2a2d08"

S = "${WORKDIR}/git"

do_install() {
	install -d ${D}/opt/lorawan-devices
	find ./vendor -type d -exec install -d ${D}/opt/lorawan-devices/{} \;
	find ./vendor -regex ".*\.\(yaml\|js\)" -exec install -m 0644 {} ${D}/opt/lorawan-devices/{} \;
}

FILES:${PN} = "/opt/lorawan-devices"
do_compile[noexec] = "1"
