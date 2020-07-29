IMAGE_FSTYPES = "ext4.gz wic.gz"
WKS_FILES = "chirpstack-gateway-os.wks"

IMAGE_INSTALL += "rpio \
                  rpi-gpio \
                  connman \
                  connman-client \
                  software-update \
                  chirpstack-concentratord \
                  chirpstack-concentratord-sx1301 \
                  chirpstack-concentratord-sx1302 \
                  gateway-config \
"

DISTRO_FEATURES += "wifi"
