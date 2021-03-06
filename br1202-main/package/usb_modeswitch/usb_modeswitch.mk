#############################################################
#
# usb_modeswitch
#
#############################################################

USB_MODESWITCH_VERSION = 1.2.3
USB_MODESWITCH_SOURCE = usb-modeswitch-$(USB_MODESWITCH_VERSION).tar.bz2
USB_MODESWITCH_SITE = http://www.draisberghof.de/usb_modeswitch
USB_MODESWITCH_DEPENDENCIES = libusb-compat

define USB_MODESWITCH_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) CC="$(TARGET_CC)" LD="$(TARGET_LD)" -C $(@D)
endef

define USB_MODESWITCH_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) DESTDIR=$(TARGET_DIR) install
endef


define USB_MODESWITCH_CLEAN_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) DESTDIR=$(TARGET_DIR) clean
endef

define USB_MODESWITCH_UNINSTALL_CMDS
	$(RM) -f $(TARGET_DIR)/usr/sbin/usb_modeswitch
	$(RM) -f $(TARGET_DIR)/lib/udev/usb_modeswitch
	$(RM) -f $(TARGET_DIR)/etc/usb_modeswitch.setup
	$(RM) -f $(TARGET_DIR)/usr/share/man/man1/usb_modeswitch.1
	$(RM) -rf $(TARGET_DIR)/var/lib/usb_modeswitch
	$(RM) -f $(TARGET_DIR)/usr/sbin/usb_modeswitch_dispatcher
endef

$(eval $(call GENTARGETS))

