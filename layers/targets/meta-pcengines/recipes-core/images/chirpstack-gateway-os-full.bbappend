IMAGE_FSTYPES = "ext4.gz wic.gz"
WKS_FILES = "chirpstack-gateway-os.wks"

IMAGE_INSTALL += "connman \
                  connman-client \
                  software-update \
                  chirpstack-concentratord-sx1301 \
                  chirpstack-concentratord-sx1302 \
                  gateway-config \
                  gateway-id \
"

DISTRO_FEATURES += "wifi"
