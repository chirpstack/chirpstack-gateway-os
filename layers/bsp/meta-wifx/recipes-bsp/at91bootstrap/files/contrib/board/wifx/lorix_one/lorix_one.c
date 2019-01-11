/* ----------------------------------------------------------------------------
 *         ATMEL Microcontroller Software Support
 * ----------------------------------------------------------------------------
 * Copyright (c) 2014, Atmel Corporation
 * Copyright (c) 2016, Wifx Sàrl
 *
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * - Redistributions of source code must retain the above copyright notice,
 * this list of conditions and the disclaimer below.
 *
 * Atmel's name may not be used to endorse or promote products derived from
 * this software without specific prior written permission.
 *
 * DISCLAIMER: THIS SOFTWARE IS PROVIDED BY ATMEL "AS IS" AND ANY EXPRESS OR
 * IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT ARE
 * DISCLAIMED. IN NO EVENT SHALL ATMEL BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA,
 * OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 * LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
 * EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */
#include "common.h"
#include "hardware.h"
#include "pmc.h"
#include "usart.h"
#include "debug.h"
#include "ddramc.h"
#include "gpio.h"
#include "timer.h"
#include "watchdog.h"
#include "string.h"
#include "arch/at91_pmc.h"
#include "arch/at91_rstc.h"
#include "arch/sama5_smc.h"
#include "arch/at91_pio.h"
#include "arch/at91_ddrsdrc.h"
#include "arch/at91_sfr.h"
#include "arch/tz_matrix.h"
#include "lorix_one.h"
#include "tz_utils.h"
#include "l2cc.h"
#include "matrix.h"
#include "act8865.h"
#include "twi.h"
 static void at91_dbgu_hw_init(void)
{
	const struct pio_desc dbgu_pins[] = {
		{"RXD", AT91C_PIN_PE(16), 0, PIO_DEFAULT, PIO_PERIPH_B},
		{"TXD", AT91C_PIN_PE(17), 0, PIO_DEFAULT, PIO_PERIPH_B},
		{(char *)0, 0, 0, PIO_DEFAULT, PIO_PERIPH_A},
	};
 	pio_configure(dbgu_pins);
	pmc_enable_periph_clock(AT91C_ID_PIOE);
	pmc_enable_periph_clock(AT91C_ID_USART3);
}
 static void initialize_dbgu(void)
{
	unsigned int baudrate = 115200;
 	at91_dbgu_hw_init();
 	if (pmc_check_mck_h32mxdiv())
		usart_init(BAUDRATE(MASTER_CLOCK / 2, baudrate));
	else
		usart_init(BAUDRATE(MASTER_CLOCK, baudrate));
}
 #ifdef CONFIG_DDR2
