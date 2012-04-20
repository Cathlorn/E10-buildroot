#############################################################
#
# python-pyusb
#
#############################################################

PYTHON_PYUSB_VERSION = 1.0.0a2
#PYTHON_PYUSB_SOURCE  = pyusb-$(PYTHON_PYUSB_VERSION).zip
#PYTHON_PYUSB_VERSION = 0.4.3
PYTHON_PYUSB_SOURCE  = pyusb-$(PYTHON_PYUSB_VERSION).tar.gz
#PYTHON_PYUSB_SITE    = http://downloads.sourceforge.net/project/pyusb/PyUSB%200.x/0.4.3/
PYTHON_PYUSB_SITE    = http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/pyusb

PYTHON_PYUSB_DEPENDENCIES = python host-python host-python-setuptools libusb

define PYTHON_PYUSB_BUILD_CMDS
	(cd $(@D); $(HOST_DIR)/usr/bin/python setup.py build)
endef

define PYTHON_PYUSB_INSTALL_TARGET_CMDS
	(cd $(@D); $(HOST_DIR)/usr/bin/python setup.py install --prefix=$(TARGET_DIR)/usr)
endef

$(eval $(call GENTARGETS))
