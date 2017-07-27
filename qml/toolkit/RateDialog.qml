/*
    Copyright (C) 2017 Aseman Team
    http://aseman.co

    TelegramStats is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    TelegramStats is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

import QtQuick 2.0
import AsemanTools 1.1
import AsemanTools.Awesome 1.0
import Qt.labs.controls 1.0 as QtControls
import "../globals"

Item {
    id: rateDialog

    property variant dialog

    function open() {
        if(!dialog)
            dialog = dialog_component.createObject(rateDialog)

        dialog.open()
    }

    function close() {
        if(dialog)
            dialog.destroy()
    }

//    Component {
//        id: dialog_component
//        QtControls.Dialog {
//            id: dialog
//            title: qsTr("Rate this app")
//            contentHeight: label.height
//            contentWidth: label.width
//            x: parent.width/2 - width/2
//            y: parent.height/2 - height/2
//            modal: true
//            dim: true
//            closePolicy: QtControls.Popup.CloseOnPressOutside
//            standardButtons: QtControls.Dialog.Yes | QtControls.Dialog.No

//            onVisibleChanged: {
//                if(visible)
//                    BackHandler.pushHandler(this, function(){visible = false})
//                else {
//                    BackHandler.removeHandler(this)
//                    Tools.jsDelayCall(400, dialog.destroy)
//                }
//            }

//            onAccepted: Qt.openUrlExternally("market://details?id=co.aseman.TgStats")

//            QtControls.Label {
//                id: label
//                font.pixelSize: 9*Devices.fontDensity
//                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
//                width: {
//                    var res = rateDialog.width - 80*Devices.density
//                    if(res > 500*Devices.density)
//                        res = 500*Devices.density
//                    return res
//                }
//                text: qsTr("If you enjoy using this app, would you mind taking a moment to rate it? It won't take more than a minute. Thank you for your support!")
//            }
//        }
//    }
}
