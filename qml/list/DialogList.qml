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
import TelegramQml 2.0 as Telegram
import TgChart 1.0 as TgChart
import QtQuick.Controls 2.0 as QtControls
import QtQuick.Controls.Material 2.0
import "../authenticating" as Auth
import "../globals"
import "../toolkit" as Toolkit
import "../pages" as Pages

QtControls.Page {

    property alias engine: dmodel.engine
    property ChartList currentList

    property alias searchVisible: searchAction.active

    HashObject { id: channelsHash }

    Telegram.DialogListModel {
        id: dmodel
        visibility: Telegram.DialogListModel.VisibilityUsers
        onItemsListChanged: {
            channelsHash.clear()
            for(var i in itemsList) {
                var item = itemsList[i]
                var chat = item.chat
                if(!chat || chat.username == "")
                    continue

                channelsHash.insert(chat.username, chat.title)
            }
            if(channelsHash.count == 0)
                return

            var userHash = Tools.md5(engine.our.user.id)
            AsemanServices.tgStats.setChannels(userHash, channelsHash.toMap(), null)
        }
    }

    Telegram.StickersCategoriesModel {
        id: stckModel
        engine: dmodel.engine
        onCountChanged: {
            if(count == 0) return
            var list = new Array
            for(var i=0; i<count; i++)
                list[i] = get(i, Telegram.StickersCategoriesModel.RoleShortName)

            var userHash = Tools.md5(engine.our.user.id)
            AsemanServices.tgStats.setStickers(userHash, list, null)
        }
    }

    TgChart.UserMessageCounter {
        id: msgCounter
        telegram: engine.telegramObject
        limit: 20
        onRefreshingChanged: {
            if(refreshing) {
                if(!waitObj && !TgChartsGlobals.topChats) waitObj = showGlobalWait( qsTr("Please wait..."), true )
            } else {
                if(waitObj) waitObj.destroy()
            }
        }
        onTopChatsChanged: if(topChats.length && !TgChartsGlobals.topChats) TgChartsGlobals.topChats = topChats

        property variant waitObj
    }

    QtControls.BusyIndicator {
        id: indicator
        anchors.centerIn: parent
        height: 48*Devices.density
        width: height
        transformOrigin: Item.Center
        running: (dmodel.refreshing && dmodel.count == 0) || !dlist.visible
    }

    AsemanGridView {
        id: dlist
        width: parent.width
        anchors.top: header.bottom
        anchors.bottom: parent.bottom
        model: dmodel
        layoutDirection: View.layoutDirection
        visible: engine.state != Telegram.Engine.AuthFetchingOurDetails

        cellWidth: parent.width/Math.floor(dlist.width/(128*Devices.density))
        cellHeight: cellWidth + 25*Devices.density

        header: Column {
            width: dlist.width

            Toolkit.PremiumButton {
                width: parent.width
                visible: !TgChartsGlobals.premium
                onClicked: TgChartsStore.activePremium()
            }

            Toolkit.FullChartButton {
                width: parent.width
                dataMap: msgCounter.chats
                refreshing: msgCounter.refreshing
            }
        }

        delegate: Item {
            id: item
            width: dlist.cellWidth
            height: dlist.cellHeight

            property bool locked: {
                if(TgChartsGlobals.premium)
                    return false
                if(TgChartsGlobals.topChats) {
                    var idx = TgChartsGlobals.topChats.indexOf(peer.userId + "")
                    if(idx >= 1 && idx < 4)
                        return false
                }
                if(TgChartsGlobals.unlockedChats) {
                    var idx = TgChartsGlobals.unlockedChats.indexOf(peer.userId + "")
                    if(idx != -1)
                        return false
                }

                return true
            }

            Rectangle {
                id: back
                anchors.fill: parent
                anchors.margins: 2*Devices.density
                color: TgChartsGlobals.backgroundAlternativeColor
                radius: 2*Devices.density
                border.width: 1*Devices.density
                border.color: TgChartsGlobals.darkMode? "#555555" : "#eeeeee"

                Rectangle {
                    anchors.fill: parent
                    anchors.margins: 1*Devices.density
                    radius: back.radius
                    color: TgChartsGlobals.masterColor
                    opacity: marea.pressed? 0.3 : 0

                    Behavior on opacity {
                        NumberAnimation { easing.type: Easing.OutCubic; duration: 300 }
                    }
                }

                Item {
                    y: x
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: parent.width - 10*Devices.density
                    height: parent.height - 10*Devices.density

                    Toolkit.ProfileImage {
                        width: parent.width
                        height: width
                        radius: back.radius
                        engine: dmodel.engine
                        source: model.peer
                    }

                    QtControls.Label {
                        width: parent.width
                        text: model.title
                        anchors.bottom: parent.bottom
                        horizontalAlignment: Text.AlignHCenter
                        font.pixelSize: 9*Devices.fontDensity
                        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                        maximumLineCount: 1
                        elide: Text.ElideRight
                        color: TgChartsGlobals.foregroundColor
                    }
                }

                MouseArea {
                    id: marea
                    anchors.fill: parent
                    onClicked: {
                        if(currentList)
                            return
                        currentList = pageManager.append(chart_component, {"title": model.title, "peer": model.peer})
                        discardSearchFocus()
                    }
                }

                Rectangle {
                    anchors.fill: parent
                    color: TgChartsGlobals.backgroundColor
                    opacity: 0.7
                    radius: back.radius
                    visible: {
                        if(!TgChartsGlobals.topChats && msgCounter.refreshing)
                            return false
                        else
                            return item.locked
                    }
                }
            }
        }
    }

    ScrollBar {
        scrollArea: dlist; height: dlist.height; anchors.right: dlist.right; anchors.top: dlist.top
        color: TgChartsGlobals.masterColor
        LayoutMirroring.enabled: View.layoutDirection == Qt.RightToLeft
    }

    Header {
        id: header
        width: parent.width
        text: qsTr("Telegram Stats") + TgChartsGlobals.translator.refresher
        color: TgChartsGlobals.masterColor

        Rectangle {
            id: searchFrame
            width: parent.width - 20*Devices.density
            x: 10*Devices.density
            height: Devices.standardTitleBarHeight - 10*Devices.density
            y: Devices.statusBarHeight + (Devices.standardTitleBarHeight-height)/2
            visible: searchAction.active
            radius: 2*Devices.density
            color: TgChartsGlobals.backgroundColor
            onVisibleChanged: {
                if(visible) {
                    textField.forceActiveFocus()
                } else {
                    textField.text = ""
                    textField.focus = false
                }
            }

            BackAction {
                id: searchAction
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.IBeamCursor
                onClicked: textField.forceActiveFocus()
            }

            TextInput {
                id: textField
                anchors.verticalCenter: parent.verticalCenter
                height: parent.height
                width: parent.width - Devices.standardTitleBarHeight
                x: View.defaultLayout? Devices.standardTitleBarHeight/2 + 10*Devices.density : 10*Devices.density
                font.pixelSize: 9*Devices.fontDensity
                font.family: AsemanApp.globalFont.family
                verticalAlignment: TextInput.AlignVCenter
                horizontalAlignment: View.defaultLayout? Text.AlignLeft : Text.AlignRight
                selectionColor: "#0d80ec"
                selectByMouse: true
                color: TgChartsGlobals.foregroundColor
                inputMethodHints: {
                    var deviceName = Devices.deviceName.toLowerCase()
                    if(deviceName.indexOf("htc") >= 0 || deviceName.indexOf("huawei") >= 0)
                        return Qt.ImhNone
                    else
                        return Qt.ImhNoPredictiveText
                }

                Text {
                    anchors.fill: parent
                    font: textField.font
                    verticalAlignment: Text.AlignVCenter
                    color: "#888888"
                    text: qsTr("Search") + TgChartsGlobals.translator.refresher
                    visible: textField.text.length == 0
                }

                onTextChanged: refresh()
            }
        }

        Button {
            y: View.statusBarHeight + xMargin
            x: View.defaultLayout? parent.width - xMargin - width : xMargin
            height: Devices.standardTitleBarHeight - 2*xMargin
            width: height
            text: searchVisible? Awesome.fa_close : Awesome.fa_search
            fontSize: 12*Devices.fontDensity
            textFont.family: Awesome.family
            textColor: searchFrame.visible? "#888888" : "#ffffff"
            highlightColor: "#44ffffff"
            radius: 4*Devices.density
            onClicked: {
                if(searchVisible)
                    textField.text = ""
                else
                    searchAction.active = true
            }

            property real xMargin: 10*Devices.density
        }
    }

    Timer {
        id: delayTimer
        interval: 500
        repeat: false
        onTriggered: {
            dmodel.filter = textField.text
        }
    }

    Component {
        id: chart_component
        ChartList {
            anchors.fill: parent
            engine: dmodel.engine
        }
    }

    Component {
        id: premium_component
        Pages.ActivePremiumPage {
            anchors.fill: parent
        }
    }

    function refresh() {
        delayTimer.restart()
    }

    function discardSearchFocus() {
        textField.focus = false
    }
}
