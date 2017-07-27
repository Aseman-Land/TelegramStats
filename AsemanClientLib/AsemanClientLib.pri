CONFIG += c++11
QT += network gui qml

INCLUDEPATH += $$PWD

SOURCES += \
    $$PWD/asemanabstractagentclient.cpp \
    $$PWD/asemanabstractclientsocket.cpp

HEADERS +=\
    $$PWD/asemanclientlib_global.h \
    $$PWD/asemanabstractagentclient.h \
    $$PWD/asemanabstractclientsocket.h
    $$PWD/asemantools.h

exists($$PWD/asemanclientsocket.cpp) {
    DEFINES += ASEMAN_FALCON_SERVER
    include(../AsemanGlobals/AsemanGlobals.pri)

    HEADERS += $$PWD/asemanclientsocket.h \
        $$PWD/asemantrustsolverengine.h
    SOURCES += $$PWD/asemanclientsocket.cpp \
        $$PWD/asemantrustsolverengine.cpp
}
