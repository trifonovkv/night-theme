.PHONY : clean install

NAME = themes-switcher
SERVICE_NAME = $(NAME)-service
INTERFACE_PREFIX = com.github.trifonovkv
INTERFACE = $(INTERFACE_PREFIX).$(NAME)
SERVICE_FILE = $(INTERFACE).service
XML = $(INTERFACE).xml
DBUS_SERVICE_NAME = $(INTERFACE_PREFIX).ThemesSwitcher
OBJECT_PATH = /com/github/trifonovkv/ThemesSwitcher

CC = cc
OBJ = $(SERVICE_NAME).o $(NAME).o
CFLAGS = `pkg-config --cflags gio-2.0 gio-unix-2.0 dbus-1 dbus-glib-1`
LIBS = `pkg-config --libs gio-2.0 gio-unix-2.0 dbus-1 dbus-glib-1`

all : $(SERVICE_NAME) $(SERVICE_FILE)

$(SERVICE_NAME) : $(OBJ)
	$(CC) -o $@ $(OBJ) $(CFLAGS) $(LIBS)

$(SERVICE_NAME).o : $(SERVICE_NAME).c $(NAME).h
	$(CC) -c $(CFLAGS) $^

$(NAME).o : $(NAME).c $(NAME).h
	$(CC) -c $(CFLAGS) $^

$(NAME).c $(NAME).h : $(XML)
	gdbus-codegen --interface-prefix $(INTERFACE_PREFIX) --generate-c-code $(NAME) $^

$(SERVICE_FILE) :
	echo [D-BUS Service] > $@
	echo Name=$(DBUS_SERVICE_NAME) >> $@
	echo Exec=$(bindir)/$(SERVICE_NAME) >> $@

install : 
	$(INSTALL) $(SERVICE_NAME) $(bindir)/$(SERVICE_NAME)
	$(INSTALL) $(SERVICE_FILE) /usr/share/dbus-1/services/

start :
	gdbus call --session \
                        --dest $(DBUS_SERVICE_NAME) \
                        --object-path $(OBJECT_PATH) \
                        --method org.freedesktop.DBus.Peer.Ping

clean :
	rm -f $(SERVICE_NAME) $(OBJ) $(NAME).{c,h,h.gch} $(SERVICE_FILE)