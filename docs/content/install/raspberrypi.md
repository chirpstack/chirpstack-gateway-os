---
title: Raspberry Pi
menu:
    main:
        parent: install
description: Installing ChirpStack Gateway OS on a Raspberry Pi.
---

# Raspberry Pi

## Installation

There are two file types:

* `.wic.gz` - Image to use for an initial installation
* `.swu` - Software update file, see [Software update]({{<ref "use/software-update.md">}})

For an initial installation:

* Download the SD Card image for your Raspberry Pi version using one of the
  links below.
* Flash the SD Card image using for example [Etcher](https://www.balena.io/etcher/) on a SD Card.
* Continue with [Using the ChirpStack Gateway OS images](/gateway-os/use/).

### SD Card images

* [Raspberry Pi 1](http://artifacts.chirpstack.io/downloads/chirpstack-gateway-os/raspberrypi/raspberrypi/{{< raspberrypi_raspberrypi_version >}}/)
* [Raspberry Pi 3](http://artifacts.chirpstack.io/downloads/chirpstack-gateway-os/raspberrypi/raspberrypi3/{{< raspberrypi_raspberrypi3_version >}}/)
* [Raspberry Pi 4](http://artifacts.chirpstack.io/downloads/chirpstack-gateway-os/raspberrypi/raspberrypi4/{{< raspberrypi_raspberrypi4_version >}}/)

## Supported shields

The Raspberry Pi images provide out-of-the-box support for the following
concentrator shields / gateway kits:

* [IMST - iC880A](https://wireless-solutions.de/products/long-range-radio/ic880a.html)
* [IMST - iC980A](http://www.imst.com/)
* [IMST - Lite Gateway](https://wireless-solutions.de/products/long-range-radio/lora-lite-gateway.html)
* [Pi Supply - LoRa Gateway Hat](https://uk.pi-supply.com/products/iot-lora-gateway-hat-for-raspberry-pi)
* [RAK - RAK2245](https://store.rakwireless.com/products/rak2245-pi-hat)
* [RAK - RAK831 Gateway Developer Kit](https://store.rakwireless.com/products/rak831-gateway-module?variant=22375114801252)
* [RisingHF - RHF0M301 LoRaWAN IoT Discovery Kit](http://risinghf.com/#/product-details?product_id=9&lang=en)
* [Sandbox Electronics - LoRaGo PORT](https://sandboxelectronics.com/?product=lorago-port-multi-channel-lorawan-gateway)
* [Semtech - SX1302 CoreCell](https://www.semtech.com/products/wireless-rf/lora-gateways/sx1302cxxxgw1)
