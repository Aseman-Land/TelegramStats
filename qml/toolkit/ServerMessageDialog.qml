import QtQuick 2.0
import AsemanTools 1.1
import AsemanTools.Awesome 1.0
import QtQuick.Controls 2.1 as QtControls
import "../globals"

Item {
    id: serverMsgDialog

    property variant dialog
    property string message
    property bool fatal: false

    function open(msg, fatal) {
        serverMsgDialog.message = msg
        serverMsgDialog.fatal = fatal

        if(!dialog)
            dialog = dialog_component.createObject(serverMsgDialog)

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
            title: qsTr("Server message")
            contentHeight: label.height
            contentWidth: label.width
            x: parent.width/2 - width/2
            y: parent.height/2 - height/2
            modal: true
            dim: true
            closePolicy: QtControls.Popup.CloseOnPressOutside
            standardButtons: QtControls.Dialog.Ok

            onVisibleChanged: {
                if(visible)
                    BackHandler.pushHandler(this, function(){visible = false})
                else {
                    BackHandler.removeHandler(this)
                    Tools.jsDelayCall(400, dialog.destroy)
                    if(serverMsgDialog.fatal)
                        AsemanApp.exit(0)
                }
            }

            QtControls.Label {
                id: label
                font.pixelSize: 9*Devices.fontDensity
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                width: {
                    var res = serverMsgDialog.width - 80*Devices.density
                    if(res > 500*Devices.density)
                        res = 500*Devices.density
                    return res
                }
                text: serverMsgDialog.message
            }
        }
    }
}
