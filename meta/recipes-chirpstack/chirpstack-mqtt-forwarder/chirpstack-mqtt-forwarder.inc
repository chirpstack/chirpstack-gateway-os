LIC_FILES_CHKSUM = " \
    file://LICENSE;md5=bc4546f147d6f9892ca1b7d23bf41196 \
"

SRC_URI += "\
    file://remove-release-profile.patch \
"

export OPENSSL_NO_VENDOR="1"
export OPENSSL_LIB_DIR="${STAGING_LIBDIR}"
export OPENSSL_INCLUDE_DIR="${STAGING_INCDIR}/openssl"

DEPENDS = "\
	protobuf-native \
    openssl \
    clang-native \
"
