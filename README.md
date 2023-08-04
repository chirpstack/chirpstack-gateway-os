# ChirpStack Gateway OS

ChirpStack Gateway OS is an open-source [OpenWrt](https://openwrt.org/) based
embedded OS for LoRa<sup>&reg;</sup> gateways. It provides a web-interface for
configuration and contains pre-defined configuration options for common
LoRa hardware to make it easy to setup a LoRa gateway and optionally a
ChirpStack-based LoRaWAN<sup>&reg;</sup> Network Server.

**Note:** If you are looking for the [Yocto](https://www.yoctoproject.org/)
recipes of the previously Yocto based ChirpStack Gateway OS, please switch to
the [v4_yocto](https://github.com/chirpstack/chirpstack-gateway-os/tree/v4_yocto)
branch.

## Documentation and binaries

Please refer to the [ChirpStack Gateway OS documentation](https://www.chirpstack.io/docs/chirpstack-gateway-os/)
for documentation and pre-compiled images.

## Building from source

### Requirements

Building ChirpStack Gateway OS requires:

* [Docker](https://www.docker.com/)

### Initialize

To initialize the [OpenWrt](https://openwrt.org/) build environment, run the
following command:

```bash
make init
```

This will:

* Clone the OpenWrt code
* Fetch all the OpenWrt feeds, including the [ChirpStack OpenWrt Feed](https://github.com/chirpstack/chirpstack-openwrt-feed)
* Symlink configuration and files

### Update

This step is not required after running `make init`, but allows you to update
the OpenWrt source and feeds at a later point:

```bash
make update
```

### Build

For building the ChirpStack Gateway OS, you must enter the Docker-based
development environment first:

```
make devshell
```

#### Switch configuration

Each target and image has its own OpenWrt configuration file, files and
patches. These can be found under the `conf` directory of this repository.

To switch to one of these configuration environments, you must execute:

```
make switch-env ENV=name-of-env
```

Fo example if you would like to switch to `base_raspberrypi_bcm27xx_bcm2709`,
you execute:

```
make switch-env ENV=base_raspberrypi_bcm27xx_bcm2709
```

This will:

* Undo all previously applied patches.
* Update the symlinks for OpenWrt configuration and files.
* Apply all patches. 

#### Building image

Once the configuration has been set, run the following command to build the
ChirpStack Gateway OS image:

```bash
make
```

Note that this can take a couple of hours depending on the selected
configuration and will require a significant amount of disk-space.

#### Making configuration changes

**Note:** The commands listed below must be executed within the `openwrt`
directory.

To make configuration changes (e.g. add additional packages), you can execute:

```bash
make menuconfig
```

As updates to OpenWrt packages can introduce new configuration options over
time, you can run the following command to update the configuration:

```bash
make defconfig
```

Please refer also to the [OpenWrt build system usage documentation](https://openwrt.org/docs/guide-developer/toolchain/use-buildsystem).

## Links

* [ChirpStack documentation](https://www.chirpstack.io/)
* [chirpstack-openwrt-feed](https://github.com/chirpstack/chirpstack-openwrt-feed) repository
