#!/bin/sh

do_import_lorawan_devices() {
	# This might fail if the ChirpStack database has not been initialized.
	# We will retry until success.
	while :
	do
		chirpstack -c /etc/chirpstack import-legacy-lorawan-devices-repository -d /opt/lorawan-devices
		RET=$?
		if [ $RET -eq 0 ]; then
			cp /opt/lorawan-devices/SRCREV /opt/lorawan-devices/SRCREV.lastimport
			break
		fi

		sleep 1
	done
}

OUT=$(cmp /opt/lorawan-devices/SRCREV /opt/lorawan-devices/SRCREV.lastimport)
RET=$?
if [ ! $RET -eq 0 ]; then
	do_import_lorawan_devices
fi
