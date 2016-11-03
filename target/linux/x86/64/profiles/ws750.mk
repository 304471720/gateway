#
# Copyright (C) 2006-2009 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

define Profile/ws750
  NAME:=ws750
  PACKAGES:=kmod-3c59x kmod-8139too kmod-e100 kmod-e1000 kmod-e1000e kmod-natsemi kmod-ne2k-pci kmod-nf-nathelper \
	  kmod-pcnet32 kmod-r8169 kmod-sis900 kmod-tg3 kmod-via-rhine kmod-via-velocity kmod-aoe kmod-ata-core \
	  kmod-ata-ahci kmod-ata-artop kmod-ata-marvell-sata kmod-ata-nvidia-sata kmod-ata-pdc202xx-old kmod-ata-piix \
	  kmod-ata-sil kmod-ata-sil24 kmod-ata-via-sata kmod-block2mtd kmod-dm kmod-ide-core kmod-ide-aec62xx \
	  kmod-ide-generic kmod-ide-generic-old kmod-ide-it821x kmod-ide-pdc202xx kmod-libsas kmod-loop kmod-md-mod \
	  kmod-md-linear kmod-md-multipath kmod-md-raid0 kmod-md-raid1 kmod-md-raid10 kmod-md-raid456 kmod-mvsas \
	  kmod-nbd kmod-scsi-cdrom kmod-scsi-core kmod-scsi-generic kmod-crypto-aead kmod-crypto-core kmod-crypto-hash \
	  kmod-crypto-manager kmod-crypto-pcompress kmod-hwmon-core kmod-lib-crc-ccitt kmod-lib-raid6 kmod-lib-xor \
	  kmod-nls-base kmod-ip6tables kmod-ipt-conntrack kmod-ipt-core kmod-ipt-nat kmod-nf-conntrack kmod-nf-conntrack6 \
	  kmod-nf-ipt kmod-nf-ipt6 kmod-nf-nat kmod-nf-nathelper kmod-3c59x kmod-8139too kmod-e100 kmod-e1000 kmod-e1000e \
	  kmod-libphy kmod-mii kmod-natsemi kmod-ne2k-pci kmod-pcnet32 kmod-r8169 kmod-sis900 kmod-tg3 kmod-via-rhine \
	  kmod-via-velocity kmod-ipv6 kmod-ppp kmod-pppoe kmod-pppox kmod-slhc kmod-tun kmod-pps kmod-ptp kmod-usb-core \
	  kmod-usb-storage kmod-usb-storage-extras kmod-usb2 kmod-usb2-pci kmod-usb3 
endef

define Profile/ws750/Description
	ws750 Profiles
endef
$(eval $(call Profile,ws750))
