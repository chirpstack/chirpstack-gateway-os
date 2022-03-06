DESCRIPTION = "ChirpStack Application Server"
HOMEPAGE = "https://www.chirpstack.io/"
PRIORITY = "optional"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSE;md5=5301050fd7cd58850085239d559297be"
SRC_URI = " \
    git://git@github.com/brocaar/chirpstack-application-server.git;protocol=https;tag=v${PV}; \
    file://chirpstack-application-server.toml \
    file://chirpstack-application-server.init \
    file://chirpstack-application-server.monit \
"
PR = "r3"

inherit update-rc.d goarch

INITSCRIPT_NAME = "chirpstack-application-server"
INITSCRIPT_PARAMS = "defaults"

S = "${WORKDIR}/git"

DEPENDS = "go-native nodejs-native"

# Make sure that make runs one job at a time.
PARALLEL_MAKE = ""

export GOOS = "${TARGET_GOOS}"
export GOARCH = "${TARGET_GOARCH}"
export GOARM = "${TARGET_GOARM}"
export GOCACHE = "${WORKDIR}/go/cache"
export HOME = "${WORKDIR}"

do_configure[noexec] = "1"

do_compile() {
    oe_runmake ui-requirements
    oe_runmake clean
    oe_runmake build

    # Clear the modcache. go mod sets the permissions such that yocto will
    # raise permission errors when cleaning up the directory.
    go clean -modcache
}

do_install() {
    install -d ${D}${bindir}
    install -m 0755 ${S}/build/chirpstack-application-server ${D}${bindir}

    install -d ${D}${sysconfdir}/chirpstack-application-server
    install -m 0640 ${WORKDIR}/chirpstack-application-server.toml ${D}${sysconfdir}/chirpstack-application-server/chirpstack-application-server.toml

    install -d ${D}${sysconfdir}/init.d
    install -m 0755 ${WORKDIR}/chirpstack-application-server.init ${D}${sysconfdir}/init.d/chirpstack-application-server

    install -d ${D}${sysconfdir}/monit.d
    install -m 0644 ${WORKDIR}/chirpstack-application-server.monit ${D}${sysconfdir}/monit.d/chirpstack-application-server
}

CONFFILES_${PN} += "${sysconfdir}/chirpstack-application-server/chirpstack-application-server.toml"

# fix already stripped error
INSANE_SKIP:${PN}:append = "already-stripped"
