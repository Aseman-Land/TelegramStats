import AsemanTools 1.1
import AsemanTools.MaterialIcons 1.0
import QtQuick 2.7
import QtQuick.Controls 2.0 as QtControls
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.0
import "."
import "../globals"
import "../toolkit" as Toolkit

QtControls.Page {
    anchors.fill: parent
    clip: true

    QtControls.SwipeView {
        id: swipe
        width: parent.width
        anchors.top: tabbar.bottom
        anchors.bottom: parent.bottom
        onCurrentIndexChanged: tabbar.currentIndex = currentIndex

        LayoutMirroring.enabled: View.reverseLayout
        LayoutMirroring.childrenInherit: true

        AsemanFlickable {
            id: flick
            flickableDirection: Flickable.VerticalFlick
            contentHeight: scene.height
            contentWidth: scene.width
            clip: true
            LayoutMirroring.childrenInherit: false

            Item {
                id: scene
                width: flick.width
                height: {
                    var res = column.height + homeBtn.height
                    if(res < flick.height)
                        res = flick.height
                    return res
                }

                Column {
                    id: column
                    width: parent.width - 20*Devices.density
                    anchors.horizontalCenter: parent.horizontalCenter
                    y: parent.height/2 - height/2 - homeBtn.height/2

                    Image {
                        width: 128*Devices.density
                        height: width
                        sourceSize: Qt.size(width*2, height*2)
                        fillMode: Image.PreserveAspectCrop
                        source: "../files/icon.png"
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    Item { width: 1; height: 10*Devices.density }

                    QtControls.Label {
                        text: qsTr("Telegram Stats")
                        font.pixelSize: 15*Devices.fontDensity
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    Item { width: 1; height: 20*Devices.density }

                    QtControls.Label {
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: parent.width
                        font.pixelSize: 9*Devices.fontDensity
                        textFormat: Text.StyledText
                        text: qsTr("Telegram Stats is a telegram client, connect to your telegram and create amazing charts from your telegram history.<br />" +
                                   "It's an open-source application, created and designed by <a href=\"http://aseman.co\">Aseman Team</a> and released under the GPLv3 license.")
                        horizontalAlignment: Text.AlignHCenter
                        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                        onLinkActivated: Qt.openUrlExternally(link)
                    }
                }

                QtControls.Button {
                    id: homeBtn
                    width: parent.width/2
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom
                    text: qsTr("Home page")
                    highlighted: true
                    onClicked: Qt.openUrlExternally("http://aseman.co/tgstats")
                }
            }
        }

        Toolkit.OpenSourceProjects {
            LayoutMirroring.childrenInherit: false
        }
    }

    TabBar {
        id: tabbar
        width: parent.width
        anchors.top: header.bottom
        model: [qsTr("Application"), qsTr("Open-source")]
        fontSize: 10*Devices.fontDensity
        currentIndex: 0
        onCurrentIndexChanged: swipe.currentIndex = currentIndex
    }

    Header {
        id: header
        width: parent.width
        color: TgChartsGlobals.masterColor
        titleFont.pixelSize: 10*Devices.fontDensity
        text: qsTr("About")
    }
}
