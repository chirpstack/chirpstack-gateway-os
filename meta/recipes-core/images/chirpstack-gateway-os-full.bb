DESCRIPTION = "Image including the LoRa packet-forwarder and the full ChirpStack open-source Network Server stack installed."

require recipes-core/images/chirpstack-gateway-os-base.bb

IMAGE_INSTALL += " \
    postgresql \
    postgresql-client \
    postgresql-contrib \
    redis \
    mosquitto \
    mosquitto-clients \
    firstbootinit \
    chirpstack-network-server \
    chirpstack-application-server \
"
