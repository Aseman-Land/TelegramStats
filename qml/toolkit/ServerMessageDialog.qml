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
    id: serverMsgDialog

    property variant dialog
    property string message
    property bool fatal: false

    function open(msg, fatal) {
        serverMsgDialog.message = msg
        serverMsgDialog.fatal = fatal

        if(!dialog)
            dialog = dialog_component.createObject(View.root)

        dialog.open()
    }

    function close() {
        if(dialog)
            dialog.destroy()
    }

    Component {
        id: dialog_component
        Dialog {
            id: dialog
            title: qsTr("Server message")
            margins: 30*Devices.density
            z: 100000000
            color: TgChartsGlobals.backgroundAlternativeColor
            textColor: TgChartsGlobals.foregroundColor
            autoDestroy: true

            onVisibleChanged: {
                if(!visible) {
                    if(serverMsgDialog.fatal)
                        AsemanApp.exit(0)
                }
            }

            buttons: [qsTr("Ok")]

            onButtonClicked: close()

            delegate: QtControls.Label {
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
