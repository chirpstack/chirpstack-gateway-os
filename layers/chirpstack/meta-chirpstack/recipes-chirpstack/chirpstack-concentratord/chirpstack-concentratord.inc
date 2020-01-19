inherit cargo

HOMEPAGE = "https://www.chirpstack.io/"
PRIORITY = "optional"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSE;md5=99e425257f8a67b7efd81dc0009ed8ff"

SRC_URI += "git://github.com/brocaar/chirpstack-concentratord.git;protocol=git;nobranch=1"
SRCREV="3818a5ac094fffdee640cca1768fb75d595f9640"
S = "${WORKDIR}/git"

DEPENDS = "\
    clang-native \
    libloragw-sx1301 \
    libloragw-sx1302 \
"

RDEPENDS_${PN} = "\
    chirpstack-concentratord-base \
"

export LIBCLANG_PATH="${STAGING_LIBDIR_NATIVE}"
export BINDGEN_EXTRA_CLANG_ARGS="-I${STAGING_INCDIR} -mfloat-abi=hard"

SRC_URI += " \
    crate://crates.io/aho-corasick/0.7.6 \
    crate://crates.io/ansi_term/0.11.0 \
    crate://crates.io/atty/0.2.13 \
    crate://crates.io/autocfg/0.1.7 \
    crate://crates.io/bindgen/0.52.0 \
    crate://crates.io/bitflags/1.2.1 \
    crate://crates.io/byteorder/1.3.2 \
    crate://crates.io/c2-chacha/0.2.3 \
    crate://crates.io/cc/1.0.48 \
    crate://crates.io/cexpr/0.3.6 \
    crate://crates.io/cfg-if/0.1.10 \
    crate://crates.io/chirpstack_api/3.0.5 \
    crate://crates.io/chrono/0.4.10 \
    crate://crates.io/clang-sys/0.28.1 \
    crate://crates.io/clap/2.33.0 \
    crate://crates.io/cmake/0.1.42 \
    crate://crates.io/colored/1.9.0 \
    crate://crates.io/env_logger/0.7.1 \
    crate://crates.io/error-chain/0.10.0 \
    crate://crates.io/getrandom/0.1.13 \
    crate://crates.io/glob/0.3.0 \
    crate://crates.io/hex/0.3.2 \
    crate://crates.io/hex/0.4.0 \
    crate://crates.io/humantime-serde/0.1.1 \
    crate://crates.io/humantime/1.3.0 \
    crate://crates.io/lazy_static/1.4.0 \
    crate://crates.io/lazycell/1.2.1 \
    crate://crates.io/libc/0.2.66 \
    crate://crates.io/libloading/0.5.2 \
    crate://crates.io/log/0.4.8 \
    crate://crates.io/memchr/2.2.1 \
    crate://crates.io/metadeps/1.1.2 \
    crate://crates.io/nom/4.2.3 \
    crate://crates.io/num-integer/0.1.41 \
    crate://crates.io/num-traits/0.2.10 \
    crate://crates.io/peeking_take_while/0.1.2 \
    crate://crates.io/pkg-config/0.3.17 \
    crate://crates.io/ppv-lite86/0.2.6 \
    crate://crates.io/proc-macro2/1.0.6 \
    crate://crates.io/protobuf/2.8.1 \
    crate://crates.io/quick-error/1.2.2 \
    crate://crates.io/quote/1.0.2 \
    crate://crates.io/rand/0.7.2 \
    crate://crates.io/rand_chacha/0.2.1 \
    crate://crates.io/rand_core/0.5.1 \
    crate://crates.io/rand_hc/0.2.0 \
    crate://crates.io/redox_syscall/0.1.56 \
    crate://crates.io/regex-syntax/0.6.12 \
    crate://crates.io/regex/1.3.1 \
    crate://crates.io/rustc-hash/1.0.1 \
    crate://crates.io/serde/1.0.104 \
    crate://crates.io/serde_derive/1.0.104 \
    crate://crates.io/shlex/0.1.1 \
    crate://crates.io/simple_logger/1.3.0 \
    crate://crates.io/strsim/0.8.0 \
    crate://crates.io/syn/1.0.11 \
    crate://crates.io/termcolor/1.0.5 \
    crate://crates.io/textwrap/0.11.0 \
    crate://crates.io/thread_local/0.3.6 \
    crate://crates.io/time/0.1.42 \
    crate://crates.io/toml/0.2.1 \
    crate://crates.io/toml/0.5.5 \
    crate://crates.io/unicode-width/0.1.7 \
    crate://crates.io/unicode-xid/0.2.0 \
    crate://crates.io/uuid/0.8.1 \
    crate://crates.io/vec_map/0.8.1 \
    crate://crates.io/version_check/0.1.5 \
    crate://crates.io/wasi/0.7.0 \
    crate://crates.io/which/3.1.0 \
    crate://crates.io/winapi-i686-pc-windows-gnu/0.4.0 \
    crate://crates.io/winapi-util/0.1.2 \
    crate://crates.io/winapi-x86_64-pc-windows-gnu/0.4.0 \
    crate://crates.io/winapi/0.3.8 \
    crate://crates.io/wincolor/1.0.2 \
    crate://crates.io/zeromq-src/0.1.8+4.3.2 \
    crate://crates.io/zmq-sys/0.11.0 \
    crate://crates.io/zmq/0.9.2 \
    crate://crates.io/syslog/5.0.0 \
    crate://crates.io/error-chain/0.12.1 \
"

BBCLASSEXTEND = "native"
