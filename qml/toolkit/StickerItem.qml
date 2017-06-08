import QtQuick 2.0
import AsemanTools 1.1
import AsemanTools.Awesome 1.0
import QtQuick.Controls 2.1 as QtControls
import "../globals"

Item {
    id: stickeritem
    height: width/ratio

    readonly property real ratio: 1080/380
    readonly property bool isNull: img.source == ""

    Image {
        id: img
        anchors.fill: parent
        sourceSize: Qt.size(width*2, height*2)
        cache: false
    }

    Rectangle {
        anchors.fill: parent
        anchors.margins: 8*Devices.density
        border.width: 2*Devices.density
        border.color: TgChartsGlobals.masterColor
        radius: 5*Devices.density
        color: "#00000000"
        opacity: 0.4
        visible: isNull

        Column {
            anchors.centerIn: parent
            spacing: 8*Devices.density

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                font.family: Awesome.family
                font.pixelSize: 30*Devices.fontDensity
                text: Awesome.fa_plus
                color: TgChartsGlobals.masterColor
            }

            QtControls.Label {
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: 10*Devices.fontDensity
                text: qsTr("Select a sticker")
                color: TgChartsGlobals.masterColor
            }
        }
    }

    QtControls.ItemDelegate {
        anchors.fill: parent
        hoverEnabled: false
        onClicked: dialog.open()
    }

    QtControls.Dialog {
        id: dialog
        title: qsTr("Select Sticker")
        standardButtons: QtControls.Dialog.Cancel
        contentHeight: listv.height
        contentWidth: listv.width
        x: parent.width/2 - width/2
        modal: true
        dim: true
        closePolicy: QtControls.Popup.CloseOnPressOutside

        onVisibleChanged: {
            if(visible)
                BackHandler.pushHandler(this, function(){visible = false})
            else
                BackHandler.removeHandler(this)
        }

        AsemanListView {
            id: listv
            width: {
                var res = stickeritem.width - 60*Devices.density
                if(res > 500*Devices.density)
                    res = 500*Devices.density
                return res
            }
            height: View.root.height/2
            model: Tools.filesOf(":/toolkit/stickers/")
            clip: true
            header: Item {
                width: listv.width
                height: width/stickeritem.ratio

                Rectangle {
                    anchors.fill: parent
                    anchors.margins: 8*Devices.density
                    border.width: 2*Devices.density
                    border.color: TgChartsGlobals.masterColor
                    radius: 5*Devices.density
                    color: "#00000000"
                    opacity: 0.5

                    QtControls.Label {
                        anchors.centerIn: parent
                        font.pixelSize: 11*Devices.fontDensity
                        text: qsTr("Null")
                        color: TgChartsGlobals.masterColor
                    }
                }

                QtControls.ItemDelegate {
                    anchors.fill: parent
                    hoverEnabled: false
                    onClicked: {
                        img.source = ""
                        dialog.close()
                    }
                }
            }

            delegate: Item {
                width: listv.width
                height: width/stickeritem.ratio

                Image {
                    anchors.fill: parent
                    source: "stickers/" + listv.model[index]
                    asynchronous: true
                    sourceSize: Qt.size(1.2*width, 1.2*height)
                }

                QtControls.ItemDelegate {
                    anchors.fill: parent
                    hoverEnabled: false
                    onClicked: {
                        img.source = "stickers/" + listv.model[index]
                        dialog.close()
                    }
                }
            }
        }

        onRejected: close()
    }
}
