DESCRIPTION = "Node-RED"
HOMEPAGE = "http://nodered.org"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=d6f37569f5013072e9490d2194d10ae6"
PR = "r2"

inherit update-rc.d npm

INITSCRIPT_NAME = "node-red"
INITSCRIPT_PARAMS = "defaults"

RDEPENDS:${PN} = "bash nodejs-npm"

SRC_URI = " \
	npm://registry.npmjs.org;package=node-red;version=${PV} \
	npmsw://${THISDIR}/${BPN}/npm-shrinkwrap.json \
	file://node-red.init \
	file://node-red.default \
"

S = "${WORKDIR}/npm"

do_install:append() {
    install -d ${D}${sysconfdir}/init.d
    install -d ${D}${sysconfdir}/default

    install -m 0755 ${WORKDIR}/node-red.init ${D}${sysconfdir}/init.d/node-red
	install -m 0644 ${WORKDIR}/node-red.default ${D}${sysconfdir}/default/node-red
}

# fix 'non -staticdev package contains static .a library' error
INSANE_SKIP:${PN}:append = "staticdev"
