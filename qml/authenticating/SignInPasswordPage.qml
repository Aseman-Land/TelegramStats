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
import Qt.labs.controls 1.0
import "../globals"

Item {
    signal passwordSend(string password)

    Column {
        width: parent.width - 40*Devices.density
        anchors.centerIn: parent

        Label {
            text: qsTr("2-Step Authenticate...") + TgChartsGlobals.translator.refresher
            font.pixelSize: 15*Devices.fontDensity
            width: parent.width
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        }

        Item { width: 1; height: 20*Devices.density }

        Label {
            text: qsTr("Your account protected using a password. Please enter your password to login.") + TgChartsGlobals.translator.refresher
            font.pixelSize: 9*Devices.fontDensity
            width: parent.width
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        }

        TextField {
            id: codeField
            width: parent.width
            placeholderText: qsTr("Password") + TgChartsGlobals.translator.refresher
            echoMode: TextInput.Password
            passwordMaskDelay: 1000
            passwordCharacter: '*'
            onAccepted: tryIt()
        }

        Button {
            width: parent.width
            text: qsTr("Login") + TgChartsGlobals.translator.refresher
            highlighted: true
            onClicked: tryIt()
        }
    }

    function tryIt() {
        passwordSend(codeField.text)
    }
}
