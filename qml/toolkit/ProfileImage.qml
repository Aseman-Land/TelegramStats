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

import QtQuick 2.4
import AsemanQml.Awesome 2.0
import TelegramQml 2.0 as Telegram
import QtGraphicalEffects 1.0
import "../globals"

Item {
    id: profileImage

    property alias source: avatar_img.source
    property alias engine: avatar_img.engine
    property alias color: back.color
    property alias error: avatar_img.errorText
    property alias downloaded: avatar_img.downloaded
    property alias downloading: avatar_img.downloading
    property alias destination: avatar_img.destination
    property alias currentImage: avatar_img.currentImage
    property real radius: width/2

    readonly property bool disabled: radius == 0

    Rectangle {
        id: avatar_mask
        anchors.fill: avatar_img
        radius: profileImage.radius*2
        visible: false
    }

    Telegram.Image {
        id: avatar_img
        width: disabled? parent.width : parent.width*2
        height: disabled? parent.height : parent.height*2
        sourceSize: Qt.size(width, height)
        fillMode: Image.PreserveAspectCrop
        visible: disabled
        asynchronous: true
        cache: false

        Rectangle {
            id: back
            anchors.fill: parent
            color: avatar_img.thumbnailDownloaded || avatar_img.downloaded? "#00000000" : TgChartsGlobals.masterColor

            Text {
                anchors.centerIn: parent
                font.pixelSize: back.height/2
                color: avatar_img.thumbnailDownloaded || avatar_img.downloaded? "#00000000" : "#ffffff"
                font.family: Awesome.family
                text: Awesome.fa_user
            }
        }
    }

    OpacityMask {
        anchors.fill: parent
        source: disabled? null : avatar_img
        maskSource: disabled? null : avatar_mask
        cached: true
        visible: !disabled
    }
}

