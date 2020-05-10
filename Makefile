export INSTALL = /usr/bin/install
export prefix = /usr/local
export bindir = $(prefix)/bin

TOPTARGETS := all install clean

SUBDIRS := $(wildcard */.)

$(TOPTARGETS): $(SUBDIRS)

$(SUBDIRS):
	$(MAKE) -C $@ $(MAKECMDGOALS)

.PHONY: $(TOPTARGETS) $(SUBDIRS)

start :
	$(MAKE) -C ./service start