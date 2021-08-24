DESCRIPTION = "Small image capable of mounting an overlayfs on top of a ready-only root-filesystem."
LICENSE = "MIT"

PACKAGE_INSTALL = "initramfs-readonly-rootfs-overlay ${VIRTUAL-RUNTIME_base-utils} udev base-passwd ${ROOTFS_BOOTSTRAP_INSTALL}"

# Do not pollute the initrd image with rootfs features
IMAGE_FEATURES = ""
IMAGE_INSTALL = ""
IMAGE_LINGUAS = ""

IMAGE_FSTYPES = "${INITRAMFS_FSTYPES}"
IMAGE_ROOTFS_SIZE = "8192"
IMAGE_ROOTFS_EXTRA_SPACE = "0"

inherit image
