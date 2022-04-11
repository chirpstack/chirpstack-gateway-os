DESCRIPTION = "Image including the LoRa packet-forwarder and ChirpStack Gateway Bridge component installed."

require recipes-core/images/core-image-minimal.bb

IMAGE_FSTYPES = "ext4.gz wic.gz"
WKS_FILES = "chirpstack-gateway-os.wks"

# rng-tools is used to speed up /dev/random. This is used by Monit to generate a
# random id. Without it, it can in some cases (Pi 4) take minutes to start up!
IMAGE_INSTALL += " \
    packagegroup-base \
    ca-certificates \
    rng-tools \
    bash \
    sudo \
    iptables \
    ntp \
    opkg \
    swupdate \
    swupdate-tools \
    u-boot-fw-utils \
    lua \
    monit \
    tcpdump \
    wireguard-client-config \
    rpio \
    rpi-gpio \
    connman \
    connman-client \
    software-update \
    gateway-config \
    chirpstack-concentratord-base \
    gateway-id \
    chirpstack-concentratord-sx1301 \
    chirpstack-concentratord-sx1302 \
    chirpstack-concentratord-2g4 \
    chirpstack-gateway-bridge \
    chirpstack-udp-bridge \
    libloragw-sx1302-utils \
    libloragw-2g4-utils \
"

inherit extrausers

EXTRA_USERS_PARAMS = "useradd -P admin admin;"

ROOTFS_POSTPROCESS_COMMAND += "add_releaseinfo; initramfs_image; "

add_releaseinfo () {
    echo "${DISTRO_VERSION}" > ${IMAGE_ROOTFS}${sysconfdir}/version
}

initramfs_image() {
    rm ${IMAGE_ROOTFS}/boot/uImage*
    cp ${DEPLOY_DIR_IMAGE}/uImage-initramfs-${MACHINE}.bin ${IMAGE_ROOTFS}/boot/uImage
}
