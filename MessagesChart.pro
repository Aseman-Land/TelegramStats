TEMPLATE = app

INCLUDEPATH += \
    telegram/libqtelegram/ \
    telegram/telegramqml/

QT += qml quick widgets sql
CONFIG += c++11
CONFIG += typeobjects
DEFINES += DISABLE_KEYCHAIN

android {
    ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android
}

include(asemantools/asemantools.pri)
include(telegram/libqtelegram/libqtelegram-ae.pri)
include(telegram/telegramqml/telegramqml.pri)

HEADERS += \
    components/tgchartengine.h \
    components/tgabstractchartitem.h \
    components/tgtimediarychart.h \
    components/tgchartsenderratiochart.h \
    components/tgdailytimechart.h \
    components/tgfiletypechart.h \
    components/tgchartsemojisdiary.h

SOURCES += main.cpp \
    components/tgchartengine.cpp \
    components/tgabstractchartitem.cpp \
    components/tgtimediarychart.cpp \
    components/tgchartsenderratiochart.cpp \
    components/tgdailytimechart.cpp \
    components/tgfiletypechart.cpp \
    components/tgchartsemojisdiary.cpp

RESOURCES += qml/qml.qrc \
    resource.qrc \
    qml/emojis/emojis.qrc

# The following define makes your compiler emit warnings if you use
# any feature of Qt which as been marked deprecated (the exact warnings
# depend on your compiler). Please consult the documentation of the
# deprecated API in order to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

contains(ANDROID_TARGET_ARCH,armeabi-v7a) {
    ANDROID_EXTRA_LIBS = \
        $$PWD/libs/libcrypto.so \
        $$PWD/libs/libssl.so
}
