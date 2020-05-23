DESCRIPTION = "SWUpdate image for the ChirpStack Gateway OS base image"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

inherit swupdate

SRC_URI = "\
    file://sw-description \
"

IMAGE_DEPENDS = "chirpstack-gateway-os-base"
SWUPDATE_IMAGES = "chirpstack-gateway-os-base"
SWUPDATE_IMAGES_FSTYPES[chirpstack-gateway-os-base] = ".ext4.gz"
