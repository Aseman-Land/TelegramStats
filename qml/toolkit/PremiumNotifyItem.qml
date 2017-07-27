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
import QtQuick.Layouts 1.3 as QtLayouts
import TelegramQml 2.0 as Telegram
import Qt.labs.controls.material 1.0
import "../toolkit" as Toolkit
import "../globals"

Rectangle {
    id: prmNotifyItem
    color: TgChartsGlobals.backgroundColor

    property string title
    property variant messagesModel

    property variant waitDialog

    NullMouseArea { anchors.fill: parent }

    AsemanFlickable {
        id: flick
        anchors.fill: parent
        contentHeight: sceneItem.height
        contentWidth: sceneItem.width

        Item {
            id: sceneItem
            width: flick.width
            height: {
                var res = column.height + 80*Devices.density
                if(res < flick.height)
                    res = flick.height
                return res
            }

            Column {
                id: column
                width: parent.width*0.7
                anchors.centerIn: parent

                Image {
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: 128*Devices.density
                    height: width
                    sourceSize: Qt.size(1.2*width, 1.2*height)
                    source: "../files/premium-account.png"
                    fillMode: Image.PreserveAspectFit
                }

                Item { width: 1; height: 16*Devices.density }

                QtControls.Label {
                    width: parent.width
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    font.pixelSize: 10*Devices.fontDensity
                    text: qsTr("Please choose on of the below plans to view these stats.\n" +
                               "1. Send a message to %1 and let him/her to create stats using this application.\n" +
                               "2. Buy premium package, unlocks all of the Telegram stats feature.").arg(title)
                }

                Item { width: 1; height: 8*Devices.density }

                QtControls.Button {
                    width: parent.width
                    height: 60*Devices.density
                    text: qsTr("Send message to %1").arg(title)
                    highlighted: true
                    Material.accent: TgChartsGlobals.masterColor
                    onClicked: {
                        message_dialog.createObject(prmNotifyItem).open()
                    }
                }

                QtControls.Button {
                    width: parent.width
                    height: 60*Devices.density
                    text: qsTr("Buy Premium package")
                    highlighted: true
                    Material.accent: Material.Orange
                    onClicked: TgChartsStore.activePremium()
                }
            }
        }
    }

//    Component {
//        id: message_dialog
//        QtControls.Dialog {
//            id: dialog
//            title: qsTr("Send message to %1").arg(page.title)
//            contentHeight: label.height
//            contentWidth: label.width
//            x: parent.width/2 - width/2
//            y: parent.height/2 - height/2
//            modal: true
//            dim: true
//            closePolicy: QtControls.Popup.CloseOnPressOutside

//            onVisibleChanged: {
//                if(visible)
//                    BackHandler.pushHandler(this, function(){visible = false})
//                else {
//                    BackHandler.removeHandler(this)
//                    Tools.jsDelayCall(400, dialog.destroy)
//                }
//            }

//            footer: QtControls.DialogButtonBox {
//                QtControls.Button {
//                    text: qsTr("Send")
//                    flat: true
//                    onClicked: {
//                        sendMessage(label.text)
//                        dialog.close()
//                    }
//                }
//                QtControls.Button {
//                    text: qsTr("Cancel")
//                    flat: true
//                    onClicked: dialog.close()
//                }
//            }

//            QtControls.Label {
//                id: label
//                font.pixelSize: 9*Devices.fontDensity
//                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
//                width: prmNotifyItem.width - 80*Devices.density
//                text: qsTr("Hey, take a look what I found.\n" +
//                           "It's an application to create stats from your telegram chats.\n" +
//                           "It will create awesome charts from your telegram history. Install it :)\n" +
//                           "aseman.co/tgstats")

//                Rectangle {
//                    anchors.fill: parent
//                    anchors.margins: -10*Devices.density
//                    z: -10
//                    color: Qt.darker(TgChartsGlobals.backgroundColor, 1.1)
//                }
//            }
//        }
//    }

    function sendMessage(msg) {
        if(waitDialog) return
        waitDialog = showGlobalWait( qsTr("Sending message..."), true )
        Tools.jsDelayCall(1000, function(){
            messagesModel.sendMessage(msg, null, null, function(){
                showTooltip( qsTr("Message sent") )
                waitDialog.destroy()
                unlockUser()
            })
        })
    }

    function unlockUser() {
        var chats = TgChartsGlobals.unlockedChats
        if(!chats)
            chats = new Array
        else
            chats = Tools.toStringList(chats)

        chats[chats.length] = messagesModel.currentPeer.userId + ""
        TgChartsGlobals.unlockedChats = Tools.toStringList(chats)
    }
}
