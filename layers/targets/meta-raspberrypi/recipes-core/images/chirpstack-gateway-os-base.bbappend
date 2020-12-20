IMAGE_FSTYPES = "ext4.gz wic.gz"
WKS_FILES = "chirpstack-gateway-os.wks"

IMAGE_INSTALL += "rpio \
                  rpi-gpio \
                  connman \
                  connman-client \
                  software-update \
                  gateway-config \
"

DISTRO_FEATURES += "wifi"
