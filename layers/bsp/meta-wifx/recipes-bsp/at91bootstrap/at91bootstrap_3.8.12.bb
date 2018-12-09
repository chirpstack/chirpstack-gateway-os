require at91bootstrap.inc

LIC_FILES_CHKSUM = "file://main.c;endline=27;md5=a2a70db58191379e2550cbed95449fbd"

COMPATIBLE_MACHINE = '(sama5d4-lorix-one|sama5d4-lorix-one-sd|sama5d4-lorix-one-512|sama5d4-lorix-one-512-sd)'

SRC_URI = "https://github.com/linux4sam/at91bootstrap/archive/v${PV}.tar.gz;name=tarball \
           file://lorixone.patch \
"

PR = "r3"

SRC_URI[tarball.md5sum] = "9cdcd5b427a7998315e9a0cad4488ffd"
SRC_URI[tarball.sha256sum] = "871140177e2cab7eeed572556025f9fdc5e82b2bb18302445d13db0f95e21694"
