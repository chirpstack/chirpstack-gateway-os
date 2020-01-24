require chirpstack-concentratord.inc

SUMMARY = "ChirpStack Concentratord for SX1301"
PR = "r3"

CARGO_SRC_DIR = "chirpstack-concentratord-sx1301"

do_install() {
    install -d ${D}${bindir}
    install -m 0755 ${B}/target/${CARGO_TARGET_SUBDIR}/chirpstack-concentratord-sx1301 ${D}${bindir}
}
