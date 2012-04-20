#############################################################
#
# python-pyftdi
#
#############################################################

PYTHON_PYFTDI_VERSION = 0.5.2
PYTHON_PYFTDI_SOURCE  = pyftdi-$(PYTHON_PYFTDI_VERSION).tar.gz
PYTHON_PYFTDI_SITE    = http://pypi.python.org/packages/source/p/pyftdi/

PYTHON_PYFTDI_DEPENDENCIES = python python-pyusb

define PYTHON_PYFTDI_BUILD_CMDS
	(cd $(@D); $(HOST_DIR)/usr/bin/python setup.py build)
endef

define PYTHON_PYFTDI_INSTALL_TARGET_CMDS
	(cd $(@D); $(HOST_DIR)/usr/bin/python setup.py install --prefix=$(TARGET_DIR)/usr)
endef

$(eval $(call GENTARGETS))
