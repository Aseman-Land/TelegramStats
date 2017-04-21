import QtQuick 2.0
import AsemanTools 1.1
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0
import "../authenticating" as Auth
import "../globals"

Rectangle {
    color: TgChartsGlobals.masterColor

    property alias busy: indicator.running

    BusyIndicator {
        id: indicator
        anchors.centerIn: parent
        height: 64*Devices.density
        width: height
        running: false
        transformOrigin: Item.Center
        scale: 0.5
        Material.accent: "#ffffff"
    }
}