static void ddramc_reg_config(struct ddramc_register *ddramc_config)
{
	ddramc_config->mdr = (AT91C_DDRC2_DBW_16_BITS
				| AT91C_DDRC2_MD_DDR2_SDRAM);
 	ddramc_config->cr = (AT91C_DDRC2_NC_DDR10_SDR9
				| AT91C_DDRC2_NR_13
				| AT91C_DDRC2_CAS_5
				| AT91C_DDRC2_DISABLE_RESET_DLL
				| AT91C_DDRC2_DISABLE_DLL
				| AT91C_DDRC2_NB_BANKS_8
				| AT91C_DDRC2_DECOD_INTERLEAVED
				| AT91C_DDRC2_UNAL_SUPPORTED);
 #if defined(CONFIG_BUS_SPEED_148MHZ)
 	ddramc_config->rtr = 0x243;
 	/* One clock cycle @ 148 MHz = 6.7 ns */
	ddramc_config->t0pr = (AT91C_DDRC2_TRAS_(7)
			| AT91C_DDRC2_TRCD_(3)
			| AT91C_DDRC2_TWR_(3)
			| AT91C_DDRC2_TRC_(9)
			| AT91C_DDRC2_TRP_(3)
			| AT91C_DDRC2_TRRD_(2)
			| AT91C_DDRC2_TWTR_(2)
			| AT91C_DDRC2_TMRD_(2));
 	ddramc_config->t1pr = (AT91C_DDRC2_TXP_(2)
			| AT91C_DDRC2_TXSRD_(200)
			| AT91C_DDRC2_TXSNR_(31)
			| AT91C_DDRC2_TRFC_(30));
 	ddramc_config->t2pr = (AT91C_DDRC2_TFAW_(7)
			| AT91C_DDRC2_TRTP_(2)
			| AT91C_DDRC2_TRPA_(3)
			| AT91C_DDRC2_TXARDS_(8)
			| AT91C_DDRC2_TXARD_(8));
 #elif defined(CONFIG_BUS_SPEED_170MHZ)
 	ddramc_config->rtr = 0x229;
 	/* One clock cycle @ 170 MHz = 5.9 ns */
	ddramc_config->t0pr = (AT91C_DDRC2_TRAS_(7)
			| AT91C_DDRC2_TRCD_(3)
			| AT91C_DDRC2_TWR_(3)
			| AT91C_DDRC2_TRC_(10)
			| AT91C_DDRC2_TRP_(3)
			| AT91C_DDRC2_TRRD_(3)
			| AT91C_DDRC2_TWTR_(2)
			| AT91C_DDRC2_TMRD_(2));
 	ddramc_config->t1pr = (AT91C_DDRC2_TXP_(2)
			| AT91C_DDRC2_TXSRD_(200)
			| AT91C_DDRC2_TXSNR_(35)
			| AT91C_DDRC2_TRFC_(34));
 	ddramc_config->t2pr = (AT91C_DDRC2_TFAW_(6)
			| AT91C_DDRC2_TRTP_(2)
			| AT91C_DDRC2_TRPA_(3)
			| AT91C_DDRC2_TXARDS_(2)
			| AT91C_DDRC2_TXARD_(8));
 #elif defined(CONFIG_BUS_SPEED_176MHZ)
 	ddramc_config->rtr = 0x2b0;
 	ddramc_config->t0pr = (AT91C_DDRC2_TRAS_(8)
			| AT91C_DDRC2_TRCD_(3)
			| AT91C_DDRC2_TWR_(3)
			| AT91C_DDRC2_TRC_(10)
			| AT91C_DDRC2_TRP_(3)
			| AT91C_DDRC2_TRRD_(3)
			| AT91C_DDRC2_TWTR_(2)
			| AT91C_DDRC2_TMRD_(2));
 	ddramc_config->t1pr = (AT91C_DDRC2_TXP_(2)
			| AT91C_DDRC2_TXSRD_(200)
			| AT91C_DDRC2_TXSNR_(36)
			| AT91C_DDRC2_TRFC_(35));
 	ddramc_config->t2pr = (AT91C_DDRC2_TFAW_(8)
			| AT91C_DDRC2_TRTP_(2)
			| AT91C_DDRC2_TRPA_(3)
			| AT91C_DDRC2_TXARDS_(2)
			| AT91C_DDRC2_TXARD_(8));
 #elif defined(CONFIG_BUS_SPEED_200MHZ)
 	ddramc_config->rtr = 0x30e;
 	ddramc_config->t0pr = (AT91C_DDRC2_TRAS_(8)
			| AT91C_DDRC2_TRCD_(3)
			| AT91C_DDRC2_TWR_(3)
			| AT91C_DDRC2_TRC_(11)
			| AT91C_DDRC2_TRP_(3)
			| AT91C_DDRC2_TRRD_(3)
			| AT91C_DDRC2_TWTR_(2)
			| AT91C_DDRC2_TMRD_(2));
 	ddramc_config->t1pr = (AT91C_DDRC2_TXP_(2)
			| AT91C_DDRC2_TXSRD_(200)
			| AT91C_DDRC2_TXSNR_(42)
			| AT91C_DDRC2_TRFC_(40));
 	ddramc_config->t2pr = (AT91C_DDRC2_TFAW_(9)
			| AT91C_DDRC2_TRTP_(2)
			| AT91C_DDRC2_TRPA_(3)
			| AT91C_DDRC2_TXARDS_(2)
			| AT91C_DDRC2_TXARD_(8));
 #else
#error "No CLK setting defined"
#endif
}
 static void ddramc_init(void)
{
	struct ddramc_register ddramc_reg;
	unsigned int reg;
 	ddramc_reg_config(&ddramc_reg);
 	/* enable ddr2 clock */
	pmc_enable_periph_clock(AT91C_ID_MPDDRC);
	pmc_enable_system_clock(AT91C_PMC_DDR);
 	/* configure Shift Sampling Point of Data */
#if defined(CONFIG_BUS_SPEED_148MHZ)
	reg = AT91C_MPDDRC_RD_DATA_PATH_NO_SHIFT;
#elif defined(CONFIG_BUS_SPEED_200MHZ)
	reg = AT91C_MPDDRC_RD_DATA_PATH_TWO_CYCLES;
#else
	reg = AT91C_MPDDRC_RD_DATA_PATH_ONE_CYCLES;
#endif
	writel(reg, (AT91C_BASE_MPDDRC + MPDDRC_RD_DATA_PATH));
 	/* MPDDRC I/O Calibration Register */
	reg = readl(AT91C_BASE_MPDDRC + MPDDRC_IO_CALIBR);
	reg &= ~AT91C_MPDDRC_RDIV;
	reg &= ~AT91C_MPDDRC_TZQIO;
	reg &= ~AT91C_MPDDRC_CALCODEP;
	reg &= ~AT91C_MPDDRC_CALCODEN;
	reg |= AT91C_MPDDRC_RDIV_DDR2_RZQ_50;
#if defined(CONFIG_BUS_SPEED_148MHZ)
	reg |= AT91C_MPDDRC_TZQIO_4;	/* @ 133 & 148 MHz */
#else
	reg |= AT91C_MPDDRC_TZQIO_5;	/* @ 170 & 176 MHz */
#endif
	reg |= AT91C_MPDDRC_EN_CALIB;
 	writel(reg, (AT91C_BASE_MPDDRC + MPDDRC_IO_CALIBR));
 	/* DDRAM2 Controller initialize */
	ddram_initialize(AT91C_BASE_MPDDRC, AT91C_BASE_DDRCS, &ddramc_reg);
 	ddramc_dump_regs(AT91C_BASE_MPDDRC);
}
#endif /* #ifdef CONFIG_DDR2 */
 #if defined(CONFIG_MATRIX)
