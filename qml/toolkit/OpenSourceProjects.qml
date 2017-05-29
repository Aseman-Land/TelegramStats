import QtQuick 2.0
import AsemanTools 1.0
import QtQuick.Controls 2.0 as QtControls
import "../globals"

Item {

    AsemanListView {
        id: listv
        anchors.fill: parent
        clip: true
        focus: true
        header: Item {
            width: listv.width
            height: descLabel.height + 20*Devices.density

            QtControls.Label {
                id: descLabel
                width: parent.width - 20*Devices.density
                anchors.centerIn: parent
                font.pixelSize: 9*Devices.fontDensity
                text: qsTr("List of other opensource projects used in Telegram Stats.")
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            }
        }

        model: ListModel {}
        delegate: Item {
            id: item
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 10*Devices.density
            height: column.height + 40*Devices.density

            Column {
                id: column
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.margins: 10*Devices.density
                spacing: 3*Devices.density

                Item {
                    id: title_item
                    height: title_txt.height
                    width: column.width

                    QtControls.Label {
                        id: title_txt
                        font.pixelSize: 14*Devices.fontDensity
                        anchors.left: parent.left
                        text: title
                    }

                    QtControls.Label {
                        id: license_txt
                        font.pixelSize: 10*Devices.fontDensity
                        anchors.right: parent.right
                        anchors.bottom: parent.bottom
                        opacity: 0.7
                        text: license
                    }
                }

                QtControls.Label {
                    id: description_txt
                    font.pixelSize: 9*Devices.fontDensity
                    width: parent.width
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    opacity: 0.8
                    text: description
                }

                QtControls.Label {
                    id: link_txt
                    font.pixelSize: 9*Devices.fontDensity
                    width: parent.width
                    wrapMode: Text.WrapAnywhere
                    maximumLineCount: 1
                    elide: Text.ElideRight
                    color: TgChartsGlobals.masterColor
                    text: link

                    MouseArea {
                        anchors.fill: parent
                        onClicked: Qt.openUrlExternally(link_txt.text)
                    }
                }
            }
        }

        Component.onCompleted: {
            model.clear()

            model.append({"title": "libqtelegram-ae", "license": "GNU GPL v3", "link": "https://github.com/Aseman-Land/libqtelegram-aseman-edition", "description": "Most powerfull telegram library. It created using C++/Qt and supports both client and bots API. It's free and opensource and released under the GPLv3 license"})
            model.append({"title": "TelegramQml", "license": "GNU GPL v3", "link": "https://github.com/Aseman-Land/TelegramQML", "description": "Telegram API tools for QtQml and Qml. It's based on Cutegram-Core and libqtelegram."})
            model.append({"title": "OpenSSL", "license": "	Apache", "link": "https://www.openssl.org/", "description": "The OpenSSL Project is a collaborative effort to develop a robust, commercial-grade, full-featured, and Open Source toolkit implementing the Transport Layer Security (TLS) and Secure Sockets Layer (SSL) protocols as well as a full-strength general purpose cryptography library."})
            model.append({"title": "Qt Framework " + Tools.qtVersion(), "license": "GNU GPL v3", "link": "http://qt.io", "description": "Qt is a cross-platform application and UI framework for developers using C++ or QML, a CSS & JavaScript like language."})
            model.append({"title": "Aseman Qt Tools", "license": "GNU GPL v3", "link": "https://github.com/aseman-labs/aseman-qt-tools", "description": "Some tools, creating for Aseman Qt projects and used on many of Aseman's projects"})
            model.append({"title": "Twitter Emoji (Twemoji)", "license": "MIT", "link": "https://github.com/twitter/twemoji", "description": "A simple library that provides standard Unicode emoji support across all platforms."})

            focus = true
        }
    }

    ScrollBar {
        scrollArea: listv; height: listv.height; anchors.right: listv.right; anchors.top: listv.top
        color: TgChartsGlobals.masterColor
        LayoutMirroring.enabled: View.reverseLayout
    }
}
