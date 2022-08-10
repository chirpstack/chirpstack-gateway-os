DESCRIPTION = "ChirpStack Gateway Bridge"
HOMEPAGE = "https://www.chirpstack.io/"
PRIORITY = "optional"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSE;md5=bc4546f147d6f9892ca1b7d23bf41196"
SRCREV = "7d628ede65533b3fe55f62b844e1f1481fe767a2"
SRC_URI = " \
    git://git@github.com/chirpstack/chirpstack-gateway-bridge.git;protocol=https;branch=master \
    file://chirpstack-gateway-bridge.toml \
    file://chirpstack-gateway-bridge.init \
    file://chirpstack-gateway-bridge.monit \
"
PR = "r3"

inherit update-rc.d goarch

INITSCRIPT_NAME = "chirpstack-gateway-bridge"
INITSCRIPT_PARAMS = "defaults"

S = "${WORKDIR}/git"

DEPENDS = "go-native"

# Make sure that make runs one job at a time.
PARALLEL_MAKE = ""

export GOOS = "${TARGET_GOOS}"
export GOARCH = "${TARGET_GOARCH}"
export GOARM = "${TARGET_GOARM}"
export GOCACHE = "${WORKDIR}/go/cache"
export HOME = "${WORKDIR}"

do_configure[noexec] = "1"

do_compile() {
    oe_runmake

    # Clear the modcache. go mod sets the permissions such that yocto will
    # raise permission errors when cleaning up the directory.
    go clean -modcache
}

do_install() {
    install -d ${D}${bindir}
    install -m 0755 ${S}/build/chirpstack-gateway-bridge ${D}${bindir}

    install -d ${D}${sysconfdir}/chirpstack-gateway-bridge
    install -m 0640 ${WORKDIR}/chirpstack-gateway-bridge.toml ${D}${sysconfdir}/chirpstack-gateway-bridge/chirpstack-gateway-bridge.toml

    install -d ${D}${sysconfdir}/init.d
    install -m 0755 ${WORKDIR}/chirpstack-gateway-bridge.init ${D}${sysconfdir}/init.d/chirpstack-gateway-bridge

    install -d ${D}${sysconfdir}/monit.d
    install -m 0644 ${WORKDIR}/chirpstack-gateway-bridge.monit ${D}${sysconfdir}/monit.d/chirpstack-gateway-bridge
}

CONFFILES_${PN} += "${sysconfdir}/chirpstack-gateway-bridge/chirpstack-gateway-bridge.toml"

# fix already stripped error
INSANE_SKIP:${PN}:append = "already-stripped"
