INSTALL_DIR = $(BINDIR)/night-theme-settings
NTS = $(BUILDDIR)/nts.sh
TARGET_NTS = $(BINDIR)/nts.sh

.PHONY : install install-settings install-nts

all : $(NTS)

install : install-settings install-nts

install-settings : NightThemeSettings.js NightThemeSettings.glade
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
	echo /usr/bin/env gjs NightThemeSettings.js >> $@