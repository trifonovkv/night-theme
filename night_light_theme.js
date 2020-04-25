const Gio = imports.gi.Gio
const GLib = imports.gi.GLib
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


// fs utils
var getDirectoryContents = (path) => {
    var dirs = []
    try {
        var fileEnumerator = Gio.file_new_for_path(path).enumerate_children(
            '',
            Gio.FileQueryInfoFlags.NONE,
            null
        )
        var fileInfo = fileEnumerator.next_file(null)
        while (fileInfo !== null) {
            dirs.push(fileInfo.get_name())
            fileInfo = fileEnumerator.next_file(null)
        }
    }
    catch (error) {
        log(error)
    }
    return dirs
}

var getDataDirs = () => {
    var dataDirs = GLib.get_system_data_dirs()
    dataDirs.push(GLib.get_user_data_dir())
    return dataDirs
}

var findDirsByName = (paths, name) => {
    var dirs = []
    paths.forEach(path => {
        var dir = GLib.build_pathv(GLib.DIR_SEPARATOR_S, [path, name])
        if (GLib.file_test(dir, GLib.FileTest.IS_DIR)) {
            dirs.push(dir)
        }
    });
    return dirs
}

// themes
var isThemeDir = (path) => {
    var cssFile = GLib.build_pathv(GLib.DIR_SEPARATOR_S, [path, 'gtk-3.0', 'gtk.css'])
    if (GLib.file_test(cssFile, GLib.FileTest.EXISTS)) {
        return true
    }
    else {
        return false
    }
}

var getThemesDirs = (resourceDirs) => {
    var themesDirs = []
    resourceDirs.forEach(resourceDir => {
        getDirectoryContents(resourceDir).forEach(themeDir => {
            themesDirs.push(GLib.build_pathv(GLib.DIR_SEPARATOR_S, [resourceDir, themeDir]))
        })
    })
    return themesDirs
}

var getValidThemes = (themesDirs) => {
    var validThemes = []
    themesDirs.forEach(themeDir => {
        if (isThemeDir(themeDir)) {
            validThemes.push(GLib.path_get_basename(themeDir))
        }
    })
    return validThemes
}

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


// tests
log('   fs utils test')
getDirectoryContents('/').forEach(entry => log(entry))
getDataDirs().forEach(dataDir => log(dataDir))
findDirsByName(getDataDirs(), 'themes').forEach(resourceDir => log(resourceDir))

log('   themes tests')
getValidThemes(getThemesDirs(findDirsByName(getDataDirs(), 'themes'))).forEach(theme => log(theme))


Mainloop.run()