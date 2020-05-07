#!/bin/sh

# install schema
sudo cp com.github.trifonovkv.themes-switcher.gschema.xml /usr/share/glib-2.0/schemas/
sudo glib-compile-schemas /usr/share/glib-2.0/schemas 2> /dev/null

# install service
sudo kill -9 `pidof /usr/bin/themes-switcher-service`
sudo cp ./service/themes-switcher-service /usr/bin/
sudo cp ./service/com.github.trifonovkv.ThemesSwitcher.service /usr/share/dbus-1/services/

# install night theme settings
sudo mkdir -p /usr/bin/night-theme-settings
sudo cp ./settings/NightThemeSettings.js /usr/bin/night-theme-settings/
sudo cp ./settings/NightThemeSettings.glade /usr/bin/night-theme-settings/
sudo cp ./settings/nts.sh /usr/bin/
sudo chmod +x /usr/bin/nts.sh

# start service
gdbus call --session \
                        --dest com.github.trifonovkv.ThemesSwitcher \
                        --object-path /com/github/trifonovkv/ThemesSwitcher \
                        --method org.freedesktop.DBus.Peer.Ping