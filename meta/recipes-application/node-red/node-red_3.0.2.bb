DESCRIPTION = "Node-RED"
HOMEPAGE = "http://nodered.org"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=014f1a23c3da49aa929b21a96808ab22"
PR = "r0"

inherit update-rc.d npm

INITSCRIPT_NAME = "node-red"
INITSCRIPT_PARAMS = "defaults"

SRC_URI = "\
    git://github.com/node-red/node-red.git;protocol=https;branch=master \
    npmsw://${THISDIR}/${BPN}/npm-shrinkwrap.json \
    file://node-red.init \
    file://node-red.default \
"

SRCREV = "5365786386e21df74b339a399e854ed89af6394f"

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

# fix 'non -staticdev package contains static .a library' error
INSANE_SKIP:${PN}:append = "staticdev"
