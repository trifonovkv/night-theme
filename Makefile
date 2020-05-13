export prefix = /usr/local
export DESTDIR =
export BINDIR = $(DESTDIR)$(prefix)/bin
export BUILDDIR = $(CURDIR)/build
export INSTALL = /usr/bin/install -Dv
export INSTALL_DATA = /usr/bin/install -Dv -m 644

TOPTARGETS = all install uninstall
SUBDIRS = schemas service settings
VERSION = 0.1
DIST_DIR = night-theme-$(VERSION)

$(TOPTARGETS) : $(SUBDIRS)

$(SUBDIRS) :
	$(MAKE) -C $@ $(MAKECMDGOALS)

.PHONY : $(TOPTARGETS) $(SUBDIRS) dist clean

start :
	$(MAKE) -C ./service start

clean :
	rm -rf $(BUILDDIR)

dist : clean
	mkdir -p $(DIST_DIR)
	cp -a schemas \
				service \
				settings \
				LICENSE \
				Makefile \
				README \
										$(DIST_DIR)
	tar czvf $(DIST_DIR).tar.gz $(DIST_DIR)
	rm -rf $(DIST_DIR)