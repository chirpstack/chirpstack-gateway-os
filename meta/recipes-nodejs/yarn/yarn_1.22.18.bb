DESCRIPTION = "Yarn, Fast, reliable, and secure dependency management."
HOMEPAGE="https://github.com/yarnpkg/yarn"
LICENSE = "BSD"
LIC_FILES_CHKSUM = "file://LICENSE;md5=9afb19b302b259045f25e9bb91dd34d6"
PR = "r1"

inherit npm

RDEPENDS:${PN} = "nodejs-npm"

SRC_URI = " \
    npm://registry.npmjs.org;package=yarn;version=${PV} \
"

S = "${WORKDIR}/npm"
BBCLASSEXTEND = "native"
