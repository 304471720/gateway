/*
 * Atheros DB120 reference board support
 *
 * Copyright (c) 2011 Qualcomm Atheros
 * Copyright (c) 2011-2012 Gabor Juhos <juhosg@openwrt.org>
 *
 * Permission to use, copy, modify, and/or distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 *
 */

#include <linux/pci.h>
#include <linux/phy.h>
#include <linux/platform_device.h>
#include <linux/ath9k_platform.h>
#include <linux/ar8216_platform.h>
#include <linux/platform_data/phy-at803x.h>

#include <asm/mach-ath79/ar71xx_regs.h>

#include "common.h"
#include "dev-ap9x-pci.h"
#include "dev-eth.h"
#include "dev-gpio-buttons.h"
#include "dev-leds-gpio.h"
#include "dev-m25p80.h"
#include "dev-nfc.h"
#include "dev-spi.h"
#include "dev-usb.h"
#include "dev-wmac.h"
#include "machtypes.h"

#define DB120_GPIO_LED_USB		11
#define DB120_GPIO_LED_WLAN_5G		12
#define DB120_GPIO_LED_WLAN_2G		13
#define DB120_GPIO_LED_STATUS		14
//#define DB120_GPIO_LED_WPS		15

#define DB120_GPIO_BTN_WPS		16
#define DB120_GPIO_BTN_RESET            15

#define DB120_KEYS_POLL_INTERVAL	20	/* msecs */
#define DB120_KEYS_DEBOUNCE_INTERVAL	(3 * DB120_KEYS_POLL_INTERVAL)

#define DB120_MAC0_OFFSET		0
#define DB120_MAC1_OFFSET		6
#define DB120_WMAC_CALDATA_OFFSET	0x1000
#define DB120_PCIE_CALDATA_OFFSET	0x5000

static struct gpio_led db120_leds_gpio[] __initdata =
{
    {
        .name		= "wifisong-ws550:green:status",
        .gpio		= DB120_GPIO_LED_STATUS,
        .active_low	= 1,
    },
    /*	{
    		.name		= "wifisong-ws550:green:wps",
    		.gpio		= DB120_GPIO_LED_WPS,
    		.active_low	= 1,
    	},
    */
    {
        .name		= "wifisong-ws550:green:wlan-5g",
        .gpio		= DB120_GPIO_LED_WLAN_5G,
        .active_low	= 1,
    },
    {
        .name		= "wifisong-ws550:green:wlan-2g",
        .gpio		= DB120_GPIO_LED_WLAN_2G,
        .active_low	= 1,
    },
    {
        .name		= "wifisong-ws550:green:usb",
        .gpio		= DB120_GPIO_LED_USB,
        .active_low	= 1,
    }
};

static struct gpio_keys_button db120_gpio_keys[] __initdata =
{
    /*	{
    		.desc		= "WPS button",
    		.type		= EV_KEY,
    		.code		= KEY_WPS_BUTTON,
    		.debounce_interval = DB120_KEYS_DEBOUNCE_INTERVAL,
    		.gpio		= DB120_GPIO_BTN_WPS,
    		.active_low	= 1,
    	},
    */
    {
        .desc		= "restart button",
        .type		= EV_KEY,
        .code		= KEY_RESTART,
        .debounce_interval = DB120_KEYS_DEBOUNCE_INTERVAL,
        .gpio		= DB120_GPIO_BTN_RESET,
        .active_low	= 1,
    }
};
#if 0
static struct ar8327_pad_cfg db120_ar8327_pad0_cfg =
{
    .mode = AR8327_PAD_MAC_RGMII,
    .txclk_delay_en = true,
    .rxclk_delay_en = true,
    .txclk_delay_sel = AR8327_CLK_DELAY_SEL1,
    .rxclk_delay_sel = AR8327_CLK_DELAY_SEL2,
};

static struct ar8327_led_cfg db120_ar8327_led_cfg =
{
    .led_ctrl0 = 0x00000000,
    .led_ctrl1 = 0xc737c737,
    .led_ctrl2 = 0x00000000,
    .led_ctrl3 = 0x00c30c00,
    .open_drain = true,
};

