DESCRIPTION = "Image including the LoRa packet-forwarder and ChirpStack Gateway Bridge component installed."

require recipes-core/images/core-image-minimal.bb

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
