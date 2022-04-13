DESCRIPTION = "ChirpStack Node-RED nodes"
HOMEPAGE = "https://www.chirpstack.io/"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSE;md5=9d38c34220055ca274d97618d5979778"
PR = "r2"

inherit npm

SRC_URI = " \
	npm://registry.npmjs.org;package=@chirpstack/node-red-contrib-chirpstack;version=${PV} \
"

S = "${WORKDIR}/npm"
