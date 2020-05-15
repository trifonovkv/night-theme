export prefix = /usr/local
export DESTDIR =
export BINDIR = $(DESTDIR)$(prefix)/bin
export BUILDDIR = $(CURDIR)/build
export INSTALL = /usr/bin/install -Dv
export INSTALL_DATA = /usr/bin/install -Dv -m 644

TOPTARGETS = all install uninstall
SUBDIRS = schemas service settings
VERSION = 0.1
APP = night-theme-$(VERSION)
ZIP = $(APP).tar.gz
DIST_DIR = ./dist

$(TOPTARGETS) : $(SUBDIRS)

$(SUBDIRS) :
	$(MAKE) -C $@ $(MAKECMDGOALS)

.PHONY : $(TOPTARGETS) $(SUBDIRS) dist clean rpm distclean

start :
	$(MAKE) -C ./service start

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
									$(APP)
	tar czvf $(ZIP) $(APP)
	rm -rf $(APP)
	mv $(ZIP) $(DIST_DIR)

rpm : dist
	sed -i 's/^Version:.*/Version:        $(VERSION)/' night-theme.spec 
	rpmdev-setuptree
	cp $(DIST_DIR)/$(ZIP) ~/rpmbuild/SOURCES
	cp night-theme.spec ~/rpmbuild/SPECS
	rpmbuild -ba ~/rpmbuild/SPECS/night-theme.spec
	cp ~/rpmbuild/RPMS/x86_64/* $(DIST_DIR)/
	rm -rf ~/rpmbuild

distclean : 
	rm -rf $(DIST_DIR)