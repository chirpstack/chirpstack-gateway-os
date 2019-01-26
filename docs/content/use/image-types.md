---
title: Image types
menu:
    main:
        parent: use
weight: 1
description: Available LoRa Gateway OS image types.
---

# LoRa Gateway OS image types

## `lora-gateway-os-base`

The **lora-gateway-os-base** image provides all the features and components
to operate a LoRa gateway.

### Semtech packet-forwarder

The [Semtech packet-forwarder](https://github.com/lora-net/packet_forwarder)
handles the interaction with the LoRa concentrator chipset.

### LoRa Gateway Bridge

The [LoRa Gateway Bridge](/lora-gateway-bridge/) abstracts the Semtech
packet-forwarder UDP data into MQTT messages.

## `lora-gateway-os-full`

The **lora-gateway-os-full** provides all the features of the
**lora-gateway-os-base** image, but also includes with [LoRa Server](/loraserver/)
and [LoRa App Server](/lora-app-server/) installed, including all requirements.
This makes it possible to run the complete LoRaWAN infrastructure **on** the
gateway. This is intended for small deployments or getting started with LoRaWAN.

### LoRa Server

[LoRa Server](/loraserver/) provides a LoRaWAN network-server.

### LoRa (App) Server

[LoRa App Server](/lora-app-server/) provides a LoRaWAN application-server
and web-interface for managing the gateway, applications and devices.