static int matrix_configure_slave(void)
{
	unsigned int ddr_port;
	unsigned int ssr_setting, sasplit_setting, srtop_setting;
 	/*
	 * Matrix 0 (H64MX)
	 */
 	/*
	 * 0: Bridge from H64MX to AXIMX
	 * (Internal ROM, Crypto Library, PKCC RAM): Always Secured
	 */
 	/* 1: H64MX Peripheral Bridge */
 	/* 2: Video Decoder 1M: Non-Secure */
	srtop_setting = MATRIX_SRTOP(0, MATRIX_SRTOP_VALUE_1M);
	sasplit_setting = MATRIX_SASPLIT(0, MATRIX_SASPLIT_VALUE_1M);
	ssr_setting = (MATRIX_LANSECH_NS(0)
			| MATRIX_RDNSECH_NS(0)
			| MATRIX_WRNSECH_NS(0));
	matrix_configure_slave_security(AT91C_BASE_MATRIX64,
					H64MX_SLAVE_VIDEO_DECODER,
					srtop_setting,
					sasplit_setting,
					ssr_setting);
 	/* 4 ~ 10 DDR2 Port1 ~ 7: Non-Secure */
	srtop_setting = MATRIX_SRTOP(0, MATRIX_SRTOP_VALUE_128M);
	sasplit_setting = (MATRIX_SASPLIT(0, MATRIX_SASPLIT_VALUE_128M)
				| MATRIX_SASPLIT(1, MATRIX_SASPLIT_VALUE_128M)
				| MATRIX_SASPLIT(2, MATRIX_SASPLIT_VALUE_128M)
				| MATRIX_SASPLIT(3, MATRIX_SASPLIT_VALUE_128M));
	ssr_setting = (MATRIX_LANSECH_NS(0)
			| MATRIX_LANSECH_NS(1)
			| MATRIX_LANSECH_NS(2)
			| MATRIX_LANSECH_NS(3)
			| MATRIX_RDNSECH_NS(0)
			| MATRIX_RDNSECH_NS(1)
			| MATRIX_RDNSECH_NS(2)
			| MATRIX_RDNSECH_NS(3)
			| MATRIX_WRNSECH_NS(0)
			| MATRIX_WRNSECH_NS(1)
			| MATRIX_WRNSECH_NS(2)
			| MATRIX_WRNSECH_NS(3));
	/* DDR port 0 not used from NWd */
	for (ddr_port = 1; ddr_port < 8; ddr_port++) {
		matrix_configure_slave_security(AT91C_BASE_MATRIX64,
					(H64MX_SLAVE_DDR2_PORT_0 + ddr_port),
					srtop_setting,
					sasplit_setting,
					ssr_setting);
	}
 	/*
	 * 11: Internal SRAM 128K
	 * TOP0 is set to 128K
	 * SPLIT0 is set to 64K
	 * LANSECH0 is set to 0, the low area of region 0 is the Securable one
	 * RDNSECH0 is set to 0, region 0 Securable area is secured for reads.
	 * WRNSECH0 is set to 0, region 0 Securable area is secured for writes
	 */
	srtop_setting = MATRIX_SRTOP(0, MATRIX_SRTOP_VALUE_128K);
	sasplit_setting = MATRIX_SASPLIT(0, MATRIX_SASPLIT_VALUE_64K);
	ssr_setting = (MATRIX_LANSECH_S(0)
			| MATRIX_RDNSECH_S(0)
			| MATRIX_WRNSECH_S(0));
	matrix_configure_slave_security(AT91C_BASE_MATRIX64,
					H64MX_SLAVE_INTERNAL_SRAM,
					srtop_setting,
					sasplit_setting,
					ssr_setting);
 	/* 12:  Bridge from H64MX to H32MX */
 	/*
	 * Matrix 1 (H32MX)
	 */
 	/* 0: Bridge from H32MX to H64MX: Not Secured */
 	/* 1: H32MX Peripheral Bridge 0: Not Secured */
 	/* 2: H32MX Peripheral Bridge 1: Not Secured */
 	/*
	 * 3: External Bus Interface
	 * EBI CS0 Memory(256M) ----> Slave Region 0, 1
	 * EBI CS1 Memory(256M) ----> Slave Region 2, 3
	 * EBI CS2 Memory(256M) ----> Slave Region 4, 5
	 * EBI CS3 Memory(128M) ----> Slave Region 6
	 * NFC Command Registers(128M) -->Slave Region 7
	 *
	 * NANDFlash(EBI CS3) --> Slave Region 6: Non-Secure
	 */
	srtop_setting =	MATRIX_SRTOP(6, MATRIX_SRTOP_VALUE_128M);
	srtop_setting |= MATRIX_SRTOP(7, MATRIX_SRTOP_VALUE_128M);
	sasplit_setting = MATRIX_SASPLIT(6, MATRIX_SASPLIT_VALUE_128M);
	sasplit_setting |= MATRIX_SASPLIT(7, MATRIX_SASPLIT_VALUE_128M);
	ssr_setting = (MATRIX_LANSECH_NS(6)
			| MATRIX_RDNSECH_NS(6)
			| MATRIX_WRNSECH_NS(6));
	ssr_setting |= (MATRIX_LANSECH_NS(7)
			| MATRIX_RDNSECH_NS(7)
			| MATRIX_WRNSECH_NS(7));
	matrix_configure_slave_security(AT91C_BASE_MATRIX32,
					H32MX_EXTERNAL_EBI,
					srtop_setting,
					sasplit_setting,
					ssr_setting);
 	/* 4: NFC SRAM (4K): Non-Secure */
	srtop_setting = MATRIX_SRTOP(0, MATRIX_SRTOP_VALUE_8K);
	sasplit_setting = MATRIX_SASPLIT(0, MATRIX_SASPLIT_VALUE_8K);
	ssr_setting = (MATRIX_LANSECH_NS(0)
			| MATRIX_RDNSECH_NS(0)
			| MATRIX_WRNSECH_NS(0));
	matrix_configure_slave_security(AT91C_BASE_MATRIX32,
					H32MX_NFC_SRAM,
					srtop_setting,
					sasplit_setting,
					ssr_setting);
 	/* 5:
	 * USB Device High Speed Dual Port RAM (DPR): 1M
	 * USB Host OHCI registers: 1M
	 * USB Host EHCI registers: 1M
	 */
	srtop_setting = (MATRIX_SRTOP(0, MATRIX_SRTOP_VALUE_1M)
			| MATRIX_SRTOP(1, MATRIX_SRTOP_VALUE_1M)
			| MATRIX_SRTOP(2, MATRIX_SRTOP_VALUE_1M));
	sasplit_setting = (MATRIX_SASPLIT(0, MATRIX_SASPLIT_VALUE_1M)
			| MATRIX_SASPLIT(1, MATRIX_SASPLIT_VALUE_1M)
			| MATRIX_SASPLIT(2, MATRIX_SASPLIT_VALUE_1M));
	ssr_setting = (MATRIX_LANSECH_NS(0)
			| MATRIX_LANSECH_NS(1)
			| MATRIX_LANSECH_NS(2)
			| MATRIX_RDNSECH_NS(0)
			| MATRIX_RDNSECH_NS(1)
			| MATRIX_RDNSECH_NS(2)
			| MATRIX_WRNSECH_NS(0)
			| MATRIX_WRNSECH_NS(1)
			| MATRIX_WRNSECH_NS(2));
	matrix_configure_slave_security(AT91C_BASE_MATRIX32,
					H32MX_USB,
					srtop_setting,
					sasplit_setting,
					ssr_setting);
 	/* 6: Soft Modem (1M): Non-Secure */
	srtop_setting = MATRIX_SRTOP(0, MATRIX_SRTOP_VALUE_1M);
	sasplit_setting = MATRIX_SASPLIT(0, MATRIX_SASPLIT_VALUE_1M);
	ssr_setting = (MATRIX_LANSECH_NS(0)
			| MATRIX_RDNSECH_NS(0)
			| MATRIX_WRNSECH_NS(0));
	matrix_configure_slave_security(AT91C_BASE_MATRIX32,
					H32MX_SMD,
					srtop_setting,
					sasplit_setting,
					ssr_setting);
	return 0;
}
 static unsigned int security_ps_peri_id[] = {
	AT91C_ID_VDEC,
	AT91C_ID_PIOA,
	AT91C_ID_PIOB,
	AT91C_ID_PIOC,
	AT91C_ID_PIOE,
	AT91C_ID_USART2,
	AT91C_ID_USART3,
	AT91C_ID_USART4,
	AT91C_ID_TWI0,
	AT91C_ID_TWI2,
	AT91C_ID_HSMC,
	AT91C_ID_HSMCI0,
	AT91C_ID_HSMCI1,
	AT91C_ID_TC0,
	AT91C_ID_TC1,
	AT91C_ID_ADC,
	AT91C_ID_UHPHS,
	AT91C_ID_UDPHS,
	AT91C_ID_LCDC,
	AT91C_ID_ISI,
	AT91C_ID_GMAC,
	AT91C_ID_GMAC1,
	AT91C_ID_SPI0,
	AT91C_ID_SPI1,
	AT91C_ID_SMD,
	AT91C_ID_SSC0,
	AT91C_ID_SSC1,
};
 static int matrix_config_periheral(void)
{
	unsigned int *peri_id = security_ps_peri_id;
	unsigned int array_size = sizeof(security_ps_peri_id) / sizeof(unsigned int);
	int ret;
 	ret = matrix_configure_peri_security(peri_id, array_size);
	if (ret)
		return -1;
 	return 0;
}
 static int matrix_init(void)
{
	int ret;
 	matrix_write_protect_disable(AT91C_BASE_MATRIX64);
	matrix_write_protect_disable(AT91C_BASE_MATRIX32);
 	ret = matrix_configure_slave();
	if (ret)
		return -1;
 	ret = matrix_config_periheral();
	if (ret)
		return -1;
 	return 0;
}
#endif	/* #if defined(CONFIG_MATRIX) */
 #if defined(CONFIG_TWI0)
