---
title: Getting started
menu:
    main:
        parent: use
weight: 2
description: Getting started with the LoRa Gateway OS.
---

# Getting started with LoRa Gateway OS

These steps describe how to get started with LoRa Gateway OS **after** you
have [installed](/lora-gateway-os/install/) LoRa Gateway OS on your gateway.

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

When using the **lora-gateway-os-full** image, proceed with [the following](/guides/first-gateway-device/)
guide to get started with LoRa App Server after you have configured the channel-plan.

## Important to know

### SD Card wearout

Although LoRa Server tries to minimize the number of database writes, there
will be regular writes to the SD Card (PostgreSQL and Redis snapshots).
According to [Is it true that a SD/MMC Card does wear levelling with its own controller?](https://electronics.stackexchange.com/questions/27619/is-it-true-that-a-sd-mmc-card-does-wear-levelling-with-its-own-controller)
it might make a difference which SD Card brand you use.
