require u-boot-atmel.inc

LICENSE = "GPLv2+"
LIC_FILES_CHKSUM = "file://README;beginline=1;endline=22;md5=2687c5ebfd9cb284491c3204b726ea29"

SRCREV = "${AUTOREV}"

PV = "v2017.03-at91+git${SRCPV}"
PR = "r2"

COMPATIBLE_MACHINE = '(sama5d4-lorix-one|sama5d4-lorix-one-sd|sama5d4-lorix-one-512|sama5d4-lorix-one-512-sd)'

SRC_URI = "git://github.com/Wifx/u-boot-at91.git;branch=u-boot-2017.03-at91"

S = "${WORKDIR}/git"

PACKAGE_ARCH = "${MACHINE_ARCH}"

