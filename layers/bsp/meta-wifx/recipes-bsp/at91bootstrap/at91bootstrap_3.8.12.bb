require at91bootstrap.inc

LIC_FILES_CHKSUM = "file://main.c;endline=27;md5=a2a70db58191379e2550cbed95449fbd"

COMPATIBLE_MACHINE = '(lorix-one|lorix-one-sd|lorix-one-512|lorix-one-512-sd)'

SRC_URI = "https://github.com/linux4sam/at91bootstrap/archive/v${PV}.tar.gz;name=tarball"
FILESEXTRAPATHS_prepend := "${THISDIR}/patches:"

# LORIX One board files
SRC_URI_append = " \
    file://contrib/board/wifx/lorix_one/Config.in.board \
    file://contrib/board/wifx/lorix_one/Config.in.boardname \
    file://contrib/board/wifx/lorix_one/Config.in.linux_arg \
    file://contrib/board/wifx/lorix_one/board.mk \
    file://contrib/board/wifx/lorix_one/lorix_one.c \
    file://contrib/board/wifx/lorix_one/lorix_one_nf_uboot_defconfig \
    file://contrib/board/wifx/lorix_one/lorix_one_sd_uboot_defconfig \
    file://contrib/board/wifx/lorix_one/lorix_one.h \
"

# LORIX One 512 board files
SRC_URI_append = " \
    file://contrib/board/wifx/lorix_one_512/Config.in.board \
    file://contrib/board/wifx/lorix_one_512/Config.in.boardname \
    file://contrib/board/wifx/lorix_one_512/Config.in.linux_arg \
    file://contrib/board/wifx/lorix_one_512/board.mk \
    file://contrib/board/wifx/lorix_one_512/lorix_one_512.c \
    file://contrib/board/wifx/lorix_one_512/lorix_one_512_nf_uboot_defconfig \
    file://contrib/board/wifx/lorix_one_512/lorix_one_512_sd_uboot_defconfig \
    file://contrib/board/wifx/lorix_one_512/lorix_one_512.h \
"

# Patches
SRC_URI_append = " \
   file://Makefile.patch \ 
   file://contrib-board-Config.in.board.patch \
   file://contrib-board-Config.in.boardname.patch \
   file://contrib-board-Config.in.linux_arg.patch \
   file://contrib-include-contrib_board.h.patch \
   file://driver-at91_twi.c.patch \
   file://driver-board_hw_info.c.patch \
   file://include-board_hw_info.h.patch \
   file://include-twi.h.patch \
   file://scripts-addpmecchead.py.patch \
"

PR = "r4"

SRC_URI[tarball.md5sum] = "9cdcd5b427a7998315e9a0cad4488ffd"
SRC_URI[tarball.sha256sum] = "871140177e2cab7eeed572556025f9fdc5e82b2bb18302445d13db0f95e21694"

