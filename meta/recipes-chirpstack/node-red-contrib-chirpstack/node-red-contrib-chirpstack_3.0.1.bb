DESCRIPTION = "ChirpStack Node-RED nodes"
HOMEPAGE = "https://www.chirpstack.io/"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSE;md5=9d38c34220055ca274d97618d5979778"
PR = "r1"

inherit npm

# DEPENDS = "zlib openssl"

SRC_URI = " \
	npm://registry.npmjs.org;package=@chirpstack/node-red-contrib-chirpstack;version=${PV} \
	npmsw://${THISDIR}/${BPN}/npm-shrinkwrap.json \
"

S = "${WORKDIR}/npm"
