DESCRIPTION = "This package converts any file into managable Go source code. \
Useful for embedding binary data into a go program. The file data is \
optionally gzip compressed before being converted to a raw byte slice."
HOMEPAGE = "https://github.com/jteeuwen/go-bindata"
LICENSE = "CC0-1.0"
LIC_FILES_CHKSUM = "file://src/${GO_IMPORT}/LICENSE;md5=8dcedca69f7a474372829521f37954b1"

GO_IMPORT = "github.com/jteeuwen/go-bindata"
SRC_URI = "git://${GO_IMPORT}"

SRCREV = "6025e8de665b31fa74ab1a66f2cddd8c0abf887e"

inherit go

GO_INSTALL = "${GO_IMPORT}/go-bindata"

BBCLASSEXTEND = "native nativesdk"
