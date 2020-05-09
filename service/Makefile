NAME = themes-switcher
SERVICE_NAME = $(NAME)-service

CC = cc
OBJ = $(SERVICE_NAME).o $(NAME).o
CFLAGS = `pkg-config --cflags gio-2.0 gio-unix-2.0 dbus-1 dbus-glib-1`
LIBS = `pkg-config --libs gio-2.0 gio-unix-2.0 dbus-1 dbus-glib-1`

INTERFACE_PREFIX = com.github.trifonovkv
XML = $(INTERFACE_PREFIX).$(NAME).xml

$(SERVICE_NAME) : $(OBJ)
	$(CC) -o $@ $(OBJ) $(CFLAGS) $(LIBS)

$(SERVICE_NAME).o : $(SERVICE_NAME).c $(NAME).h
	$(CC) -c $(CFLAGS) $^

$(NAME).o : $(NAME).c $(NAME).h
	$(CC) -c $(CFLAGS) $^

$(NAME).c $(NAME).h : $(XML)
	gdbus-codegen --interface-prefix $(INTERFACE_PREFIX) --generate-c-code $(NAME) $^

.PHONY : clean
clean :
	rm $(SERVICE_NAME) $(OBJ) $(NAME).{c,h,h.gch} 