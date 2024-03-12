include $(TOPDIR)/rules.mk

PKG_NAME:=mbpl-usb
PKG_VERSION:=35.0
PKG_RELEASE:=1

include $(INCLUDE_DIR)/kernel.mk
include $(INCLUDE_DIR)/package.mk

define KernelPackage/mbpl-usb
	SUBMENU:=WWAN Support
	TITLE:=Sierra Wireless Linux USB Mobile Broadband Drivers
	CONFLICTS:=\
		kmod-usb-net-qmi-wwan \
		kmod-usb-serial-wwan \
		kmod-usb-serial-qualcomm
	DEPENDS:=+kmod-usb-wdm +kmod-usb-serial +kmod-usb-net
	FILES:=\
		$(PKG_BUILD_DIR)/qcserial.ko \
		$(PKG_BUILD_DIR)/usb_wwan.ko \
		$(PKG_BUILD_DIR)/qmi_wwan.ko
	AUTOLOAD:=$(call AutoProbe,usb_wwan qmi_wwan qcserial)
endef

define KernelPackage/mbpl-usb/description
	Sierra Wireless Linux USB Mobile Broadband Drivers
	(with qcserial usb_wwan qmi_wwan)
endef

MAKE_OPTS:= \
	ARCH="$(LINUX_KARCH)" \
	CROSS_COMPILE="$(TARGET_CROSS)" \
	CXXFLAGS="$(TARGET_CXXFLAGS)" \
	M="$(PKG_BUILD_DIR)" \
	$(EXTRA_KCONFIG)

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
	$(CP) ./src/* $(PKG_BUILD_DIR)/
endef

define Build/Compile
	$(MAKE) -C "$(LINUX_DIR)" \
		$(MAKE_OPTS) \
		modules
endef

$(eval $(call KernelPackage,mbpl-usb)) 
