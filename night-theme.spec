Name:           night-theme
Version:        0.1
Release:        1%{?dist}
Summary:        This app switch GNOME theme between dark and light by day time.

License:        GPL-3
Source0:        %{_sourcedir}/%{name}-%{version}.tar.gz

BuildRequires:  make gcc
Requires:       gnome-desktop3

%description   


%prep
%autosetup

%build
make prefix=/usr


%install
rm -rf $RPM_BUILD_ROOT
%{__make} install DESTDIR=%{?buildroot} prefix=/usr

%post
glib-compile-schemas /usr/share/glib-2.0/schemas 2> /dev/null

%files
%license LICENSE
/usr/bin/nts.sh
/usr/bin/themes-switcher-service
/usr/bin/night-theme-settings/NightThemeSettings.glade
/usr/bin/night-theme-settings/NightThemeSettings.js
/usr/share/dbus-1/services/com.github.trifonovkv.themes-switcher.service
/usr/share/glib-2.0/schemas/com.github.trifonovkv.themes-switcher.gschema.xml


%changelog
* Wed May 13 2020 Konstantin Trifonov <trifonovkv@gmail.com>
- 