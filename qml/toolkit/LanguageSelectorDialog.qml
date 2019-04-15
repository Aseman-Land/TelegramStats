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
import AsemanQml.Base 2.0
import AsemanQml.Controls 2.0
import AsemanQml.Awesome 2.0
import QtQuick.Controls 2.1 as QtControls
import "../globals"

Item {
    id: languageSelector

    property variant dialog

    function open() {
        if(!dialog)
            dialog = selector_component.createObject(languageSelector)

        dialog.open()
    }

    function close() {
        if(dialog)
            dialog.destroy()
    }

    Component {
        id: selector_component
        QtControls.Dialog {
            id: dialog
            title: qsTr("Select Language")
            standardButtons: QtControls.Dialog.Cancel
            contentHeight: listv.height
            contentWidth: listv.width
            x: parent.width/2 - width/2
            y: parent.height/2 - height/2
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
                    var res = languageSelector.width - 60*Devices.density
                    if(res > 300*Devices.density)
                        res = 300*Devices.density
                    return res
                }
                height: 300*Devices.density
                model: ListModel {}
                clip: true
                delegate: Item {
                    width: listv.width
                    height: 52*Devices.density

                    QtControls.Label {
                        anchors.centerIn: parent
                        font.pixelSize: 10*Devices.fontDensity
                        text: model.languageName
                    }

                    QtControls.ItemDelegate {
                        anchors.fill: parent
                        hoverEnabled: false
                        onClicked: {
                            TgChartsGlobals.localeName = model.localeName
                            dialog.close()
                            Tools.jsDelayCall(400, languageSelector.close)
                        }
                    }
                }

                Component.onCompleted: {
                    model.clear()
                    var map = TgChartsGlobals.translator.translations
                    for(var i in map)
                        model.append({"localeName": i, "languageName": map[i]})
                }
            }

            onRejected: close()
        }
    }
}
