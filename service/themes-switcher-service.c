#include <dbus/dbus.h>
#include <dbus/dbus-glib.h>

#include "themes-switcher.h"

const gchar *THEMES_SWITCHER_SCHEMA_ID = "com.github.trifonovkv.themes-switcher";
const gchar *DESKTOP_INTERFACE_SCHEMA_ID = "org.gnome.desktop.interface";

static void
switch_theme(gboolean is_night)
{
  gchar *key;
  gchar *theme_name;
  GSettings *themes_switcher_settings;
  GSettings *desktop_interface_settings;

  themes_switcher_settings = g_settings_new(THEMES_SWITCHER_SCHEMA_ID);
  desktop_interface_settings = g_settings_new(DESKTOP_INTERFACE_SCHEMA_ID);

  key = is_night ? "night-theme" : "day-theme";
  theme_name = g_settings_get_string(themes_switcher_settings, key);
  g_settings_set_string(desktop_interface_settings, "gtk-theme", theme_name);

  g_free(theme_name);
}

static void
on_properties_changed(GDBusProxy *proxy,
                      GVariant *changed_properties,
                      const gchar *const *invalidated_properties,
                      gpointer user_data)
{
  if (g_variant_n_children(changed_properties) > 0)
  {
    GVariantIter *iter;
    const gchar *key;
    GVariant *value;

    g_variant_get(changed_properties, "a{sv}", &iter);
    while (g_variant_iter_loop(iter, "{&sv}", &key, &value))
    {
      if (g_strcmp0(key, "NightLightActive") == 0)
      {
        gboolean value_boolean;
        value_boolean = g_variant_get_boolean(value);
        switch_theme(value_boolean);
      }
    }
    g_variant_iter_free(iter);
  }
}

static void
on_name_acquired(GDBusConnection *connection,
                 const gchar *name,
                 gpointer user_data)
{
  ThemesSwitcher *skeleton;

  skeleton = themes_switcher_skeleton_new();
  g_dbus_interface_skeleton_export(G_DBUS_INTERFACE_SKELETON(skeleton),
                                   connection,
                                   "/com/github/trifonovkv/ThemesSwitcher",
                                   NULL);
}

void main(void)
{
  GDBusConnection *connection;
  GError *error = NULL;
  GDBusProxy *proxy;

  g_bus_own_name(G_BUS_TYPE_SESSION,
                 "com.github.trifonovkv.ThemesSwitcher",
                 G_BUS_NAME_OWNER_FLAGS_NONE,
                 NULL,
                 on_name_acquired,
                 NULL,
                 NULL,
                 NULL);

  connection = g_bus_get_sync(G_BUS_TYPE_SESSION, NULL, &error);
  if (!connection)
  {
    g_printerr("Error: %s\n", error->message);
    g_error_free(error);
    return;
  }

  proxy = g_dbus_proxy_new_sync(connection,
                                G_DBUS_PROXY_FLAGS_NONE,
                                NULL,
                                "org.gnome.SettingsDaemon.Color",
                                "/org/gnome/SettingsDaemon/Color",
                                "org.gnome.SettingsDaemon.Color",
                                NULL,
                                &error);

  if (proxy == NULL)
  {
    g_printerr("Error creating proxy: %s\n", error->message);
    g_error_free(error);
    return;
  }

  g_signal_connect(proxy,
                   "g-properties-changed",
                   G_CALLBACK(on_properties_changed),
                   NULL);

  g_main_loop_run(g_main_loop_new(NULL, FALSE));
}