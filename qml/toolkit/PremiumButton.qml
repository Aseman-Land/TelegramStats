import QtQuick 2.0
import AsemanTools 1.1
import AsemanTools.Awesome 1.0
import QtQuick.Controls 2.0 as QtControls
import QtQuick.Controls.Material 2.1
import "../globals"

Item {
    height: 120*Devices.density

    Item {
        id: scene
        anchors.fill: parent

        Rectangle {
            anchors.fill: parent
            anchors.bottomMargin: 4*Devices.density
            anchors.margins: 8*Devices.density
            radius: 5*Devices.density
            color: Material.color(Material.Orange)

            Column {
                anchors.centerIn: parent
                spacing: 4*Devices.density

                QtControls.Label {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: qsTr("Active Premium")
                    font.pixelSize: 12*Devices.fontDensity
                    color: "#ffffff"
                }

                QtControls.Label {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: qsTr("You can active premium free or payment")
                    font.pixelSize: 9*Devices.fontDensity
                    color: "#ffffff"
                }
            }

            QtControls.ItemDelegate {
                anchors.fill: parent
                hoverEnabled: false
            }
        }
    }
}
