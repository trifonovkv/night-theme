#!/usr/bin/gjs

imports.gi.versions.Gtk = '3.0'

const { Gio, Gtk, GLib } = imports.gi

const ThemeSettings = new Gio.Settings({ schema: 'com.github.trifonovkv.themes-switcher' })

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

var getDataPath = () => {
    var dataPaths = GLib.get_system_data_dirs()
    dataPaths.push(GLib.get_user_data_dir())
    return dataPaths
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

// themes utils
var isThemeDir = (path) => {
    var cssFile = GLib.build_pathv(GLib.DIR_SEPARATOR_S, [path, 'gtk-3.0', 'gtk.css'])
    if (GLib.file_test(cssFile, GLib.FileTest.EXISTS)) {
        return true
    }
    else {
        return false
    }
}

var getThemesPaths = (dataPaths) => {
    var themesPaths = []
    findDirsByName(dataPaths, 'themes').forEach(themesPath => {
        getDirectoryContents(themesPath).forEach(dir => {
            themesPaths.push(GLib.build_pathv(GLib.DIR_SEPARATOR_S, [themesPath, dir]))
        })
    })
    return themesPaths
}

var getValidThemes = (paths) => {
    var validThemes = []
    paths.forEach(path => {
        if (isThemeDir(path)) {
            validThemes.push(GLib.path_get_basename(path))
        }
    })
    return validThemes
}

var getThemes = () => getValidThemes(getThemesPaths(getDataPath()))

class HelloWorld {
    constructor() {
        this.application = new Gtk.Application();
        this.application.connect('activate', this._onActivate.bind(this))
        this.application.connect('startup', this._onStartup.bind(this))
    }

    _onActivate() {
        this._window.show_all()
    }

    _onStartup() {
        let builder = new Gtk.Builder()
        builder.add_from_file('settings.glade')
        this._window = builder.get_object('window1')
        this.application.add_window(this._window)
        this.menuButton = builder.get_object('menuButton1')
        this._fillMenu(this.menuButton, getThemes())
    }

    _fillMenu(menuButton, list) {
        var menu = menuButton.popup
        menuButton.label = ThemeSettings.get_string('night-theme')
        list.forEach(string => {
            var item = new Gtk.MenuItem({ label: string, visible: true })
            item.connect('activate', (item) => {
                menuButton.label = item.label
                ThemeSettings.set_string('night-theme', item.label)
            })
            menu.append(item)
        })
    }
};

let app = new HelloWorld()
app.application.run(ARGV)