unsigned int at91_twi0_hw_init(void)
{
	unsigned int base_addr = AT91C_BASE_TWI0;
 	const struct pio_desc twi_pins[] = {
		{"TWD0", AT91C_PIN_PA(30), 0, PIO_DEFAULT, PIO_PERIPH_A},
		{"TWCK0", AT91C_PIN_PA(31), 0, PIO_DEFAULT, PIO_PERIPH_A},
		{(char *)0, 0, 0, PIO_DEFAULT, PIO_PERIPH_A},
	};
 	pmc_enable_periph_clock(AT91C_ID_PIOA);
	pio_configure(twi_pins);
 	pmc_enable_periph_clock(AT91C_ID_TWI0);
 	return base_addr;
}
#endif
 #if defined(CONFIG_TWI1)
unsigned int at91_twi1_hw_init(void)
{
	return 0;
}
#endif
 #if defined(CONFIG_TWI2)
unsigned int at91_twi2_hw_init(void)
{
	unsigned int base_addr = AT91C_BASE_TWI2;
 	const struct pio_desc twi_pins[] = {
		{"TWD2", AT91C_PIN_PB(29), 0, PIO_DEFAULT, PIO_PERIPH_A},
		{"TWCK2", AT91C_PIN_PB(30), 0, PIO_DEFAULT, PIO_PERIPH_A},
		{(char *)0, 0, 0, PIO_DEFAULT, PIO_PERIPH_A},
	};
 	pmc_enable_periph_clock(AT91C_ID_PIOB);
	pio_configure(twi_pins);
 	pmc_enable_periph_clock(AT91C_ID_TWI2);
 	return base_addr;
}
#endif
 #if defined(CONFIG_TWI3)
