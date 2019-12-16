IMAGE_INSTALL += "rpio \
                  rpi-gpio \
                  connman \
                  connman-client \
                  bluez5 \
                  gateway-config \
                  lora-sx1302-hal-utils \
                  lora-sx1302-hal-packet-forwarder \
"

DISTRO_FEATURES += "wifi"
