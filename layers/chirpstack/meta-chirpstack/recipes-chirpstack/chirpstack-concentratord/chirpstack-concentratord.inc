inherit cargo

HOMEPAGE = "https://www.chirpstack.io/"
PRIORITY = "optional"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSE;md5=99e425257f8a67b7efd81dc0009ed8ff"

SRC_URI = "git://github.com/brocaar/chirpstack-concentratord.git;protocol=git;tag=v${PV}"
S = "${WORKDIR}/git"

DEPENDS = "\
    clang-native \
    libloragw-sx1301 \
    libloragw-sx1302 \
"

RDEPENDS_${PN} = "\
    chirpstack-concentratord-base \
"

export BINDGEN_EXTRA_CLANG_ARGS="-I${STAGING_INCDIR}"
