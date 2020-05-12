export prefix = /usr/local
export DESTDIR =
export BINDIR = $(DESTDIR)$(prefix)/bin
export BUILDDIR = $(CURDIR)/build
export INSTALL = /usr/bin/install -c
export INSTALL_DATA = /usr/bin/install -c -m 644

TOPTARGETS := all install uninstall

SUBDIRS = schemas service settings

$(TOPTARGETS) : $(SUBDIRS)

$(SUBDIRS) :
	$(MAKE) -C $@ $(MAKECMDGOALS)

.PHONY : $(TOPTARGETS) $(SUBDIRS)

start :
	$(MAKE) -C ./service start

clean :
	rm -rf $(BUILDDIR)