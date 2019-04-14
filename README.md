# LoRa Gateway OS

The LoRa Gateway OS is an embedded OS for LoRa gateways. It is part of the
open-source [LoRa Server project](https://www.loraserver.io/).

The goal of the LoRa Gateway OS is to provide firmware images that are easy
to setup, maintain and customize.

## Images

### lora-gateway-os-base

An image providing the Semtech packet-forwarder and LoRa Gateway Bridge.

Provides the following features:

* [Monit](https://mmonit.com/monit/) based service monitoring
* Semtech [packet-forwarder](https://github.com/lora-net/packet_forwarder)
* [LoRa Gateway Bridge](https://github.com/brocaar/lora-gateway-bridge/)

### lora-gateway-os-full

An image providing a complete LoRaWAN network-server running on the
gateway.

Provides the following features:

* [Monit](https://mmonit.com/monit/) based service monitoring
* Semtech [packet-forwarder](https://github.com/lora-net/packet_forwarder)
* [LoRa Gateway Bridge](https://github.com/brocaar/lora-gateway-bridge/)
* [LoRa Server](https://github.com/brocaar/loraserver)
* [LoRa App Server](https://github.com/brocaar/lora-app-server)
* [Mosquitto MQTT broker](http://mosquitto.org/)
* [Redis](https://redis.io/)
* [PostgreSQL](https://www.postgresql.org/)

## Targets

* [LORIX One](https://www.lorixone.io/)

* Raspberry Pi 3
    * [IMST - iC880A](https://wireless-solutions.de/products/long-range-radio/ic880a.html)
    * [RAK - RAK2245](https://www.rakwireless.com/en/)
    * [RAK - RAK831 Gateway Developer Kit](https://www.rakwireless.com/en/WisKeyOSH/RAK831)
	* [RisingHF - RHF0M301 LoRaWAN IoT Discovery Kit](http://risinghf.com/#/product-details?product_id=9&lang=en)
    * [Sandbox Electronics - LoRaGo PORT](https://sandboxelectronics.com/?product=lorago-port-multi-channel-lorawan-gateway)

## Using

### Login

The default username is `admin` with password `admin`.

### Gateway configuration

Execute the following command as `admin` user:

```bash
sudo gateway-config
```

## Building images

A Docker based build environment is provided for compiling the images.

### Initial setup

Run the following command to fetch the git submodules and setup directory
permissions (to write back from the Docker container):

```bash
# update the submodules
make submodules

# setup permissions
make permissions
```

Run the following command to set the `/build` folder permissions:

```bash
# on the host
docker-compose run --rm busybox

# within the container
chown 999:999 /build
```

### Building

Run the following command to setup the build environment:

```bash
# on the host
docker-compose run --rm yocto bash

# within the container

# initialize the yocto / openembedded build environment
source oe-init-build-env /build/ /lora-gateway-os/bitbake/


# build the lora-gateway-os-base image
bitbake lora-gateway-os-base
```

#### Configuration

By default, Raspberry Pi3 is configured as the target platform. You need to
update the following configuration files to configure a different target:

* `/build/config/local.conf`
* `/build/config/bblayers.conf`

## Good to know

### SD Card wearout

Although LoRa Server tries to minimize the number of database writes, there
will be regular writes to the SD Card (PostgreSQL and Redis snapshots).
According to [Is it true that a SD/MMC Card does wear levelling with its own controller?](https://electronics.stackexchange.com/questions/27619/is-it-true-that-a-sd-mmc-card-does-wear-levelling-with-its-own-controller)
it might make a difference which SD Card brand you use.

### Updates

(Currently) the LoRa Server project does not provide package updates.
However, each image includes the `opkg` package manager,

### Versioning

The major version (major.minor.patch) of this project represents the major
version of the provided LoRa Server components.
