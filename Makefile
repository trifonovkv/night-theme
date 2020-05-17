export prefix = /usr/local
export DESTDIR =
export BINDIR = $(DESTDIR)$(prefix)/bin
export SHAREDIR = $(DESTDIR)$(prefix)/share
export BUILDDIR = $(CURDIR)/build
export INSTALL = /usr/bin/install -Dv
export INSTALL_DATA = /usr/bin/install -Dv -m 644
export DBUS_SERVICE_NAME = com.github.trifonovkv.ThemesSwitcher

TOPTARGETS = all install uninstall
SUBDIRS = schemas service settings
VERSION = 0.1
APP = night-theme-$(VERSION)
ZIP = $(APP).tar.gz
DIST_DIR = ./dist

$(TOPTARGETS) : $(SUBDIRS)

$(SUBDIRS) :
	$(MAKE) -C $@ $(MAKECMDGOALS)

.PHONY : $(TOPTARGETS) $(SUBDIRS) dist clean rpm distclean start

start : 
	$(MAKE) -C ./schemas start

clean :
	rm -rf $(BUILDDIR)

dist : clean
	mkdir -p $(APP) $(DIST_DIR)
	cp -a schemas \
				service \
				settings \
				LICENSE \
				Makefile \
				README \
				night-theme.in \
									$(APP)
	tar czvf $(ZIP) $(APP)
	rm -rf $(APP)
	mv $(ZIP) $(DIST_DIR)

rpm : dist
	sed 's/VERSION/$(VERSION)/' night-theme.in > $(DIST_DIR)/night-theme.spec
	rpmdev-setuptree
	cp $(DIST_DIR)/$(ZIP) ~/rpmbuild/SOURCES
	cp $(DIST_DIR)/night-theme.spec ~/rpmbuild/SPECS
	rpmbuild -ba ~/rpmbuild/SPECS/night-theme.spec
	cp -a ~/rpmbuild/RPMS $(DIST_DIR)/
	rm -rf ~/rpmbuild

distclean : 
	rm -rf $(DIST_DIR)