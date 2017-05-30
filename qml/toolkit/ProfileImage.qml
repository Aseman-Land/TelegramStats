import QtQuick 2.4
import AsemanTools.Awesome 1.0
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

