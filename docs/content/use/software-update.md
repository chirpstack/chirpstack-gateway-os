---
title: Software updates
menu:
    main:
        parent: use
weight: 2
description: Updating ChirpStack Gateway OS to the latest version.
---

# Updating the ChirpStack Gateway OS

ChirpStack Gateway OS uses [Mender](https://mender.io/) for handling updates.
Mender is open-source and can be used either as a CLI utility on the gateway
or as a [hosted](https://mender.io/product/hosted-mender) or 
[self hosted](https://docs.mender.io/1.7/getting-started) platform from which
updates can be deployed to one or a group of gateways.

## Partition layout

ChirpStack Gateway OS uses 4 partitions:

* Boot partition
* RootFS partition A
* RootFS partition B
* Data partition (used for OverlayFS)

One RootFS partition is used for booting, the other for the next update.
The bootloader will automatically revert to the last functioning RootFS
partition on a failed update.

## Hosted Mender

These steps assume that you already have a [Hosted Mender](https://hosted.mender.io)
account.

To authenticate the gateway with your Mender account, you need to provision your
Mender organization token. In your Mender account, you will find this under
**My organization** and then **Token**.

On the gateway, you need to enter this token in `/etc/mender/mender.conf`, e.g.
by executing `nano /etc/mender/mender.conf`. Example:

{{<highlight js>}}
{
    "InventoryPollIntervalSeconds": 1800,
    "RetryPollIntervalSeconds": 300,
    "RootfsPartA": "/dev/mmcblk0p2",
    "RootfsPartB": "/dev/mmcblk0p3",
    "ServerURL": "https://hosted.mender.io",
    "TenantToken": "TOKEN",
    "UpdatePollIntervalSeconds": 1800
}
{{</highlight>}}

Make sure:

* That `ServerURL` contains `https://hosted.mender.io`
* That `TenantToken` contains your organization token

**Note:** by default the Mender agent will poll every 30 minutes for updates,
(for testing) you might want to lower these intervals.

Then you need to modify `/etc/default/mender`, e.g. by executing
`sudo nano /etc/default/mender` and make sure that it contains:

{{<highlight bash>}}
# Settings this variable to "yes" disables the Mender Agent.
# Any other values enables it.
DISABLED="no"
{{</highlight>}}

Finally you need to start the Mender agent:

{{<highlight bash>}}
sudo /etc/init.d/mender start
{{</highlight>}}

After this your gateway will show up under **Pending** **Devices**. Please refer to
the [Mender](https://mender.io/) documentation for more help.

## Mender CLI

Alternatively, you can also use the `mender` CLI utility to update the gateway.
For this you can execute the following command:

{{<highlight bash>}}
sudo mender -rootfs https://artifacts.chirpstack.io/path/to/mender-artifact.mender
{{</highlight>}}

Please refer to the [Install](/gateway-os/install/) section to find the
correct `.mender` artifact for your gateway.

**Important:** after a succesful update, you must execute the following command
to commit the upgrade:

{{<highlight bash>}}
mender -commit
{{</highlight>}}

If you do not do this, then Mender will rollback to the previous installed
version on the next reboot.
