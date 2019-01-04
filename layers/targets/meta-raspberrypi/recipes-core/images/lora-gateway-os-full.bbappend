IMAGE_INSTALL += "wiringpi \
                  rpio \
                  rpi-gpio \
                  connman \
                  connman-client \
                  bluez5 \
                  gateway-config \
"

DISTRO_FEATURES += "wifi"

# Mender configuration
MENDER_STORAGE_TOTAL_SIZE_MB = "1024"
MENDER_DATA_PART_SIZE_MB = "512"