unsigned int at91_twi3_hw_init(void)
{
	unsigned int base_addr = AT91C_BASE_TWI3;
 	const struct pio_desc twi_pins[] = {
		{"TWD3", AT91C_PIN_PC(25), 0, PIO_DEFAULT, PIO_PERIPH_B},
		{"TWCK3", AT91C_PIN_PC(26), 0, PIO_DEFAULT, PIO_PERIPH_B},
		{(char *)0, 0, 0, PIO_DEFAULT, PIO_PERIPH_A},
	};
 	pmc_enable_periph_clock(AT91C_ID_PIOC);
	pio_configure(twi_pins);
 	pmc_enable_periph_clock(AT91C_ID_TWI3);
 	return base_addr;
}
#endif
 #if defined(CONFIG_AUTOCONFIG_TWI_BUS)
void at91_board_config_twi_bus(void)
{
	at24xx_twi_bus = 0;
 	attiny_twi_bus = 2;
 	act8865_twi_bus = 3;
}
#endif
 #if defined(CONFIG_ACT8865_SET_VOLTAGE)
int at91_board_act8865_set_reg_voltage(void)
{
	unsigned char reg, value;
	int ret;
 	/* Check ACT8865 I2C interface */
	if (act8865_check_i2c_disabled())
		return 0;
 	/* Enable REG5 output 3.3V */
	reg = REG5_0;
	value = ACT8865_3V3;
	ret = act8865_set_reg_voltage(reg, value);
	if (ret)
		dbg_loud("ACT8865: Failed to make REG5 output 3300mV\n");
 	/* Enable REG6 output 1.8V */
	reg = REG6_0;
	value = ACT8865_1V8;
	ret = act8865_set_reg_voltage(reg, value);
	if (ret)
		dbg_loud("ACT8865: Failed to make REG6 output 1800mV\n");
 	return 0;
}
#endif
 #if defined(CONFIG_PM)
