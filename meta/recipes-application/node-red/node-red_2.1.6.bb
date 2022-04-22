DESCRIPTION = "Node-RED"
HOMEPAGE = "http://nodered.org"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=d6f37569f5013072e9490d2194d10ae6"
PR = "r0"

inherit update-rc.d npm

INITSCRIPT_NAME = "node-red"
INITSCRIPT_PARAMS = "defaults"

SRC_URI = "\
    git://github.com/node-red/node-red.git;protocol=https;branch=master \
    npmsw://${THISDIR}/${BPN}/npm-shrinkwrap.json \
    file://Fixup-dependencies-for-newer-npm-versions.patch \
    file://node-red.init \
    file://node-red.default \
"

SRCREV = "173e75175eb1c40e7b11c8da4bccba8f2eb22937"

S = "${WORKDIR}/git/packages/node_modules/${BPN}"

EXTRA_OENPM = "--offline=false --proxy=false"

do_install:append() {
    install -d ${D}${sysconfdir}/init.d
    install -d ${D}${sysconfdir}/default

    install -m 0755 ${WORKDIR}/node-red.init ${D}${sysconfdir}/init.d/node-red
    install -m 0644 ${WORKDIR}/node-red.default ${D}${sysconfdir}/default/node-red

    # Remove hardware specific files
    rm ${D}/${bindir}/${BPN}-pi
    rm -rf ${D}/${libdir}/node_modules/${BPN}/bin
}
