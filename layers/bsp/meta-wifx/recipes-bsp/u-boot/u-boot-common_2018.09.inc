HOMEPAGE = "http://www.denx.de/wiki/U-Boot/WebHome"
SECTION = "bootloaders"
DEPENDS += "flex-native bison-native"

LICENSE = "GPLv2+"
LIC_FILES_CHKSUM = "file://Licenses/README;md5=30503fd321432fc713238f582193b78e"
PR = "r3"

# We use the revision in order to avoid having to fetch it from the
# repo during parse
SRCREV = "5a1ff6e103ac132ea5d3b2ef768c035f0c83cb9e"

SRC_URI = "git://git.denx.de/u-boot.git"

S = "${WORKDIR}/git"

FILESEXTRAPATHS_prepend := "${THISDIR}/patches:"

# matching at91-sama5_common.h
BOOTENV_SIZE = "0x4000"

# LORIX One generic files
SRC_URI_append = " \
    file://arch/arm/dts/lorix-one-base.dtsi \
    file://board/wifx/common/Makefile \
    file://board/wifx/common/mac_eeprom.c \
"

# LORIX One board files
SRC_URI_append = " \
    file://arch/arm/dts/lorix-one.dts \
    file://board/wifx/lorix-one/Kconfig \
    file://board/wifx/lorix-one/MAINTAINERS \
    file://board/wifx/lorix-one/Makefile \
    file://board/wifx/lorix-one/lorix-one.c \
    file://configs/lorix_one_mmc_defconfig \
    file://configs/lorix_one_nandflash_defconfig \
    file://include/configs/lorix-one.h \
"

# LORIX One 512 board files
SRC_URI_append = " \
    file://arch/arm/dts/lorix-one-512.dts \
    file://board/wifx/lorix-one-512/Kconfig \
    file://board/wifx/lorix-one-512/MAINTAINERS \
    file://board/wifx/lorix-one-512/Makefile \
    file://board/wifx/lorix-one-512/lorix-one-512.c \
    file://configs/lorix_one_512_mmc_defconfig \
    file://configs/lorix_one_512_nandflash_defconfig \
    file://include/configs/lorix-one-512.h \
"

# Patches
SRC_URI_append = " \
    file://Makefile.patch \
    file://arch-arm-dts-Makefile.patch \
    file://arch-arm-mach-at91-Kconfig.patch \
    file://include-configs-at91-sama5_common.h.patch \
    file://cmd-nvedit.c.patch \
    file://include-common.h.patch \
"

do_configure_prepend() {
    do_copy_wifx_config
}

do_copy_wifx_config() {
    cp ${WORKDIR}/arch/arm/dts/* ${S}/arch/arm/dts
    cp -r ${WORKDIR}/board/wifx ${S}/board
    cp ${WORKDIR}/configs/* ${S}/configs
    cp ${WORKDIR}/include/configs/* ${S}/include/configs
}
