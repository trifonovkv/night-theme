const Gio = imports.gi.Gio
const Mainloop = imports.mainloop

const BUS_NAME = 'org.gnome.SettingsDaemon.Color'
const OBJECT_PATH = '/org/gnome/SettingsDaemon/Color'

const Theme = {
    light: 'Adwaita',
    dark: 'Adwaita-dark'
}
const Settings = new Gio.Settings({ schema: 'org.gnome.desktop.interface' })
const ColorInterface = '<node> \
<interface name="org.gnome.SettingsDaemon.Color"> \
  <property name="NightLightActive" type="b" access="read"/> \
</interface> \
</node>'


var colorProxy = Gio.DBusProxy.makeProxyWrapper(ColorInterface)

colorProxy(Gio.DBus.session, BUS_NAME, OBJECT_PATH, (proxy, error) => {
    if (error) {
        log(error.message)
        return
    }

    proxy.connect(
        'g-properties-changed',
        () => {
            Settings.set_string('gtk-theme', proxy.NightLightActive ? Theme.dark : Theme.light)
        }
    )
})

Mainloop.run()