void at91_disable_smd_clock(void)
{
	/*
	 * set pin DIBP to pull-up and DIBN to pull-down
	 * to save power on VDDIOP0
	 */
	pmc_enable_system_clock(AT91C_PMC_SMDCK);
	pmc_set_smd_clock_divider(AT91C_PMC_SMDDIV);
	pmc_enable_periph_clock(AT91C_ID_SMD);
	writel(0xF, (0x0C + AT91C_BASE_SMD));
	pmc_disable_periph_clock(AT91C_ID_SMD);
	pmc_disable_system_clock(AT91C_PMC_SMDCK);
}
#endif
 #if defined(CONFIG_MAC0_PHY)
unsigned int at91_eth0_hw_init(void)
{
	unsigned int base_addr = AT91C_BASE_GMAC;
 	const struct pio_desc macb_pins[] = {
		{"G0_MDC",	AT91C_PIN_PB(16), 0, PIO_DEFAULT, PIO_PERIPH_A},
		{"G0_MDIO",	AT91C_PIN_PB(17), 0, PIO_DEFAULT, PIO_PERIPH_A},
		{(char *)0, 0, 0, PIO_DEFAULT, PIO_PERIPH_A},
	};
 	pio_configure(macb_pins);
	pmc_enable_periph_clock(AT91C_ID_PIOB);
 	pmc_enable_periph_clock(AT91C_ID_GMAC);
 	return base_addr;
}
#endif
 #if defined(CONFIG_MACB)
void at91_disable_mac_clock(void)
{
#if defined(CONFIG_MAC0_PHY)
	pmc_disable_periph_clock(AT91C_ID_GMAC);
#endif
}
#endif
 #ifdef CONFIG_HW_INIT
