---
title: Changelog
menu:
    main:
        parent: overview
        weight: 2
toc: false
---

# Changelog

## v3.3.0-test.6

### Features

* Support has been added for the Raspberry Pi 4.
* Support has been added for the Raspberry Pi Zero W.
* Support has been added for the RAK2246 and RAK2246G shields.
* Class-B beacon configuration has been added to the band configuration.

### Updates

* [ChirpStack Application Server](https://www.chirpstack.io/application-server/) is updated to v3.10.0.
* [ChirpStack Concentratord](https://github.com/brocaar/chirpstack-concentratord) is updated to v3.0.0-test.9.
* [ChirpStack Network Server](https://www.chirpstack.io/network-server/) is updated to v3.9.0.

### Improvements

* `gateway-config` shows ChirpStack Gateway OS version.
* `gateway-config` shows Gateway ID.
* Change ISM band names to their common name. ([#47](https://github.com/brocaar/chirpstack-gateway-os/pull/47))
* `sx1301-reset` script has been modified to leave the reset pin as output.

## v3.3.0-test.5

### Updates

* [ChirpStack Application Server](https://www.chirpstack.io/application-server/) is updated to v3.9.0.
* [ChirpStack Concentratord](https://github.com/brocaar/chirpstack-concentratord) is updated to v3.0.0-test.8.
* [ChirpStack Network Server](https://www.chirpstack.io/network-server/) is updated to v3.8.1.

### Features

#### Wifi Access Point mode

On initial installation on a Raspberry Pi 3, the Raspberry Pi will start Wifi
in Access Point mode, so that it is possible to connect directly to the
Raspberry Pi over WIFI for configuration of the concentrator shield and to
re-configure the WIFI.

### Improvements

* RAK2245 configuration has been improved (using defined Concentratord model name).
* RAK832 configuration has been improved.
* RAK2245 / RAK831 AS923 channel-plan has been added. ([#43](https://github.com/brocaar/chirpstack-gateway-os/pull/43))

### Bugfixes

* Fix passing incorrect model flags in `gateway-config` for some gateways.

## v3.3.0-test.4

When updating from a previous v3.3.0 version, it is recommended to re-run the
`gateway-config` utility to update the concentrator configuration.

### Updates

* [ChirpStack Concentratord](https://github.com/brocaar/chirpstack-concentratord) is updated to v3.0.0-test.6.

## v3.3.0-test.3

### Updates

* [ChirpStack Gateway Bridge](https://www.chirpstack.io/gateway-bridge/) is updated to v3.7.1.

## v3.3.0-test.2

### Updates

* [ChirpStack Gateway Bridge](https://www.chirpstack.io/gateway-bridge/) is updated to v3.7.0.
* [ChirpStack Network Server](https://www.chirpstack.io/network-server/) is updated to v3.7.0.
* [ChirpStack Application Server](https://www.chirpstack.io/application-server/) is updated to v3.8.0.
* [ChirpStack Concentratord](https://github.com/brocaar/chirpstack-concentratord) is updated to v3.0.0-test.5.

### Supported hardware

* Raspberry Pi 1 B+ support has been added (for IMST Lite Gateway)
* [IMST Lite Gateway](https://wireless-solutions.de/products/long-range-radio/lora-lite-gateway.html) has been added to gateway configuration script.

## v3.3.0-test.1

**This is a rewrite of the ChirpStack Gateway OS, you must re-flash your SD Card
to update!** Currently this version only targets the Raspberry Pi 3.

### Features

* Yocto has been updated to version 3.0.
* Software updates are now handled by [SWUpdate](https://github.com/sbabic/swupdate).
* The Semtech UDP Packet Forwarder has been replaced by [ChirpStack Concentratord](https://github.com/brocaar/chirpstack-concentratord).

### Updates

* [ChirpStack Gateway Bridge](https://www.chirpstack.io/gateway-bridge/) is updated to v3.7.0-test.2.
* [ChirpStack Network Server](https://www.chirpstack.io/network-server/) is updated to v3.7.0-test.1.
* [ChirpStack Application Server](https://www.chirpstack.io/application-server/) is updated to v3.8.0-test.1.

### Fixes

* Redis database does not start on boot after power failure that corrupts append only file. ([#32](https://github.com/brocaar/chirpstack-gateway-os/issues/32))

## v3.2.0test1

### General

* Update ChirpStack Gateway Bridge to v3.5.0.
* Update ChirpStack Network Server to v3.5.0.
* Update ChirpStack Application Server to v3.6.1.

### Features

* Add support for [Semtech SX1302 CoreCell](https://www.semtech.com/products/wireless-rf/lora-gateways/sx1302cxxxgw1) evaluation kit.

### Bugfixes

* Fix boot issue due to storage device not yet initialized. ([#9](https://github.com/brocaar/chirpstack-gateway-os/issues/9))
* Fix ChirpStack Network Server `enabled_uplink_channels` configuration. ([#26](https://github.com/brocaar/chirpstack-gateway-os/issues/26))

## v3.1.0test1

This release renames LoRa Gateway OS to ChirpStack Gateway OS.
See the [Rename Announcement](https://www.chirpstack.io/r/rename-announcement) for more information.

## v3.0.0test3

### LORIX One

* Fix Wiregard kernel module dependencies.

## v3.0.0test2

### General

* Update LoRa App Server to v3.2.0.
* Update LoRa Gateway Bridge to v3.1.0.
* Update LoRa Server to v3.1.0.
* Update Monit to 5.26.0 and set check interval to 10 seconds.
* Add `PersistentKeepalive = 25` to Wiregard example config.
* Update openembedded layers to latest versions.

### Raspberry Pi

* Fix concentrator ordering.

## v3.0.0test1

### General

* LoRa App Server v3.1.0.
* LoRa Server v3.0.2.
* LoRa Gateway Bridge v3.0.1.

### Raspberry Pi

* Add support for the [Pi Supply LoRa Gateway Hat](https://uk.pi-supply.com/products/iot-lora-gateway-hat-for-raspberry-pi).
* Fix HDMI related boot issue. ([#9](https://github.com/brocaar/lora-gateway-os/issues/9))

## v2.0.0test4

### General

* Add Wiregard VPN client
* Bump LoRa Server package versions

### Raspberry Pi

* Change SPI speed to 2MHz (required by RAK2245)
* Add IMST iC980A configuration
* Add RAK2245 configuration

### LORIX One 512MB

* Fix u-boot command

## v2.0.0test3

### LORIX One

* Fix setting the MAC address from EEPROM.

## v2.0.0test2

### General

* Implement Mender for (OTA) system updates.
* Implement OverlayFS over read-only root filesystem.
* Update LoRa Gateway Bridge to v2.6.2.
* [lora-gateway-os-full] Update LoRa Server to v2.4.1.

### Raspberry Pi

* Add support for Sandbox Electronics LoRaGo PORT concentrator.
* Implement all US915 and AU915 channel-blocks. ([#2](https://github.com/brocaar/lora-gateway-os/pull/2))
* [lora-gateway-os-full] Automatic (re)configure LoRa Server on setting the concentrator channel-plan.

## v2.0.0test1

* Initial test release.
