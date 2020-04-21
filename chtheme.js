const Gio = imports.gi.Gio

const SCHEMA = 'org.gnome.desktop.interface'

var _schema = new Gio.Settings({ schema: SCHEMA })
_schema.set_string('gtk-theme', 'Adwaita')