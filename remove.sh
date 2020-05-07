#!/bin/sh

# remove schema
sudo rm /usr/share/glib-2.0/schemas/com.github.trifonovkv.themes-switcher.gschema.xml
sudo glib-compile-schemas /usr/share/glib-2.0/schemas 2> /dev/null

# remove service
sudo kill -9 `pidof /usr/bin/themes-switcher-service`
sudo rm /usr/bin/themes-switcher-service
sudo rm /usr/share/dbus-1/services/com.github.trifonovkv.ThemesSwitcher.service

# remove night theme settings
sudo rm -rf /usr/bin/night-theme-settings
sudo rm /usr/bin/nts.sh