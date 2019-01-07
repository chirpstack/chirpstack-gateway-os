DESCRIPTION = "Small image capable of mounting an overlayfs on top of a ready-only root-filesyste."
LICENSE = "MIT"

do_image_mender[noexec] = "1"
do_image_sdimg[noexec] = "1"

PACKAGE_INSTALL = "initramfs-readonly-rootfs-overlay ${VIRTUAL-RUNTIME_base-utils} udev base-passwd ${ROOTFS_BOOTSTRAP_INSTALL}"

# Do not pollute the initrd image with rootfs features
IMAGE_FEATURES = ""
IMAGE_INSTALL = ""
IMAGE_LINGUAS = ""

# Avoid dependency loops
EXTRA_IMAGEDEPENDS = ""
KERNELDEPMODDEPEND = ""

IMAGE_FSTYPES = "${INITRAMFS_FSTYPES}"
IMAGE_ROOTFS_SIZE = "8192"
IMAGE_ROOTFS_EXTRA_SPACE = "0"

inherit image
