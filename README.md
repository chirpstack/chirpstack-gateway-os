# ChirpStack Gateway OS

The ChirpStack Gateway OS is an embedded OS for LoRa gateways. It is part of the
[ChirpStack](https://www.chirpstack.io/) open-source LoRaWAN Network Server stack.

The goal of the ChirpStack Gateway OS is to provide firmware images that are easy
to setup, maintain and customize.

## Images

### chirpstack-gateway-os-base

An image providing the Semtech Packet Forwarder and ChirpStack Gateway Bridge.

Provides the following features:

* [Monit](https://mmonit.com/monit/) based service monitoring
* [ChirpStack Concentratord](https://github.com/brocaar/chirpstack-concentratord/)
* [ChirpStack Gateway Bridge](https://www.chirpstack.io/gateway-bridge/)

### chirpstack-gateway-os-full

An image providing a complete LoRaWAN network-server running on the
gateway.

Provides the following features:

* [Monit](https://mmonit.com/monit/) based service monitoring
* [ChirpStack Concentratord](https://github.com/brocaar/chirpstack-concentratord/)
* [ChirpStack Gateway Bridge](https://www.chirpstack.io/gateway-bridge/)
* [ChirpStack Network Server](https://www.chirpstack.io/network-server/)
* [ChirpStack Application Server](https://www.chirpstack.io/application-server/)
* [Mosquitto MQTT broker](http://mosquitto.org/)
* [Redis](https://redis.io/)
* [PostgreSQL](https://www.postgresql.org/)

## Targets

### Raspberry Pi

* Raspberry Pi Zero W
* Raspberry Pi 1
* Raspberry Pi 3
* Raspberry Pi 4

#### Shields / kits

* [IMST - iC880A](https://wireless-solutions.de/products/long-range-radio/ic880a.html)
* [IMST - iC980A](http://www.imst.com/)
* [IMST - Lite Gateway](https://wireless-solutions.de/products/long-range-radio/lora-lite-gateway.html)
* [Pi Supply - LoRa Gateway Hat](https://uk.pi-supply.com/products/iot-lora-gateway-hat-for-raspberry-pi)
* [RAK - RAK2245](https://store.rakwireless.com/products/rak2245-pi-hat)
* [RAK - RAK2246 / RAK2246G](https://store.rakwireless.com/products/rak7246-lpwan-developer-gateway)
* [RAK - RAK2287](https://store.rakwireless.com/products/rak2287-lpwan-gateway-concentrator-module)
* [RAK - RAK831 Gateway Developer Kit](https://store.rakwireless.com/products/rak831-gateway-module?variant=22375114801252)
* [RisingHF - RHF0M301 LoRaWAN IoT Discovery Kit](http://risinghf.com/#/product-details?product_id=9&lang=en)
* [Sandbox Electronics - LoRaGo PORT](https://sandboxelectronics.com/?product=lorago-port-multi-channel-lorawan-gateway)
* [Semtech - SX1302 CoreCell](https://www.semtech.com/products/wireless-rf/lora-gateways/sx1302cxxxgw1)
* [Semtech - SX1280 2.4GHz gateway](https://www.semtech.com/products/wireless-rf/lora-gateways/sx1280zxxxxgw1)

## Using

### Login

The default username is `admin` with password `admin`.

### Gateway configuration

Execute the following command as `admin` user:

```bash
sudo gateway-config
```

## Building images

A [Docker Compose](https://docs.docker.com/compose/) based build environment is provided for compiling the images.

**Note:** Compiling these images require a fair amount of CPU power, RAM and disk space.
As a reference, the pre-compiled images are built using a 8 x Core i7 machine with 16GB RAM
running Manjaro Linux with 200GB reserved for the build environment.

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
docker compose run --rm busybox

# within the container
chown 999:999 /build
```

### Building

Run the following command to setup the build environment:

```bash
# on the host
docker compose run --rm yocto bash

# within the container

# initialize the yocto / openembedded build environment
source oe-init-build-env /build/ /chirpstack-gateway-os/bitbake/


# build the chirpstack-gateway-os-base image
bitbake chirpstack-gateway-os-base
```

In case of error:

```bash
docker.credentials.errors.InitializationError: docker-credential-secretservice not installed or not available in PATH
```

Make sure that the `golang-docker-credential-helpers` is installed. On `Ubuntu`
you can install it with:

```bash
sudo apt install golang-docker-credential-helpers
```

#### Configuration

By default, Raspberry Pi3 is configured as the target platform. You need to
update the following configuration files to configure a different target:

* `/build/config/local.conf`
* `/build/config/bblayers.conf`

## Good to know

### SD Card wearout

Although ChirpStack Network Server and ChirpStack Application Server try to minimize
the number of database writes, there will be regular writes to the SD Card
(PostgreSQL and Redis snapshots).
According to [Is it true that a SD/MMC Card does wear levelling with its own controller?](https://electronics.stackexchange.com/questions/27619/is-it-true-that-a-sd-mmc-card-does-wear-levelling-with-its-own-controller)
it might make a difference which SD Card brand you use.

### Versioning

The major version (major.minor.patch) of this project represents the major
version of the provided ChirpStack Network Server stack.