static struct ar8327_platform_data db120_ar8327_data =
{
    .pad0_cfg = &db120_ar8327_pad0_cfg,
    .port0_cfg = {
        .force_link = 1,
        .speed = AR8327_PORT_SPEED_1000,
        .duplex = 1,
        .txpause = 1,
        .rxpause = 1,
    },
    .led_cfg = &db120_ar8327_led_cfg,
 };

static struct mdio_board_info db120_mdio0_info[] =
{
    {
        .bus_id = "ag71xx-mdio.0",
        .phy_addr = 4,
        .platform_data = &db120_ar8327_data,
    },
};
#endif
static struct at803x_platform_data mi124_ar8035_data =
{
    .enable_rgmii_rx_delay = 1,
    .fixup_rgmii_tx_delay = 1,
};

static struct mdio_board_info mi124_mdio0_info[] =
{
    {
        .bus_id = "ag71xx-mdio.0",
        .phy_addr = 4,
        .platform_data = &mi124_ar8035_data,
    },
};

int hexCharToValue(const char ch)
{
    int result = 0;

    if(ch >= '0' && ch <= '9')
    {
        result = (int)(ch - '0');
    }
    else if(ch >= 'a' && ch <= 'z')
    {
        result = (int)(ch - 'a') + 10;
    }
    else if(ch >= 'A' && ch <= 'Z')
    {
        result = (int)(ch - 'A') + 10;
    }
    else
    {
        result = -1;
    }
    return result;
}

static void __init wifisong_ws550_setup(void)
{
    u8 *art = (u8 *) KSEG1ADDR(0x1fff0000);
    u8 *eep_mac_addr = (u8 *) KSEG1ADDR(0x1ffe004a);	//(0xbffe004a);
    u8 mac_addr[6];
    int i = 0;

    if(eep_mac_addr[0] != 0xff)
    {
        for(i = 0; i < 6; i++)
        {
            mac_addr[i] = (hexCharToValue(eep_mac_addr[i*2])<<4) + hexCharToValue(eep_mac_addr[i*2 + 1]);
        }
    }
    ath79_gpio_output_select(DB120_GPIO_LED_USB, AR934X_GPIO_OUT_GPIO);
    ath79_register_m25p80(NULL);

    ath79_register_leds_gpio(-1, ARRAY_SIZE(db120_leds_gpio),
                             db120_leds_gpio);
    ath79_register_gpio_keys_polled(-1, DB120_KEYS_POLL_INTERVAL,
                                    ARRAY_SIZE(db120_gpio_keys),
                                    db120_gpio_keys);
    ath79_register_usb();
    ath79_register_wmac(art + DB120_WMAC_CALDATA_OFFSET, NULL);
    ap91_pci_init(art + DB120_PCIE_CALDATA_OFFSET, NULL);

    ath79_register_mdio(1, 0x0);
    ath79_register_mdio(0, 0x0);

    mdiobus_register_board_info(mi124_mdio0_info, ARRAY_SIZE(mi124_mdio0_info));

    ath79_setup_ar934x_eth_cfg(AR934X_ETH_CFG_RGMII_GMAC0 | AR934X_ETH_CFG_SW_ONLY_MODE);

    /* GMAC0 is connected to an AR8035 Gigabit PHY */
    ath79_init_mac(ath79_eth0_data.mac_addr, mac_addr, 0);
    ath79_eth0_data.phy_if_mode = PHY_INTERFACE_MODE_RGMII;
    ath79_eth0_data.phy_mask = BIT(4);
    ath79_eth0_data.mii_bus_dev = &ath79_mdio0_device.dev;
    ath79_eth0_pll_data.pll_1000 = 0x0e000000;
    ath79_eth0_pll_data.pll_100 = 0x0101;
    ath79_eth0_pll_data.pll_10 = 0x1313;
    ath79_register_eth(0);


    //ath79_register_nfc();
}

MIPS_MACHINE(ATH79_MACH_WIFISONG_WS550, "WiFiSong-WS550", "WiFiSong WS550",wifisong_ws550_setup);
