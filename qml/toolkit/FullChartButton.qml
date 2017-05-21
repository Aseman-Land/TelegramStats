import QtQuick 2.0
import AsemanTools 1.1
import AsemanTools.Awesome 1.0
import QtQuick.Controls 2.1 as QtControls
import QtQuick.Controls.Material 2.1
import "../globals"
import "../charts" as Charts

Item {
    id: fchartBtn
    height: 80*Devices.density

    property variant dataMap
    property alias refreshing: indicator.running

    Item {
        id: scene
        anchors.fill: parent

        Rectangle {
            anchors.fill: parent
            anchors.topMargin: 4*Devices.density
            anchors.bottomMargin: 4*Devices.density
            anchors.margins: 8*Devices.density
            radius: 5*Devices.density
            color: Material.color(Material.Teal)

            QtControls.Label {
                anchors.centerIn: parent
                text: qsTr("Compare all actived chats")
                font.pixelSize: 11*Devices.fontDensity
                color: "#ffffff"
                visible: !indicator.running
            }

            QtControls.ItemDelegate {
                anchors.fill: parent
                hoverEnabled: false
                onClicked: {
                    if(indicator.running)
                        return
                    var dlg = selector_component.createObject(fchartBtn)
                    dlg.open()
                }
            }

            QtControls.BusyIndicator {
                id: indicator
                anchors.centerIn: parent
                height: 64*Devices.density
                width: height
                transformOrigin: Item.Center
                scale: 0.5
                Material.accent: "#ffffff"
            }
        }
    }

    Component {
        id: selector_component
        QtControls.Dialog {
            id: dialog
            title: qsTr("Your top actived chats")
            standardButtons: QtControls.Dialog.Cancel
            contentHeight: callChart.height
            contentWidth: callChart.width
            x: parent.width/2 - width/2
            y: 0
            modal: true
            dim: true
            closePolicy: QtControls.Popup.CloseOnPressOutside
            leftPadding: 0
            topPadding: 0
            rightPadding: 0
            bottomPadding: 0

            onVisibleChanged: {
                if(visible)
                    BackHandler.pushHandler(this, function(){visible = false})
                else {
                    BackHandler.removeHandler(this)
                    Tools.jsDelayCall(400, dialog.destroy)
                }
            }

            Charts.CompareAllChart {
                id: callChart
                width: fchartBtn.width - 20*Devices.density
                height: width*4/5
                dataMap: fchartBtn.dataMap
            }

            onRejected: close()
        }
    }
}
