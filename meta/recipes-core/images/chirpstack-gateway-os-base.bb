DESCRIPTION = "Image including the LoRa packet-forwarder and ChirpStack Gateway Bridge component installed."

require recipes-core/images/core-image-minimal.bb

IMAGE_INSTALL += " \
    packagegroup-base \
    ca-certificates \
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
    chirpstack-gateway-bridge \
"

inherit extrausers

EXTRA_USERS_PARAMS = "useradd -P admin admin;"

ROOTFS_POSTPROCESS_COMMAND += "add_releaseinfo; "

add_releaseinfo () {
    echo "${DISTRO_VERSION}" > ${IMAGE_ROOTFS}${sysconfdir}/version
}
