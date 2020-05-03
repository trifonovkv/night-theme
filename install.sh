#!/bin/sh
gdbus-codegen --interface-prefix com.github.trifonovkv --generate-c-code themes-switcher com.github.trifonovkv.themes-switcher.xml

gcc -o themes-switcher-service themes-switcher-service.c \
                                themes-switcher.h \
                                themes-switcher.c \
                                `pkg-config --cflags --libs gio-2.0 gio-unix-2.0 dbus-1 dbus-glib-1`

sudo kill -9 `pidof /usr/bin/themes-switcher-service`
sudo mv themes-switcher-service /usr/bin/
sudo cp com.github.trifonovkv.ThemesSwitcher.service /usr/share/dbus-1/services/

gdbus call --session \
                        --dest com.github.trifonovkv.ThemesSwitcher \
                        --object-path /com/github/trifonovkv/ThemesSwitcher \
                        --method org.freedesktop.DBus.Peer.Ping