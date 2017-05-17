TEMPLATE = app

INCLUDEPATH += \
    telegram/libqtelegram/ \
    telegram/telegramqml/

QT += qml quick widgets sql
CONFIG += c++11
CONFIG += typeobjects
DEFINES += DISABLE_KEYCHAIN

translationsFiles.source = translations
translationsFiles.target = .
DEPLOYMENTFOLDERS += translationsFiles

android {
    ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android
}

win32 {
    isEmpty(OPENSSL_LIB_DIR): OPENSSL_LIB_DIR = $${DESTDIR}
    isEmpty(OPENSSL_INCLUDE_PATH): OPENSSL_INCLUDE_PATH = $${DESTDIR}/include

    LIBS += -L$${OPENSSL_LIB_DIR} -lssleay32
    INCLUDEPATH += $${OPENSSL_INCLUDE_PATH}

    win32-msvc* {
        LIBS += -llibeay32 -lzlibstat -lUser32 -lAdvapi32 -lGdi32 -lWs2_32
    } else {
        LIBS += -lcrypto -lz
    }
} else {
    isEmpty(OPENSSL_INCLUDE_PATH): OPENSSL_INCLUDE_PATH = /usr/include/ /usr/local/include/
    isEmpty(OPENSSL_LIB_DIR) {
        LIBS += -lssl -lcrypto -lz
    } else {
        LIBS += -L$${OPENSSL_LIB_DIR} -lssl -lcrypto -lz
    }

    INCLUDEPATH += $${OPENSSL_INCLUDE_PATH}
}

LIBS += -lqtelegram-ae
INCLUDEPATH += $$[QT_INSTALL_HEADERS]/libqtelegram-ae

include(asemantools/asemantools.pri)
include(telegram/telegramqml/telegramqml.pri)
include(qmake/qtcAddDeployment.pri)
qtcAddDeployment()

HEADERS += \
    components/tgchartengine.h \
    components/tgabstractchartitem.h \
    components/tgtimediarychart.h \
    components/tgchartsenderratiochart.h \
    components/tgdailytimechart.h \
    components/tgfiletypechart.h \
    components/tgchartsemojisdiary.h \
    components/tgchartsmessagedetails.h \
    components/tgchartssensediary.h

SOURCES += main.cpp \
    components/tgchartengine.cpp \
    components/tgabstractchartitem.cpp \
    components/tgtimediarychart.cpp \
    components/tgchartsenderratiochart.cpp \
    components/tgdailytimechart.cpp \
    components/tgfiletypechart.cpp \
    components/tgchartsemojisdiary.cpp \
    components/tgchartsmessagedetails.cpp \
    components/tgchartssensediary.cpp

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
