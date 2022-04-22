DESCRIPTION = "ChirpStack Node-RED nodes"
HOMEPAGE = "https://www.chirpstack.io/"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSE;md5=9d38c34220055ca274d97618d5979778"
PR = "r2"

inherit npm

SRC_URI = " \
	npm://registry.npmjs.org;package=@chirpstack/node-red-contrib-chirpstack;version=${PV} \
	npmsw://${THISDIR}/${BPN}/npm-shrinkwrap.json \
	file://remove-npm-prepare.patch \
"

SRCREV = "10fa4a63c7b677340ee0328c3d4968a614d25a72"

S = "${WORKDIR}/npm"

# Note that this is needed because the latest npm.bbclass seems to be broken.
# Without this and without the remove-npm-prepare.path, npm.bbclass fails to
# build the package. See also:
# https://github.com/intel-iot-devkit/meta-iot-cloud/commit/08d0c505097b889836315a4fe9b41acbb264be3f
EXTRA_OENPM = "--offline=false --proxy=false"

