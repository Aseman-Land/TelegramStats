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
