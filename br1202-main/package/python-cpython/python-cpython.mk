#############################################################
#
# python-cpython
#
#############################################################

PYTHON_CPYTHON_VERSION = 0.15.1
PYTHON_CPYTHON_SOURCE  = Cython-$(PYTHON_CPYTHON_VERSION).tar.gz
PYTHON_CPYTHON_SITE    = http://pypi.python.org/packages/source/C/Cython

PYTHON_CPYTHON_DEPENDENCIES = python

define PYTHON_CPYTHON_BUILD_CMDS
	(cd $(@D); $(HOST_DIR)/usr/bin/python setup.py build)
endef

define PYTHON_CPYTHON_INSTALL_TARGET_CMDS
	(cd $(@D); $(HOST_DIR)/usr/bin/python setup.py install --prefix=$(TARGET_DIR)/usr)
endef

$(eval $(call GENTARGETS))
