ARCHS = arm64 armv7s armv7

include theos/makefiles/common.mk

BUNDLE_NAME = BitlyforActionMenu
BitlyforActionMenu_FILES = BitlyforActionMenu.mm
BitlyforActionMenu_INSTALL_PATH = /Library/PreferenceBundles
BitlyforActionMenu_FRAMEWORKS = UIKit
BitlyforActionMenu_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/BitlyforActionMenu.plist$(ECHO_END)
