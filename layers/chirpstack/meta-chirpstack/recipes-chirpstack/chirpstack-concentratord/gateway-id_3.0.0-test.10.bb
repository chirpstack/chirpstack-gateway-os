require chirpstack-concentratord.inc

SUMMARY = "ChirpStack Concentratord gateway-id utility"
PR = "r1"

do_install() {
    install -d ${D}${bindir}
    if [ "${CARGO_BUILD_TYPE}" = "--release" ]; then
        local cargo_bindir="${CARGO_RELEASE_DIR}"
    else
        local cargo_bindir="${CARGO_DEBUG_DIR}"
    fi

    install -m 0755 ${cargo_bindir}/gateway-id ${D}${bindir}
}
