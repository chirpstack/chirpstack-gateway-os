IMAGE_INSTALL += "wiringpi \
                  rpio \
                  rpi-gpio \
                  connman \
                  connman-client \
                  bluez5 \
                  gateway-config \
"

DISTRO_FEATURES += "wifi"

SDIMG_COMPRESSION = "gzip"
