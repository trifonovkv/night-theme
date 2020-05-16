.PHONY : clean install

CFLAGS = `pkg-config --cflags gio-2.0 gio-unix-2.0 dbus-1 dbus-glib-1`
LDLIBS = `pkg-config --libs gio-2.0 gio-unix-2.0 dbus-1 dbus-glib-1`

PROGRAM_NAME = themes-switcher-service
OBJS = $(addprefix $(BUILDDIR)/,themes-switcher.o themes-switcher-service.o)
PROGRAM = $(addprefix $(BUILDDIR)/,$(PROGRAM_NAME))
DBUS_SERVICE = $(addprefix $(BUILDDIR)/,com.github.trifonovkv.themes-switcher.service)
PROGRAM_TARGET = $(BINDIR)/$(PROGRAM_NAME)
DBUS_SERVICE_TARGET = $(DESTDIR)/usr/share/dbus-1/services/com.github.trifonovkv.themes-switcher.service

$(BUILDDIR)/%.o : %.c
	$(COMPILE.c) -g $(OUTPUT_OPTION) $<

all : $(PROGRAM) $(DBUS_SERVICE)

$(OBJS): | $(BUILDDIR)

$(BUILDDIR):
	mkdir $(BUILDDIR)

$(PROGRAM) : $(OBJS)
	$(LINK.o) $^ $(LDLIBS) -o $@

install : 
	$(INSTALL) $(PROGRAM) $(PROGRAM_TARGET)
	$(INSTALL_DATA) $(DBUS_SERVICE) $(DBUS_SERVICE_TARGET)

uninstall :
	rm -f $(PROGRAM_TARGET)
	rm -f $(DBUS_SERVICE_TARGET)

$(DBUS_SERVICE) :
	echo [D-BUS Service] > $@
	echo Name=$(DBUS_SERVICE_NAME) >> $@
	echo Exec=$(PROGRAM_TARGET) >> $@