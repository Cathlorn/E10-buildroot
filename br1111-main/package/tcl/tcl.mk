#############################################################
#
# TCL8.4
#
#############################################################
TCL_VERSION_MAJOR = 8.4
TCL_VERSION_MINOR = 19
TCL_VERSION = $(TCL_VERSION_MAJOR).$(TCL_VERSION_MINOR)
TCL_SOURCE = tcl$(TCL_VERSION)-src.tar.gz
TCL_SITE = http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/tcl
TCL_SUBDIR = unix
TCL_CONF_OPT = \
		--disable-symbols \
		--disable-langinfo \
		--disable-framework

HOST_TCL_CONF_OPT = \
		--disable-symbols \
		--disable-langinfo \
		--disable-framework

# libtcl is installed with mode 444, so correct that first.
define TCL_POST_INSTALL_STRIP
	chmod +w $(TARGET_DIR)/usr/lib/libtcl$(TCL_VERSION_MAJOR).so
	-$(STRIPCMD) $(STRIP_STRIP_UNNEEDED) $(TARGET_DIR)/usr/lib/libtcl$(TCL_VERSION_MAJOR).so
endef
TCL_POST_INSTALL_TARGET_HOOKS += TCL_POST_INSTALL_STRIP

define TCL_POST_INSTALL_RM_ENCODINGS-y
	rm -Rf $(TARGET_DIR)/usr/lib/tcl$(TCL_VERSION_MAJOR)/encoding/*
endef
TCL_POST_INSTALL_TARGET_HOOKS += TCL_POST_INSTALL_RM_ENCODINGS-$(BR2_PACKAGE_TCL_DEL_ENCODINGS)

define TCL_POST_INSTALL_RM_TCLSH-
	rm -f $(TARGET_DIR)/usr/bin/tclsh$(TCL_VERSION_MAJOR)
endef
TCL_POST_INSTALL_TARGET_HOOKS += TCL_POST_INSTALL_RM_TCLSH-$(BR2_PACKAGE_TCL_TCLSH)

define TCL_POST_INSTALL_LN_TCLSH-y
	ln -snf tclsh$(TCL_VERSION_MAJOR) $(TARGET_DIR)/usr/bin/tclsh
endef
TCL_POST_INSTALL_TARGET_HOOKS += TCL_POST_INSTALL_LN_TCLSH-$(BR2_PACKAGE_TCL_TCLSH)


$(eval $(call AUTOTARGETS))
$(eval $(call AUTOTARGETS,host))
