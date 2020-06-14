# Fix for the following error:
# 'const struct ipv6_stub' has no member named 'ipv6_dst_lookup'
#
# Remove this when wireguard-module version > 1.0.20200401
# https://layers.openembedded.org/layerindex/branch/master/recipes/?q=wireguard
DEPENDS += " bc-native"
SRCREV = "abdb0c13da006290a07bf409618d12fc5e7a28d1"
