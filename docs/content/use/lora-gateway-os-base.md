---
title: lora-gateway-os-base
menu:
    main:
        parent: use
description: Image providing LoRa gateway components.
---

# lora-gateway-os-base

## Features

The **lora-gateway-os-base** image provides all the components needed for a LoRa
gateway. It comes with the following services pre-installed:

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

## First use

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

You also need to update the LoRa Gateway Bridge [Configuration](/lora-gateway-bridge/install/config/)
so that it connects to your own MQTT broker. You will find this configuration
under the `[backend.mqtt.auth]` section.

Finally, restart the LoRa Gateway Bridge.

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
