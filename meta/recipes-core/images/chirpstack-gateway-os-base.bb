DESCRIPTION = "Image including the LoRa packet-forwarder and ChirpStack Gateway Bridge component installed."

require recipes-core/images/core-image-minimal.bb

IMAGE_INSTALL += " \
    packagegroup-base \
    ca-certificates \
    sudo \
    iptables \
    ntp \
    monit \
    tcpdump \
    wireguard-client-config \
    lora-packet-forwarder \
    chirpstack-gateway-bridge \
"

inherit extrausers

EXTRA_USERS_PARAMS = "useradd -P admin admin;"
