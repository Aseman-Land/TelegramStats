import QtQuick 2.0
import AsemanTools 1.1
import AsemanTools.Awesome 1.0
import QtQuick.Controls 2.1 as QtControls
import "../globals"

Item {
    id: premiumReqDialog

    property variant dialog

    function open() {
        if(!dialog)
            dialog = dialog_component.createObject(premiumReqDialog)

        dialog.open()
    }

    function close() {
        if(dialog)
            dialog.destroy()
    }

    Component {
        id: dialog_component
        QtControls.Dialog {
            id: dialog
            title: qsTr("Active Premium")
            contentHeight: label.height
            contentWidth: label.width
            x: parent.width/2 - width/2
            y: parent.height/2 - height/2
            modal: true
            dim: true
            closePolicy: QtControls.Popup.CloseOnPressOutside

            onVisibleChanged: {
                if(visible)
                    BackHandler.pushHandler(this, function(){visible = false})
                else {
                    BackHandler.removeHandler(this)
                    Tools.jsDelayCall(400, dialog.destroy)
                }
            }

            footer: QtControls.DialogButtonBox {
                QtControls.Button {
                    text: qsTr("Active")
                    flat: true
                    onClicked: {
                        TgChartsStore.activePremium()
                        dialog.close()
                    }
                }
                QtControls.Button {
                    text: qsTr("Cancel")
                    flat: true
                    onClicked: dialog.close()
                }
            }

            QtControls.Label {
                id: label
                font.pixelSize: 9*Devices.fontDensity
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                width: {
                    var res = premiumReqDialog.width - 80*Devices.density
                    if(res > 500*Devices.density)
                        res = 500*Devices.density
                    return res
                }
                text: qsTr("This feature needs premium account. Do you want to active it?")
            }
        }
    }
}
