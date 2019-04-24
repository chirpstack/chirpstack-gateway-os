---
title: Changelog
menu:
    main:
        parent: overview
        weight: 2
---

# Changelog

## v2.0.0test4

### General

* Add Wiregard VPN client
* Bump LoRa Server package versions

### Raspberry Pi

* Change SPI speed to 2MHz (required by RAK2245)
* Add IMST980A configuration
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
