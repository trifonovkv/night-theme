INSTALL_DIR = $(bindir)/night-theme-settings

.PHONY : install install-settings install-nts clean

all :

clean :

install : install-settings install-nts

install-settings : NightThemeSettings.js NightThemeSettings.glade
	mkdir -p $(INSTALL_DIR)
	install $^ $(INSTALL_DIR)

install-nts : nts.sh
	install -m 755 $^ $(bindir)