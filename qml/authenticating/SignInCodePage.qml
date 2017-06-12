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
import TelegramQml 2.0
import QtQuick.Controls 2.0
import "../globals"

Item {
    signal codeSend(string code)

    Column {
        width: parent.width - 40*Devices.density
        anchors.centerIn: parent

        Label {
            text: qsTr("Code Request...") + TgChartsGlobals.translator.refresher
            font.pixelSize: 15*Devices.fontDensity
            width: parent.width
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        }

        Item { width: 1; height: 20*Devices.density }

        Label {
            text: qsTr("We'll send you a code. Please enter the code below") + TgChartsGlobals.translator.refresher
            font.pixelSize: 9*Devices.fontDensity
            width: parent.width
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        }

        TextField {
            id: codeField
            width: parent.width
            placeholderText: qsTr("Code") + TgChartsGlobals.translator.refresher
            inputMethodHints: Qt.ImhDigitsOnly
            validator: RegExpValidator { regExp: /\d+/g }
            onAccepted: tryIt()
        }

        Button {
            width: parent.width
            text: qsTr("Send Code") + TgChartsGlobals.translator.refresher
            highlighted: true
            onClicked: tryIt()
        }
    }

    function tryIt() {
        codeSend(codeField.text)
    }
}
