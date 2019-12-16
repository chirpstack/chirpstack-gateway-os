---
title: Changelog
menu:
    main:
        parent: overview
        weight: 2
---

# Changelog

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