void hw_init(void)
{
	/* Disable watchdog */
	at91_disable_wdt();
 	/* At this stage the main oscillator is supposed
	 * to be enabled PCK = MCK = MOSC
	 */
 	/* Switch PCK/MCK on Main clock output */
	pmc_cfg_mck(BOARD_PRESCALER_MAIN_CLOCK);
 	/* Configure PLLA = MOSC * (PLL_MULA + 1) / PLL_DIVA */
	pmc_cfg_plla(PLLA_SETTINGS);
 	/* Initialize PLLA charge pump */
	/* not needed for SAMA5D4 */
	pmc_init_pll(0);
 	/* Switch MCK on PLLA output */
	pmc_cfg_mck(BOARD_PRESCALER_PLLA);
 	/* Enable External Reset */
	writel(AT91C_RSTC_KEY_UNLOCK | AT91C_RSTC_URSTEN,
					AT91C_BASE_RSTC + RSTC_RMR);
 #if defined(CONFIG_ENTER_NWD)
	cpacr_init();
 	/* Program the DACR to allow client access to *all* domains */
	dacr_swd_init();
#endif
 #if defined(CONFIG_MATRIX)
	/* Initialize the matrix */
	matrix_init();
#endif
 	/* initialize the dbgu */
	initialize_dbgu();
 #if defined(CONFIG_MATRIX)
	matrix_read_slave_security();
	matrix_read_periperal_security();
#endif
 	/* Init timer */
	timer_init();
 #ifdef CONFIG_DDR2
	/* Initialize MPDDR Controller */
	ddramc_init();
#endif
 	/* Prepare L2 cache setup */
	l2cache_prepare();
 	// init PIOB IOs
	const struct pio_desc piob_pins[] = {
		{"G0_TXCK", AT91C_PIN_PB(0), 0, PIO_DEFAULT, PIO_INPUT},
		{"G0_TXEN", AT91C_PIN_PB(2), 0, PIO_DEFAULT, PIO_INPUT},
		{"G0_RXDV", AT91C_PIN_PB(6), 0, PIO_DEFAULT, PIO_INPUT},
		{"G0_RXER", AT91C_PIN_PB(7), 0, PIO_DEFAULT, PIO_INPUT},
		{"G0_RXD0", AT91C_PIN_PB(8), 0, PIO_DEFAULT, PIO_INPUT},
		{"G0_RXD1", AT91C_PIN_PB(9), 0, PIO_DEFAULT, PIO_INPUT},
		{"G0_TXD0", AT91C_PIN_PB(12), 0, PIO_DEFAULT, PIO_INPUT},
		{"G0_TXD1", AT91C_PIN_PB(13), 0, PIO_DEFAULT, PIO_INPUT},
		{"G0_MDC", AT91C_PIN_PB(16), 0, PIO_DEFAULT, PIO_INPUT},
		{"G0_MDIO", AT91C_PIN_PB(17), 0, PIO_DEFAULT, PIO_INPUT},
		{(char *)0, 0, 0, PIO_DEFAULT, PIO_PERIPH_A},
	};
 	/* Configure the PIO controller */
	pio_configure(piob_pins);
 	// init PIOE IOs
	const struct pio_desc pioe_pins[] = {
		{"G0_IRQ", AT91C_PIN_PE(0), 0, PIO_DEFAULT, PIO_INPUT},
		{"MCI1_CD", AT91C_PIN_PE(3), 0, PIO_DEFAULT, PIO_INPUT},
		{"CTS3", AT91C_PIN_PE(5), 0, PIO_DEFAULT, PIO_INPUT},
		{"PMIC_IRQ", AT91C_PIN_PE(25), 0, PIO_DEFAULT, PIO_INPUT},
		{"USB_SENSE", AT91C_PIN_PE(31), 0, PIO_DEFAULT, PIO_INPUT},
		{(char *)0, 0, 0, PIO_DEFAULT, PIO_PERIPH_A},
	};
 	/* Configure the PIO controller */
	pio_configure(pioe_pins);
 	pmc_enable_periph_clock(AT91C_ID_PIOB);
	pmc_enable_periph_clock(AT91C_ID_PIOE);
}
#endif /* #ifdef CONFIG_HW_INIT */
 #ifdef CONFIG_SDCARD
#ifdef CONFIG_OF_LIBFDT
void at91_board_set_dtb_name(char *of_name)
{
	strcpy(of_name, "lorix_one.dtb");
}
#endif
 void at91_mci0_hw_init(void)
{
	const struct pio_desc mci_pins[] = {
		{"MCI1_CK", AT91C_PIN_PE(18), 0, PIO_DEFAULT, PIO_PERIPH_C},
		{"MCI1_CDA", AT91C_PIN_PE(19), 0, PIO_DEFAULT, PIO_PERIPH_C},
 		{"MCI1_DA0", AT91C_PIN_PE(20), 0, PIO_DEFAULT, PIO_PERIPH_C},
		{"MCI1_DA1", AT91C_PIN_PE(21), 0, PIO_DEFAULT, PIO_PERIPH_C},
		{"MCI1_DA2", AT91C_PIN_PE(22), 0, PIO_DEFAULT, PIO_PERIPH_C},
		{"MCI1_DA3", AT91C_PIN_PE(23), 0, PIO_DEFAULT, PIO_PERIPH_C},
		{(char *)0, 0, 0, PIO_DEFAULT, PIO_PERIPH_A},
	};
 	/* Configure the PIO controller */
	pio_configure(mci_pins);
	pmc_enable_periph_clock(AT91C_ID_PIOE);
	pmc_enable_periph_clock(AT91C_ID_HSMCI1);
}
#endif /* #ifdef CONFIG_SDCARD */
 #ifdef CONFIG_NANDFLASH
