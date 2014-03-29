include theos/makefiles/common.mk

TWEAK_NAME = BitlyForActionMenu
BitlyForActionMenu_FILES = Handler.xm
BitlyForActionMenu_LIBRARIES = actionmenu
BitlyForActionMenu_FRAMEWORKS = UIKit CoreFoundation
BitlyForActionMenu_INSTALL_PATH = /Library/ActionMenu/Plugins

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += bitlyforactionmenu
include $(THEOS_MAKE_PATH)/aggregate.mk
