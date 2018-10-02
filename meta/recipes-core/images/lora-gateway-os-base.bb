DESCRIPTION = "Image including the LoRa packet-forwarder and LoRa Gateway Bridge component installed."

require recipes-core/images/core-image-minimal.bb

IMAGE_INSTALL += "packagegroup-base \
                  sudo \
                  iptables \
                  monit \
                  lora-packet-forwarder \
                  lora-gateway-bridge \
"

inherit extrausers

EXTRA_USERS_PARAMS = "useradd -P admin admin;"
