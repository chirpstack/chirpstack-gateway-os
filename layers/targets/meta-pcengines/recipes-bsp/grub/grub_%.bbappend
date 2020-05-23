FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += " \
    file://grub.cfg \
    file://grubenv \
    "

do_install_append(){
    # provide custom grub config
    install -m 644 ${WORKDIR}/grub.cfg ${DEPLOY_DIR_IMAGE}
    install -m 644 ${WORKDIR}/grubenv ${DEPLOY_DIR_IMAGE}
}
