SECTION = "kernel"
DESCRIPTION = "Linux kernel for Atmel ARM SoCs (aka AT91)"
SUMMARY = "Linux kernel for Atmel ARM SoCs (aka AT91)"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://COPYING;md5=d7810fab7487fb0aad327b76f1be7cd7"

inherit kernel

RDEPENDS_kernel-base=""
FILESEXTRAPATHS_prepend := "${THISDIR}/${BPN}-4.4:"

PV = "4.4+git${SRCPV}"
PR = "r2"

S = "${WORKDIR}/git"

SRCREV = "${AUTOREV}"

KBRANCH = "linux-4.4-at91"
SRC_URI = "git://github.com/Wifx/linux-at91.git;branch=${KBRANCH}"

SRC_URI += "file://sama5d4_lorix_one_defconfig"

python __anonymous () {
	if d.getVar('UBOOT_FIT_IMAGE', True) == 'xyes':
		d.appendVar('DEPENDS', ' u-boot-mkimage-native dtc-native')
}

do_deploy_append() {
	if [ "${UBOOT_FIT_IMAGE}" = "xyes" ]; then
		DTB_PATH="${B}/arch/${ARCH}/boot/dts/"
		if [ ! -e "${DTB_PATH}" ]; then
			DTB_PATH="${B}/arch/${ARCH}/boot/"
		fi

		if [ -e ${S}/arch/${ARCH}/boot/dts/${MACHINE}.its ]; then
			cp ${S}/arch/${ARCH}/boot/dts/${MACHINE}*.its ${DTB_PATH}
			cd ${DTB_PATH}
			mkimage -f ${MACHINE}.its ${MACHINE}.itb
			install -m 0644 ${MACHINE}.itb ${DEPLOYDIR}/${MACHINE}.itb
			cd -
		fi
	fi
}

kernel_do_configure_prepend() {
	if [ -f "${WORKDIR}/sama5d4_lorix_one_defconfig" ] && [ ! -f "${B}/.config" ]; then
		cp "${WORKDIR}/sama5d4_lorix_one_defconfig" "${B}/.config"
	fi
}

kernel_do_configure_append() {
	rm -f ${B}/.scmversion ${S}/.scmversion
	cd ${S}; git status; cd -
}


KERNEL_MODULE_AUTOLOAD += "atmel_usba_udc g_serial"

COMPATIBLE_MACHINE = "(sama5d4-lorix-one|sama5d4-lorix-one-sd|sama5d4-lorix-one-512|sama5d4-lorix-one-512-sd)"
