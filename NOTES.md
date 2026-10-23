# Notes

## Packages

### RAK

#### RAK7289V2 + RAK7267

* `kmod-usb-serial-ch341` = Required for Modbus (watchdog + solar battery status)

#### RAK7266 + RAK7267

* `kmod-usb-net-cdc-ether` = Required for cellular data on the Quectel EG915U (LTE Cat 1) modem, which runs in CDC-ECM mode rather than QMI

### All targets

* `kmod-tun` = Required for OpenVPN
