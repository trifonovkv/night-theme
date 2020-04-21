const Gio = imports.gi.Gio
const Mainloop = imports.mainloop

const BUS_NAME = 'org.gnome.SettingsDaemon.Color'
const OBJECT_PATH = '/org/gnome/SettingsDaemon/Color'

const ColorInterface = '<node> \
<interface name="org.gnome.SettingsDaemon.Color"> \
  <property name="NightLightActive" type="b" access="read"/> \
</interface> \
</node>'

var _colorProxy = Gio.DBusProxy.makeProxyWrapper(ColorInterface)

_colorProxy(Gio.DBus.session, BUS_NAME, OBJECT_PATH, (proxy, error) => {
    if (error) {
      log(error.message)
      return
    }

    proxy.connect('g-properties-changed', () => updateView(proxy.NightLightActive))

  })

  var updateView = isActive => log(`NightLightActive: ${isActive}`)

  Mainloop.run()