---
title: lora-gateway-os-full
menu:
    main:
        parent: use
description: Image providing a full LoRa Server based LoRaWAN network-server on the gateway.
---

# lora-gateway-os-full

## Features

The **lora-gateway-os-full** image provides all the components needed for a
full [LoRa Server](/loraserver/) + [LoRa App Server](/lora-app-server/)
environment running **on** the gateway. It is intended for getting started
with LoRaWAN, the LoRa Server project or for small deployments.

It comes with the following services pre-installed:

### Monit

[Monit](https://mmonit.com/monit/) is a daemon for monitoring services.
It automatically restarts a service when it has crashed. Especially for
Raspberry Pi 3 based gateways, this is useful as it sometimes takes a couple
of attempts to start the Semtech packet-forwarder.

### Semtech packet-forwarder

The [Semtech packet-forwarder](https://github.com/lora-net/packet_forwarder)
handles the interaction with the LoRa concentrator chipset.

### LoRa Gateway Bridge

The [LoRa Gateway Bridge](/lora-gateway-bridge/) abstracts the Semtech
packet-forwarder UDP data into MQTT messages.

### LoRa Server

[LoRa Server](/loraserver/) provides a LoRaWAN network-server.

### LoRa (App) Server

[LoRa App Server](/lora-app-server/) provides a LoRaWAN application-server
and web-interface for managing the gateway, applications and devices.

## First use

**Important:** The **lora-gateway-os-full** image will setup the PostgreSQL
on its first boot. This could take a couple of minutes and during this time,
the gateway will be less responsive!

After booting the gateway, you need to login using SSH. When the IP of your
gateway is `192.168.1.5`:

{{<highlight bash>}}
ssh admin@192.168.1.5
{{< /highlight >}}

The default username is `admin`, the default password is `admin`.

This will prompt the following message:

{{<highlight text>}}
    __          ____        _____                             _
   / /   ____  / __ \____ _/ ___/___  ______   _____  _____  (_)___
  / /   / __ \/ /_/ / __ `/\__ \/ _ \/ ___/ | / / _ \/ ___/ / / __ \
 / /___/ /_/ / _, _/ /_/ /___/ /  __/ /   | |/ /  __/ /  _ / / /_/ /
/_____/\____/_/ |_|\__,_//____/\___/_/    |___/\___/_/  (_)_/\____/

        documentation and copyright information: www.loraserver.io

Commands:

> sudo gateway-config  - configure the gateway
> sudo monit status    - display service monitor

{{< /highlight >}}

Then execute the `sudo gateway-config` to configure the channel-configuration
that the gateway must use.

Unlike the **lora-gateway-os-base** image, you **should not** update the
LoRa Gateway Bridge configuration. It is configured to point to the MQTT broker
which comes with the **lora-gateway-os-base** image.

## Getting started with LoRa (App) Server

Please continue with the [Getting started with your first gateway and device](/guides/first-gateway-device/)
guide.

## Managing services

All services can be monitored, (re)started and stopped using Monit. Examples:

{{<highlight text>}}
# show monit status
sudo monit status

# start all services
sudo monit start all

# stop all services
sudo monit stop all

# start lora-gateway-bridge
sudo monit start lora-gateway-bridge

# stop lora-gateway-bridge
sudo monit stop lora-gateway-bridge
{{< /highlight >}}

## Important to know

### SD Card wearout

Although LoRa Server tries to minimize the number of database writes, there
will be regular writes to the SD Card (PostgreSQL and Redis snapshots).
According to [Is it true that a SD/MMC Card does wear levelling with its own controller?](https://electronics.stackexchange.com/questions/27619/is-it-true-that-a-sd-mmc-card-does-wear-levelling-with-its-own-controller)
it might make a difference which SD Card brand you use.
