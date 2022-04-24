DESCRIPTION = "Cloudflare's PKI and TLS toolki "
HOMEPAGE = "http://cfssl.org/"
PRIORITY = "optional"
LICENSE = "BSD"
LIC_FILES_CHKSUM = "file://LICENSE;md5=9bd1e7022303d9bbc29fda142f3e4fd0"
SRCREV = "e6502bb7ffe4ee576227c9123a101deda248884c"
SRC_URI ="\
    git://git@github.com/cloudflare/cfssl.git;protocol=https;branch=master \
"
PR = "r1"

inherit goarch

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
    go build cmd/cfssl/cfssl.go
    go build cmd/cfssljson/cfssljson.go

    # Clear the modcache. go mod sets the permissions such that yocto will
    # raise permission errors when cleaning up the directory.
    go clean -modcache
}

do_install() {
    install -d ${D}${bindir}
    install -m 0755 ${S}/cfssl ${D}${bindir}
    install -m 0755 ${S}/cfssljson ${D}${bindir}
}

# fix already stripped error
INSANE_SKIP:${PN}:append = "already-stripped"
