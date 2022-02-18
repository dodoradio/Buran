TEMPLATE = subdirs
QT += qml quick

CONFIG += starship

SUBDIRS = harbour-starship 
include(version.pri)

DISTFILES += \
