import QtQuick 2.0
import AsemanTools 1.1
import AsemanTools.Awesome 1.0
import QtQuick.Controls 2.0 as QtControls
import QtQuick.Controls.Material 2.1
import "../globals"

Item {
    id: premiumBtn
    height: scene.height

    signal clicked()

    Item {
        id: scene
        width: parent.width
        height: activeButtonRect.height

        QtControls.Button {
            id: activeButtonRect
            y: 8*Devices.density
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width - 2*y
            height: {
                var res = activeButtonColumn.height + 20*Devices.density
                if(res < 120*Devices.density)
                    res = 120*Devices.density
                return res
            }
            Material.accent: Material.color(Material.Orange)
            hoverEnabled: false
            highlighted: true

            onClicked: premiumBtn.clicked()

            Column {
                id: activeButtonColumn
                anchors.centerIn: parent
                width: parent.width - 20*Devices.density
                spacing: 4*Devices.density

                QtControls.Label {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: qsTr("Active Premium") + TgChartsGlobals.translator.refresher
                    font.pixelSize: 12*Devices.fontDensity
                    color: "#ffffff"
                }

                QtControls.Label {
                    text: qsTr("You can active premium free or payment") + TgChartsGlobals.translator.refresher
                    width: parent.width
                    horizontalAlignment: Text.AlignHCenter
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    font.pixelSize: 9*Devices.fontDensity
                    color: "#ffffff"
                }
            }
        }
    }
}
