// SPDX-License-Identifier: GPL-2.0+
/*
 * Copyright (C) 2017 Microchip
 *		      Wenyou Yang <wenyou.yang@microchip.com>
 */

#include <common.h>
#include <dm.h>
#include <environment.h>
#include <i2c_eeprom.h>
#include <netdev.h>

int at91_set_ethaddr(int offset)
{
	const int ETH_ADDR_LEN = 6;
	unsigned char ethaddr[ETH_ADDR_LEN];
	const char *ETHADDR_NAME = "ethaddr";
	char envbuf[ARP_HLEN_ASCII + 1];
	struct udevice *dev;
	int ret;

	// retrieve mac address from env (true if exists and valid)
	ret = eth_env_get_enetaddr(ETHADDR_NAME, (uint8_t *)envbuf);

#ifndef CONFIG_ENV_IS_IN_MMC
	// if valid and env not in mmc, we keep the mac as it is
	if (ret)
		return 0;
#endif

	// if env is in mmc, we read the mac from eeprom in all cases
	ret = uclass_first_device_err(UCLASS_I2C_EEPROM, &dev);
	if (ret)
		return ret;

	ret = i2c_eeprom_read(dev, offset, ethaddr, ETH_ADDR_LEN);
	if (ret)
		return ret;

	if (is_valid_ethaddr(ethaddr)){
		char envbufnew[ARP_HLEN_ASCII + 1];
		sprintf(envbufnew, "%pM", ethaddr);

		// we compare env mac and eeprom mac
		if(memcmp(envbuf, ethaddr, ETH_ADDR_LEN) == 0){
			// addresses are the same, don't update it
			return 0;
		}

#ifdef CONFIG_ENV_IS_IN_MMC
		// update the mac address and save the environment only if env is in MMC
		return env_set_force(ETHADDR_NAME, envbufnew) && env_save();
#else
		// if env not in mmc, we update the volatile env but don't save it
		// if env not in mmc, we can be here only is mac address not found in env,
		// so env_set_force is not needed (or should not)
		return env_set(ETHADDR_NAME, envbufnew);
#endif
	}

	return 0;
}
