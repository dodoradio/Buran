Name:       asteroidsyncservice

%{!?qtc_qmake:%define qtc_qmake %qmake}
%{!?qtc_qmake5:%define qtc_qmake5 %qmake5}
%{!?qtc_make:%define qtc_make make}
%{?qtc_builddir:%define _builddir %qtc_builddir}
Summary:    Daemon keeping AsteroidOS watches synchronized with SailfishOS
Version:    1.0
Release:    1
Group:      Qt/Qt
License:    GPL3
URL:        http://asteroidos.org/
Source0:    %{name}-%{version}.tar.xz
Requires:   systemd-user-session-targets
Requires:   nemo-qml-plugin-dbus-qt5
BuildRequires:  pkgconfig(Qt5DBus)
BuildRequires:  pkgconfig(Qt5Bluetooth)
BuildRequires:  pkgconfig(Qt5Qml)
BuildRequires:  pkgconfig(Qt5Core)
BuildRequires:  pkgconfig(Qt5Network)
BuildRequires:  pkgconfig(qt5-boostable)
BuildRequires:  pkgconfig(mpris-qt5)
BuildRequires:  pkgconfig(timed-qt5)
BuildRequires:  desktop-file-utils

%description
Support for AsteroidOS watches in SailfishOS.

%prep
%setup -q -n %{name}-%{version}

%build

%qtc_qmake5  \
    VERSION='%{version}-%{release}'

%qtc_make %{?_smp_mflags}

%install
rm -rf %{buildroot}
%qmake5_install

mkdir -p %{buildroot}%{_userunitdir}/user-session.target.wants
ln -s ../asteroidsyncserviced.service %{buildroot}%{_userunitdir}/user-session.target.wants/

%post
echo "/usr/bin/asteroidsyncserviced,cehlmnpu" > /usr/share/mapplauncherd/privileges.d/harbour-asteroidsyncserviced.privileges
systemctl-user daemon-reload
systemctl-user try-restart asteroidsyncserviced.service

%files
%defattr(-,root,root,-)
%{_bindir}
%{_userunitdir}/%{name}d.service
%{_userunitdir}/user-session.target.wants/%{name}d.service
%{_libdir}/qt5/qml/org/asteroid/syncservice
