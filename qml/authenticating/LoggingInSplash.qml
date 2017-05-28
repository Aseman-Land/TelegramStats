import QtQuick 2.0
import AsemanTools 1.1
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0
import "../authenticating" as Auth
import "../globals"

Rectangle {
    color: TgChartsGlobals.masterColor

    property alias busy: indicator.running

    NullMouseArea { anchors.fill: parent }

    Column {
        anchors.centerIn: parent
        spacing: 10*Devices.density

        Image {
            anchors.horizontalCenter: parent.horizontalCenter
            width: 128*Devices.density
            height: width
            sourceSize: Qt.size(2*width, 2*height)
            cache: false
            source: "../files/icon2.png"
        }

        BusyIndicator {
            id: indicator
            anchors.horizontalCenter: parent.horizontalCenter
            height: 48*Devices.density
            width: height
            running: false
            transformOrigin: Item.Center
            Material.accent: "#ffffff"
        }
    }
}
