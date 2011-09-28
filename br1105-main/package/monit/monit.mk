#############################################################
#
# monit
#
#############################################################

MONIT_VERSION:=5.2.3
MONIT_SOURCE:=monit-$(MONIT_VERSION).tar.gz
MONIT_SITE:=http://mmonit.com/monit/dist/
MONIT_INSTALL_STAGING = YES
MONIT_INSTALL_TARGET = YES
MONIT_CONF_OPT =  --without-ssl  --prefix=/usr
MONIT_INSTALL_TARGET_OPT = DESTDIR=$(TARGET_DIR) install

$(eval $(call AUTOTARGETS,package,monit))
