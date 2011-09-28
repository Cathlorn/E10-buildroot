#############################################################
#
# ppp-scripts
#
#############################################################
PPP_SCRIPTS_VERSION:=1.0.0
PPP_SCRIPTS_SOURCE:=ppp-scripts-$(PPP_SCRIPTS_VERSION).tar.gz
PPP_SCRIPTS_SITE:=http://engr.synapse-wireless.com/
PPP_SCRIPTS_CAT:=$(ZCAT)
PPP_SCRIPTS_DIR:=$(BUILD_DIR)/ppp-scripts-$(PPP_SCRIPTS_VERSION)


$(DL_DIR)/$(PPP_SCRIPTS_SOURCE):
	 $(call DOWNLOAD,$(PPP_SCRIPTS_SITE),$(PPP_SCRIPTS_SOURCE))

$(PPP_SCRIPTS_DIR)/.unpacked: $(DL_DIR)/$(PPP_SCRIPTS_SOURCE)
	mkdir $(PPP_SCRIPTS_DIR)
	$(PPP_SCRIPTS_CAT) $(DL_DIR)/$(PPP_SCRIPTS_SOURCE) | tar -C $(PPP_SCRIPTS_DIR) $(TAR_OPTIONS) -
	touch $@

$(PPP_SCRIPTS_DIR)/.installed: $(PPP_SCRIPTS_DIR)/.unpacked
	cp -r $(PPP_SCRIPTS_DIR)/ppp $(TARGET_DIR)/etc
	touch -c $@

ppp-scripts: $(PPP_SCRIPTS_DIR)/.installed

ppp-scripts-source: $(DL_DIR)/$(PPP_SCRIPTS_SOURCE)

ppp-scripts-clean:
	rm -rf $(TARGET_DIR)/etc/ppp

ppp-scripts-dirclean:
	rm -rf $(PPP_SCRIPTS_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(BR2_PACKAGE_PPP_SCRIPTS),y)
TARGETS+=ppp-scripts
endif
