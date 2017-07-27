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
import TelegramQml 2.0 as Telegram
import Qt.labs.controls.material 1.0
import "../toolkit" as Toolkit
import "../globals"

QtControls.Page {
    id: activePrmPage
    property string title: qsTr("Active Premium")

    AsemanFlickable {
        id: flick
        width: parent.width
        anchors.top: header.bottom
        anchors.bottom: parent.bottom
    }

    Header {
        id: header
        width: parent.width
        color: TgChartsGlobals.masterColor
        text: activePrmPage.title
    }
}
