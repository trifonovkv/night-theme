NAME = NightThemeSettings
INSTALL_DIR = $(BINDIR)/night-theme-settings
NTS = $(BUILDDIR)/nts.sh
TARGET_NTS = $(BINDIR)/nts.sh
JS = $(BUILDDIR)/$(NAME).js

.PHONY : install install-settings install-nts

all : $(NTS) $(JS)

$(JS) : $(NAME).in
	sed 's/DBUS_SERVICE_NAME/$(DBUS_SERVICE_NAME)/' $^ > $(JS)

install : install-settings install-nts

install-settings : $(JS) $(NAME).glade
	mkdir -p $(INSTALL_DIR)
	install $^ $(INSTALL_DIR)

install-nts : $(NTS)
	install -m 755 $^ $(TARGET_NTS)

uninstall :
	rm -rf $(INSTALL_DIR)
	rm -f $(TARGET_NTS)

$(NTS) :
	echo "#!/bin/sh" > $@
	echo >> $@
	echo cd $(INSTALL_DIR) >> $@
	echo /usr/bin/env gjs $(NAME).js >> $@ 