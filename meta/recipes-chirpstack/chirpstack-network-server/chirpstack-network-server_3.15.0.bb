DESCRIPTION = "ChirpStack Network Server"
HOMEPAGE = "https://www.chirpstack.io/"
PRIORITY = "optional"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSE;md5=e3a340e43ab9867d3e5d0ea79a54b0e1"
SRC_URI = " \
    git://git@github.com/brocaar/chirpstack-network-server.git;protocol=https;tag=v${PV}; \
    file://chirpstack-network-server.init \
    file://chirpstack-network-server.monit \
    file://config/as923.toml \
    file://config/au915_0.toml \
    file://config/au915_1.toml \
    file://config/au915_2.toml \
    file://config/au915_3.toml \
    file://config/au915_4.toml \
    file://config/au915_5.toml \
    file://config/au915_6.toml \
    file://config/au915_7.toml \
    file://config/eu868.toml \
    file://config/in865.toml \
    file://config/kr920.toml \
    file://config/ru864.toml \
    file://config/us915_0.toml \
    file://config/us915_1.toml \
    file://config/us915_2.toml \
    file://config/us915_3.toml \
    file://config/us915_4.toml \
    file://config/us915_5.toml \
    file://config/us915_6.toml \
    file://config/us915_7.toml \
"
PR = "r2"

inherit update-rc.d goarch

INITSCRIPT_NAME = "chirpstack-network-server"
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
    install -m 0755 ${S}/build/chirpstack-network-server ${D}${bindir}

    install -d ${D}${sysconfdir}/chirpstack-network-server/config
    install -m 0640 ${WORKDIR}/config/* ${D}${sysconfdir}/chirpstack-network-server/config

    install -d ${D}${sysconfdir}/init.d
    install -m 0755 ${WORKDIR}/chirpstack-network-server.init ${D}${sysconfdir}/init.d/chirpstack-network-server

    install -d ${D}${sysconfdir}/monit.d
    install -m 0644 ${WORKDIR}/chirpstack-network-server.monit ${D}${sysconfdir}/monit.d/chirpstack-network-server
}

# fix already stripped error
INSANE_SKIP:${PN}:append = "already-stripped"
