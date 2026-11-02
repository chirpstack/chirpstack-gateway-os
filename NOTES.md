# Notes

## Packages

### RAK

#### RAK7289V2 + RAK7267

* `kmod-usb-serial-ch341` = Required for Modbus (watchdog + solar battery status)

#### RAK7266 + RAK7267

* `kmod-usb-net-cdc-ether` = Required for cellular data on the Quectel EG915U (LTE Cat 1) modem, which runs in CDC-ECM mode rather than QMI

#### RAK7248

* `uqmi`, `qmi-utils`, `luci-proto-qmi`, `kmod-usb-net-qmi-wwan`, `kmod-usb-serial-option`, `kmod-usb-wdm` = Required for cellular data on the RAK7248C, whose RAK2013 HAT carries a Quectel BG96 or EG95 modem connected to the Pi over USB (QMI)
* `gpiod-tools` = Required to switch the RAK2013 modem on at boot (reads its STATUS line, pulses PWRKEY)

### All targets

* `kmod-tun` = Required for OpenVPN
