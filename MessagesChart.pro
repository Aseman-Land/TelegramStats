TEMPLATE = app

QT += qml quick widgets sql
CONFIG += c++11
DEFINES += DISABLE_KEYCHAIN

translationsFiles.source = translations
translationsFiles.target = .
DEPLOYMENTFOLDERS += translationsFiles

android {
    ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android
}

LIBS += -lqtelegram-ae
INCLUDEPATH += $$[QT_INSTALL_HEADERS]/libqtelegram-ae $$PWD/qtquick/

include(asemantools/asemantools.pri)
include(AsemanClientLib/AsemanClientLib.pri)
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
    components/tgchartssensediary.h \
    components/tgchartusermessagecounter.h \
    components/tgchartssensedailydiary.h \
    services/tgstats1.h

SOURCES += main.cpp \
    components/tgchartengine.cpp \
    components/tgabstractchartitem.cpp \
    components/tgtimediarychart.cpp \
    components/tgchartsenderratiochart.cpp \
    components/tgdailytimechart.cpp \
    components/tgfiletypechart.cpp \
    components/tgchartsemojisdiary.cpp \
    components/tgchartsmessagedetails.cpp \
    components/tgchartssensediary.cpp \
    components/tgchartusermessagecounter.cpp \
    components/tgchartssensedailydiary.cpp

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

DISTFILES += \
    android/AndroidManifest.xml

contains(ANDROID_TARGET_ARCH,armeabi-v7a) {
    exists($$PWD/libs/libcrypto.so): ANDROID_EXTRA_LIBS += $$PWD/libs/libcrypto.so
    exists($$PWD/libs/libssl.so): ANDROID_EXTRA_LIBS += $$PWD/libs/libssl.so
}
