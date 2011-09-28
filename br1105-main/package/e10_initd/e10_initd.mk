#############################################################
#
# e10_initd
#
#############################################################
E10_INITD_VERSION:=1.0.0
E10_INITD_SOURCE:=e10_initd-$(E10_INITD_VERSION).tar.gz
E10_INITD_SITE:=http://engr.synapse-wireless.com/
E10_INITD_CAT:=$(ZCAT)
E10_INITD_DIR:=$(BUILD_DIR)/e10_initd-$(E10_INITD_VERSION)


$(DL_DIR)/$(E10_INITD_SOURCE):
	 $(call DOWNLOAD,$(E10_INITD_SITE),$(E10_INITD_SOURCE))

$(E10_INITD_DIR)/.unpacked: $(DL_DIR)/$(E10_INITD_SOURCE)
	mkdir -p $(E10_INITD_DIR)
	$(E10_INITD_CAT) $(DL_DIR)/$(E10_INITD_SOURCE) | tar -C $(E10_INITD_DIR) $(TAR_OPTIONS) -
	touch $@

$(E10_INITD_DIR)/.installed: $(E10_INITD_DIR)/.unpacked
	cp $(E10_INITD_DIR)/* $(TARGET_DIR)/etc/init.d
	touch -c $@

e10_initd: $(E10_INITD_DIR)/.installed

e10_initd-source: $(DL_DIR)/$(E10_INITD_SOURCE)

#e10_initd-clean:
#	rm -f $(TARGET_DIR)/etc/ppp

e10_initd-dirclean:
	rm -rf $(E10_INITD_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(BR2_PACKAGE_E10_INITD),y)
TARGETS+=e10_initd
endif
