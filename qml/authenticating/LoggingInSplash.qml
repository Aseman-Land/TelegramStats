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
import Qt.labs.controls 1.0
import Qt.labs.controls.material 1.0
import "../authenticating" as Auth
import "../globals"

Rectangle {
    color: TgChartsGlobals.masterColor

    property alias busy: indicator.running

    NullMouseArea { anchors.fill: parent }

    Column {
        anchors.centerIn: parent
        spacing: 10*Devices.density

        Image {
            anchors.horizontalCenter: parent.horizontalCenter
            width: 128*Devices.density
            height: width
            sourceSize: Qt.size(2*width, 2*height)
            cache: false
            source: "../files/icon2.png"
        }

        BusyIndicator {
            id: indicator
            anchors.horizontalCenter: parent.horizontalCenter
            height: 48*Devices.density
            width: height
            running: false
            transformOrigin: Item.Center
            Material.accent: "#ffffff"
        }
    }
}