void nandflash_hw_init(void)
{
	/* Configure nand pins */
	const struct pio_desc nand_pins[] = {
		{"NANDOE",	CONFIG_SYS_NAND_OE_PIN,
					0, PIO_PULLUP, PIO_PERIPH_A},
		{"NANDWE",	CONFIG_SYS_NAND_WE_PIN,
					0, PIO_PULLUP, PIO_PERIPH_A},
		{"NANDALE",	CONFIG_SYS_NAND_ALE_PIN,
					0, PIO_PULLUP, PIO_PERIPH_A},
		{"NANDCLE",	CONFIG_SYS_NAND_CLE_PIN,
					0, PIO_PULLUP, PIO_PERIPH_A},
		{"NANDCS",	CONFIG_SYS_NAND_ENABLE_PIN,
					1, PIO_DEFAULT, PIO_OUTPUT},
		{"D0",	AT91C_PIN_PC(5), 0, PIO_PULLUP, PIO_PERIPH_A},
		{"D1",	AT91C_PIN_PC(6), 0, PIO_PULLUP, PIO_PERIPH_A},
		{"D2",	AT91C_PIN_PC(7), 0, PIO_PULLUP, PIO_PERIPH_A},
		{"D3",	AT91C_PIN_PC(8), 0, PIO_PULLUP, PIO_PERIPH_A},
		{"D4",	AT91C_PIN_PC(9), 0, PIO_PULLUP, PIO_PERIPH_A},
		{"D5",	AT91C_PIN_PC(10), 0, PIO_PULLUP, PIO_PERIPH_A},
		{"D6",	AT91C_PIN_PC(11), 0, PIO_PULLUP, PIO_PERIPH_A},
		{"D7",	AT91C_PIN_PC(12), 0, PIO_PULLUP, PIO_PERIPH_A},
		{(char *)0, 0, 0, PIO_DEFAULT, PIO_PERIPH_A},
	};
 	/* Configure the nand controller pins*/
	pio_configure(nand_pins);
	pmc_enable_periph_clock(AT91C_ID_PIOC);
 	/* Enable the clock */
	pmc_enable_periph_clock(AT91C_ID_HSMC);
 	/* EBI Configuration Register */
	writel((AT91C_EBICFG_DRIVE0_HIGH
		| AT91C_EBICFG_PULL0_NONE
		| AT91C_EBICFG_DRIVE1_HIGH
		| AT91C_EBICFG_PULL1_NONE), SFR_EBICFG + AT91C_BASE_SFR);
 	/* Configure SMC CS3 for NAND/SmartMedia */
	writel(AT91C_SMC_SETUP_NWE(1)
		| AT91C_SMC_SETUP_NCS_WR(1)
		| AT91C_SMC_SETUP_NRD(1)
		| AT91C_SMC_SETUP_NCS_RD(1),
		(ATMEL_BASE_SMC + SMC_SETUP3));
 	writel(AT91C_SMC_PULSE_NWE(2)
		| AT91C_SMC_PULSE_NCS_WR(3)
		| AT91C_SMC_PULSE_NRD(2)
		| AT91C_SMC_PULSE_NCS_RD(3),
		(ATMEL_BASE_SMC + SMC_PULSE3));
 	writel(AT91C_SMC_CYCLE_NWE(5)
		| AT91C_SMC_CYCLE_NRD(5),
		(ATMEL_BASE_SMC + SMC_CYCLE3));
 	writel(AT91C_SMC_TIMINGS_TCLR(2)
		| AT91C_SMC_TIMINGS_TADL(7)
		| AT91C_SMC_TIMINGS_TAR(2)
		| AT91C_SMC_TIMINGS_TRR(3)
		| AT91C_SMC_TIMINGS_TWB(7)
		| AT91C_SMC_TIMINGS_RBNSEL(2)
		| AT91C_SMC_TIMINGS_NFSEL,
		(ATMEL_BASE_SMC + SMC_TIMINGS3));
 	writel(AT91C_SMC_MODE_READMODE_NRD_CTRL
		| AT91C_SMC_MODE_WRITEMODE_NWE_CTRL
		| AT91C_SMC_MODE_DBW_8
		| AT91C_SMC_MODE_TDF_CYCLES(1),
		(ATMEL_BASE_SMC + SMC_MODE3));
}
#endif /* #ifdef CONFIG_NANDFLASH */
