#!/bin/sh

# build service
cd service
gdbus-codegen --interface-prefix com.github.trifonovkv \
    --generate-c-code themes-switcher com.github.trifonovkv.themes-switcher.xml

gcc -o themes-switcher-service themes-switcher-service.c \
          themes-switcher.h \
          themes-switcher.c \
          `pkg-config --cflags --libs gio-2.0 gio-unix-2.0 dbus-1 dbus-glib-1`