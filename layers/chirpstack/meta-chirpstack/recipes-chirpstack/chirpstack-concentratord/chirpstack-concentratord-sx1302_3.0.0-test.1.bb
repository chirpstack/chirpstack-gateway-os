require chirpstack-concentratord.inc

SUMMARY = "ChirpStack Concentratord for SX1302"
PR = "r2"

CARGO_SRC_DIR = "chirpstack-concentratord-sx1302"

do_install() {
    install -d ${D}${bindir}
    install -m 0755 ${B}/target/${CARGO_TARGET_SUBDIR}/chirpstack-concentratord-sx1302 ${D}${bindir}
}
