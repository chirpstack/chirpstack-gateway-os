---
title: Image types
menu:
    main:
        parent: use
weight: 1
description: Available ChirpStack Gateway OS image types.
---

# ChirpStack Gateway OS image types

## `chirpstack-gateway-os-base`

The **chirpstack-gateway-os-base** image provides all the features and components
to operate a LoRa gateway.

### Semtech packet-forwarder

The [Semtech Packet Forwarder](https://github.com/lora-net/packet_forwarder)
handles the interaction with the LoRa<sup>&reg;</sup> concentrator chipset.

### ChirpStack Gateway Bridge

The [ChirpStack Gateway Bridge](/gateway-bridge/) abstracts the Semtech
Packet Forwarder UDP data into MQTT messages.

## `chirpstack-gateway-os-full`

The **chirpstack-gateway-os-full** provides all the features of the
**chirpstack-gateway-os-base** image, but also comes with [ChirpStack Network Server](/network-server/)
and [ChirpStack Application Server](/application-server/) installed, including all requirements.
This makes it possible to run the complete LoRaWAN<sup>&reg;</sup> infrastructure **on** the
gateway. This is intended for small deployments or getting started with LoRaWAN.

### ChirpStack Network Server

[ChirpStack Network Server](/network-server/) is an open-source LoRaWAN Network Server implementation.

### ChirpStack Application Server

[ChirpStack Application Server](/application-server/) is an open-source LoRaWAN Application Server
and web-interface for managing the gateway, applications and devices.

